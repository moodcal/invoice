//
//  SignVC.m
//  Invoice
//
//  Created by yanzheng on 2017/3/21.
//  Copyright © 2017年 links. All rights reserved.
//

#import "SignVC.h"

@interface SignVC ()
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
- (IBAction)signupAction:(id)sender;
- (IBAction)signinAction:(id)sender;

@end

@implementation SignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)signupAction:(id)sender {
}

- (IBAction)signinAction:(id)sender {
}


@end
