//
//  CustomTabBarController.m
//  TestDemo
//
//  Created by qianxx on 16/7/6.
//  Copyright © 2016年 pby. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self settupViewControllers];
}


- (void)settupViewControllers
{
    UIViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FirstNavController"];    
    UIViewController *vc2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SecondNavController"];
    
    //设置TabBarItem样式
    [self setUpTabBarItemsAttributesForController];
    
    [self setViewControllers:@[vc1, vc2]];
}


///设置TabBarItem样式
- (void)setUpTabBarItemsAttributesForController
{
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"发票夹",
                            CYLTabBarItemImage : @"home_normal",
                            CYLTabBarItemSelectedImage : @"home_highlight",
                            };

     NSDictionary *dict2 = @{
                             CYLTabBarItemTitle : @"我的",
                             CYLTabBarItemImage : @"account_normal",
                             CYLTabBarItemSelectedImage : @"account_highlight",
                             };

    NSArray *tabBarItemsAttributes = @[dict1,dict2];
    self.tabBarItemsAttributes = tabBarItemsAttributes;
}



@end




