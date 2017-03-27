//
//  SecondViewController.m
//  Invoice
//
//  Created by yanzheng on 2017/3/14.
//  Copyright © 2017年 links. All rights reserved.
//

#import "MyController.h"

@interface MyController ()
- (IBAction)signoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation MyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)signoutAction:(id)sender {
    [[SRUserManager sharedInstance] signout];
}

@end
