//
//  FirstViewController.m
//  Invoice
//
//  Created by yanzheng on 2017/3/14.
//  Copyright © 2017年 links. All rights reserved.
//

#import "InvoiceListController.h"

@interface InvoiceListController ()
@property (nonatomic, strong) NSArray *invoices;
@end

@implementation InvoiceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
            if ([[responseObject objectForKey:@"err_code"] integerValue] == 401) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SRNotificationNeedSignin" object:nil];
            }
            DLog(@"request incomes error");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error: %@", error);
    }];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickSearch {
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    SearchView *searchView = [[SearchView alloc] initWithFrame:window.bounds];
    
    [window addSubview:searchView];
}


@end
