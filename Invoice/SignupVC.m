//
//  SignupVC.m
//  Invoice
//
//  Created by yanzheng on 2017/3/21.
//  Copyright © 2017年 links. All rights reserved.
//

#import "SignupVC.h"
#import "MZTimerLabel/MZTimerLabel.h"

@interface SignupVC ()<MZTimerLabelDelegate>
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
- (IBAction)signupAction:(id)sender;
- (IBAction)codeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (nonatomic, copy) NSString *code;

@end

@implementation SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.secondLabel.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.secondLabel removeFromSuperview];
}

- (IBAction)signupAction:(id)sender {
    if (self.code.length == 0) {
        return;
    }
    
    if (![self.code isEqualToString:self.codeTextField.text]) {
        return;
    }

    [[SRUserManager sharedInstance] signupWithName:self.phoneTextField.text password:self.passwordTextField.text code:self.code success:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    } fail:^(NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];    
}

- (IBAction)codeAction:(id)sender {
    self.secondLabel.hidden = NO;
    self.codeButton.hidden = YES;
    
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneTextField.text forKey:@"phone"];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    [sessionManager POST:ApiMethodUserCode parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            self.code = [responseObject objectForKey:@"code"];

            MZTimerLabel *timer = [[MZTimerLabel alloc] initWithLabel:self.secondLabel andTimerType:MZTimerLabelTypeTimer];
            timer.timeFormat = @"ss";
            timer.delegate = self;
            [timer setCountDownTime:60];
            [timer start];
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

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime {
    self.code = nil;
    self.secondLabel.hidden = YES;
    self.codeButton.hidden = NO;
}

@end
