//
//  DumbTabBarController.m
//  Invoice
//
//  Created by yanzheng on 2017/3/23.
//  Copyright © 2017年 links. All rights reserved.
//

#import "DumbTabBarController.h"
#import "ScanController.h"

@interface DumbTabBarController ()

@end

@implementation DumbTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSignVC:) name:@"SRNotificationNeedSignin" object:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    button.backgroundColor = [UIColor clearColor];
    UIImage *buttonImage = [UIImage imageNamed:@"chooser-button-tab"];
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0) {
        button.center = self.tabBar.center;
    } else {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
}

- (void)scanAction:(id)sender {
    ScanController *controller = [ScanController new];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)presentSignVC:(NSNotification *)notification {
    [self performSegueWithIdentifier:@"SignInSegue" sender:self];
}


@end
