//
//  SearchResultController.m
//  Invoice
//
//  Created by yanzheng on 2017/3/28.
//  Copyright © 2017年 links. All rights reserved.
//

#import "SearchResultController.h"
#import "InvoiceCell.h"

@interface SearchResultController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *invoices;
@property (nonatomic, strong) NSArray *filteredInvoices;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexHeightConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation SearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSegmentIndex];
    
    self.indexHeightConstraint.constant = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![[SRUserManager sharedInstance] token]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SRNotificationNeedSignin" object:nil];
        return;
    }
    
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    [params setObject:@"100" forKey:@"page_size"];
    [params setObject:self.keyword forKey:@"keyword"];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    [sessionManager POST:ApiMethodInvoicsSearch parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            self.invoices = [NSArray yy_modelArrayWithClass:[Invoice class] json:[responseObject objectForKey:@"invoices"]];
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
    if (self.filteredInvoices.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"发票不存在"];
    }
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

@end
