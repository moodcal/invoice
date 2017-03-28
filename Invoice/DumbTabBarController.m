//
//  DumbTabBarController.m
//  Invoice
//
//  Created by yanzheng on 2017/3/23.
//  Copyright © 2017年 links. All rights reserved.
//

#import "DumbTabBarController.h"
#import "ScanController.h"

@interface DumbTabBarController () {
    UIButton *scanButton;
}

@end

@implementation DumbTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSignVC:) name:@"SRNotificationNeedSignin" object:nil];
    
    UIImage *addButtonImage = [UIImage imageNamed:@"tab-saoyisao"];
    [self addCenterButtonWithImage:addButtonImage highlightImage:addButtonImage inTab:self];
}

-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage inTab:(UITabBarController *)tabController
{
    scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    scanButton.frame = CGRectMake(0.0, 0.0, 34, 34);
    [scanButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [scanButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    scanButton.center = CGPointMake(tabController.tabBar.frame.size.width/2, tabController.tabBar.frame.size.height/2);
    [scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:scanButton];
}

- (void)scanAction:(id)sender {
    ScanController *controller = [ScanController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)presentSignVC:(NSNotification *)notification {
    [self performSegueWithIdentifier:@"SignInSegue" sender:self];
}


@end
