//
//  UserProfileController.m
//  Invoice
//
//  Created by yanzheng on 2017/3/27.
//  Copyright © 2017年 links. All rights reserved.
//

#import "UserProfileController.h"

@interface UserProfileController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
- (IBAction)comfirmAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *socialCodeField;

@end

@implementation UserProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
}

- (IBAction)comfirmAction:(id)sender {
    [[SRUserManager sharedInstance] completeUserProfile:self.emailField.text company:self.companyField.text code:self.socialCodeField.text success:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    } fail:^(NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
}

@end
