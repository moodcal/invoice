//
//  ChangePhoneController.m
//  Invoice
//
//  Created by yanzheng on 2017/3/24.
//  Copyright © 2017年 links. All rights reserved.
//

#import "ChangePhoneController.h"

@interface ChangePhoneController ()<MZTimerLabelDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;
- (IBAction)comfirmAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
- (IBAction)codeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (nonatomic, copy) NSString *code;

@end

@implementation ChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.secondLabel.hidden = YES;
    self.codeButton.layer.cornerRadius = 4;
    self.secondLabel.layer.cornerRadius = 4;
    self.comfirmButton.layer.cornerRadius = 6;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.secondLabel removeFromSuperview];
}

- (IBAction)comfirmAction:(id)sender {
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneField.text forKey:@"phone"];
    [params setObject:self.codeField.text forKey:@"code"];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    [sessionManager POST:ApiMethodChangePhone parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
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

- (IBAction)codeAction:(id)sender {
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneField.text forKey:@"phone"];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    [sessionManager POST:ApiMethodUserCode parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            self.secondLabel.hidden = NO;
            self.codeButton.hidden = YES;
            self.code = [responseObject objectForKey:@"code"];
            MZTimerLabel *timer = [[MZTimerLabel alloc] initWithLabel:self.secondLabel andTimerType:MZTimerLabelTypeTimer];
            timer.timeFormat = @"ss";
            timer.delegate = self;
            [timer setCountDownTime:60];
            [timer start];
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

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime {
    self.code = nil;
    self.secondLabel.hidden = YES;
    self.codeButton.hidden = NO;
}

@end
