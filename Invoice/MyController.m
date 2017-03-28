//
//  SecondViewController.m
//  Invoice
//
//  Created by yanzheng on 2017/3/14.
//  Copyright © 2017年 links. All rights reserved.
//

#import "MyController.h"
#import "Profile.h"
#import "ExportController.h"

@interface MyController ()
- (IBAction)signoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic, strong) Profile *profile;

@end

@implementation MyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    [sessionManager GET:ApiMethodUserGetProfile parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            self.profile = [Profile yy_modelWithJSON:[responseObject objectForKey:@"profile"]];
            [self updateLabels];
        } else {
            if ([[responseObject objectForKey:@"error_code"] integerValue] == 401) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SRNotificationNeedSignin" object:nil];
            }
            DLog(@"request error");
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"error_msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error: %@", error);
    }];
}

- (void)updateLabels {
    self.companyNameLabel.text = self.profile.company.name;
    self.emailLabel.text = self.profile.email;
    self.phoneLabel.text = self.profile.phone;
}

- (IBAction)signoutAction:(id)sender {
    [[SRUserManager sharedInstance] signout];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ExportSegue"]) {
        ExportController *exporter = [segue destinationViewController];
        exporter.email = self.profile.email;
    }
}

@end
