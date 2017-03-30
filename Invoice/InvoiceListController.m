//
//  FirstViewController.m
//  Invoice
//
//  Created by yanzheng on 2017/3/14.
//  Copyright © 2017年 links. All rights reserved.
//

#import "InvoiceListController.h"
#import "InvoiceCell.h"
#import "SearchResultController.h"

#define INVOICE_PAGE_SIZE @15

@interface InvoiceListController () <UICollectionViewDelegate, UICollectionViewDataSource, SearchViewDelegate>
@property (nonatomic, strong) NSArray *invoices;
@property (nonatomic, strong) NSArray *filteredInvoices;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexHeightConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, assign) BOOL noMoreData;
@property (nonatomic, assign) NSUInteger pageIndex;
@end

@implementation InvoiceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSegmentIndex];
    self.invoices = [NSMutableArray array];
    
    self.indexHeightConstraint.constant = 0;
        
    UIImage *image = [UIImage imageNamed:@"index-seach"];
    float width = [UIUtil textWidth:@"搜索" font:[UIFont systemFontOfSize:15]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width+5+width, image.size.height)];
    view.userInteractionEnabled = YES;
    [UIUtil drawCustomImgViewInView:view frame:CGRectMake(0, (view.height-image.size.height)/2, image.size.width, image.size.height) imageName:@"index-seach"];
    [UIUtil drawLabelInView:view frame:CGRectMake(image.size.width+5, 0, width, view.height) font:[UIFont systemFontOfSize:15] text:@"搜索" isCenter:NO color:[UIColor whiteColor]];
    [UIUtil drawButtonInView:view frame:view.bounds iconName:@"" target:self action:@selector(clickSearch)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pageIndex = 0;
    [self requestData];
}

- (void)requestData {
    if (self.noMoreData && self.pageIndex > 0) return;
        
    if (![[SRUserManager sharedInstance] token]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SRNotificationNeedSignin" object:nil];
        return;
    }
    
    self.pageIndex += 1;
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld", self.pageIndex] forKey:@"page"];
    [params setObject:INVOICE_PAGE_SIZE forKey:@"page_size"];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    [sessionManager GET:ApiMethodInvoicsList parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSArray *pagedInvoices = [NSArray yy_modelArrayWithClass:[Invoice class] json:[responseObject objectForKey:@"invoices"]];
            if (pagedInvoices.count < INVOICE_PAGE_SIZE.integerValue) self.noMoreData = YES;
            self.invoices = [self.invoices arrayByAddingObjectsFromArray:pagedInvoices];
            [self reloadInvoices];
        } else {
            if ([[responseObject objectForKey:@"error_code"] integerValue] == 401) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SRNotificationNeedSignin" object:nil];
            }
            DLog(@"request error");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error: %@", error);
    }];    
}

- (void)reloadInvoices {
    NSInteger status = 0;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        status = 1;
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        status = 2;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"inspect_status", [NSNumber numberWithInteger:status]];
    self.filteredInvoices = [self.invoices filteredArrayUsingPredicate:predicate];
    [self.collectionView reloadData];
}

- (void)configSegmentIndex {
    self.segmentedControl.selectionIndicatorHeight = 2.0f;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:16]};
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
    self.segmentedControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.segmentedControl.sectionTitles = @[@"验伪成功", @"验伪失败", @"未验证"];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.shouldAnimateUserSelection = YES;
    self.segmentedControl.layer.cornerRadius = 4.0f;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 2;
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    [self reloadInvoices];
}

#pragma collection view
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        [self requestData];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 100;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        height = 100;
    }
    return CGSizeMake(collectionView.size.width-40, height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.filteredInvoices count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Invoice *invoice = [self.filteredInvoices objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"InvoiceCell";
//    if (self.segmentedControl.selectedSegmentIndex == 0) {
//        cellIdentifier = @"VerifiedInvoiceCell";
//    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
//        cellIdentifier = @"InvoiceCell";
//    } else {
//        cellIdentifier = @"InvoiceSelectionCell";
//    }
    InvoiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell configWithInvoice:invoice];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    InvoiceDetailController *controller = [[InvoiceDetailController alloc] init];
    controller.invoice = [self.filteredInvoices objectAtIndex:indexPath.row];
    controller.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)clickSearch {
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    SearchView *searchView = [[SearchView alloc] initWithFrame:window.bounds];
    searchView.delegate = self;
    [window addSubview:searchView];
}

#pragma mark - SearchViewDelegate
- (void)searchWithKeyword:(NSString *)keyword {
    self.keyword = keyword;
    [self performSegueWithIdentifier:@"SearchSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchResultController *resultController = segue.destinationViewController;
        resultController.keyword = self.keyword;
    }
}

@end
