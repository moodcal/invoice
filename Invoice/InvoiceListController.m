//
//  FirstViewController.m
//  Invoice
//
//  Created by yanzheng on 2017/3/14.
//  Copyright © 2017年 links. All rights reserved.
//

#import "InvoiceListController.h"

@interface InvoiceListController () <SearchViewDelegate>
@property (nonatomic, strong) NSArray *invoices;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation InvoiceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSegmentIndex];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(clickSearch)];

    if (![[SRUserManager sharedInstance] token]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SRNotificationNeedSignin" object:nil];
        return;
    }
    
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    [sessionManager GET:ApiMethodInvoicsList parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            self.invoices = [NSArray yy_modelArrayWithClass:[Invoice class] json:[responseObject objectForKey:@"invoices"]];
//            [self.collectionView reloadData];
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
    self.segmentedControl.selectedSegmentIndex = 0;
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
}

- (void)clickSearch {
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    SearchView *searchView = [[SearchView alloc] initWithFrame:window.bounds];
    searchView.delegate = self;
    [window addSubview:searchView];
}

#pragma mark - SearchViewDelegate
- (void)searchWithKeyword:(NSString *)keyword
{
    
}


@end
