//
//  SignInVC.m
//  Invoice
//
//  Created by yanzheng on 2017/3/21.
//  Copyright © 2017年 links. All rights reserved.
//

#import "SignInVC.h"

@interface SignInVC ()
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
- (IBAction)signinAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.signinButton.layer.cornerRadius = 20;
    self.signinButton.backgroundColor = [UIColor mainColor];
}

- (IBAction)signinAction:(id)sender {
    [[SRUserManager sharedInstance] signinWithName:self.phoneTextField.text password:self.passwordTextField.text success:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    } fail:^(NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
}

@end
