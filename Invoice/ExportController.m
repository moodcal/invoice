//
//  ExportController.m
//  Invoice
//
//  Created by yanzheng on 2017/3/24.
//  Copyright © 2017年 links. All rights reserved.
//

#import "ExportController.h"

@interface ExportController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic,strong) UIView *blackLoadingView;

- (IBAction)startAction:(id)sender;
- (IBAction)endAction:(id)sender;
- (IBAction)sendAction:(id)sender;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end

@implementation ExportController

- (UIView *)blackLoadingView
{
    if (!_blackLoadingView) {
        _blackLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
        _blackLoadingView.backgroundColor = [UIColor clearColor];
        
        BlackLoadingView *loadingView = [[BlackLoadingView alloc] init];
        loadingView.center = CGPointMake(_blackLoadingView.width/2, _blackLoadingView.height/2);
        [_blackLoadingView addSubview:loadingView];
    }
    return _blackLoadingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startButton.layer.cornerRadius = 15;
    self.endButton.layer.cornerRadius = 15;
    self.startDate = [NSDate date];
    self.endDate = [NSDate date];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.sendButton setTitle:[NSString stringWithFormat:@"导出报告到: %@", self.email] forState:UIControlStateNormal];
    [self updateDates];
}

- (void)updateDates {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy-MM-dd";
    [self.startButton setTitle:[dateFormater stringFromDate:self.startDate] forState:UIControlStateNormal];
    [self.endButton setTitle:[dateFormater stringFromDate:self.endDate] forState:UIControlStateNormal];
}

- (IBAction)startAction:(id)sender {
    [ActionSheetDatePicker showPickerWithTitle:@"开始日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(startDateSelected:) origin:self.view];
}

- (IBAction)endAction:(id)sender {
    [ActionSheetDatePicker showPickerWithTitle:@"结束日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(endDateSelected:) origin:self.view];
}

- (void)startDateSelected:(NSDate *)date {
    self.startDate = date;
    [self updateDates];
}

- (void)endDateSelected:(NSDate *)date {
    self.endDate = date;
    [self updateDates];
}

- (IBAction)sendAction:(id)sender {
    if (!self.startDate || !self.endDate) {
        [SVProgressHUD showErrorWithStatus:@"请选择时间"];
        return;
    }
    
    if (!self.blackLoadingView.superview) {
        [self.view addSubview:self.blackLoadingView];
    }
    
    AFHTTPSessionManager *sessionManager = [[SRApiManager sharedInstance] sessionManager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.startButton.titleLabel.text forKey:@"beginDate"];
    [params setObject:self.endButton.titleLabel.text forKey:@"endDate"];
    [params appendInfo];
    [sessionManager.requestSerializer setValue:params.signature forHTTPHeaderField:@"sign"];
    [sessionManager POST:ApiMethodInvoicsExport parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response: %@", responseObject);
        
        [self.blackLoadingView removeFromSuperview];

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
        [self.blackLoadingView removeFromSuperview];

    }];
}

@end
