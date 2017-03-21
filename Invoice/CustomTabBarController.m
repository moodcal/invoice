//
//  CustomTabBarController.m
//  TestDemo
//
//  Created by qianxx on 16/7/6.
//  Copyright © 2016年 pby. All rights reserved.
//

#import "CustomTabBarController.h"
#import <DCPathButton/DCPathButton.h>
#import "ScanController.h"
#import "RITLPhotoNavigationViewModel.h"
#import "RITLPhotoNavigationViewController.h"

@interface CustomTabBarController ()<DCPathButtonDelegate>

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSignVC:) name:@"SRNotificationNeedSignin" object:nil];

    [self settupViewControllers];
    [self configureDCPathButton];
}

- (void)presentSignVC:(NSNotification *)notification {
    [self performSegueWithIdentifier:@"SignInSegue" sender:self];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UIViewController *vc = viewController.childViewControllers.firstObject;
//    if ([vc class] == [IndexLibVC class]) {
//        [(IndexLibVC *)vc requestRates];
//    } else if ([vc class] == [ProjectLibVC class]) {
//        [(ProjectLibVC *)vc requestProjects];
//    }
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


- (void)configureDCPathButton
{
    // Configure center button
    //
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                         highlightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
    dcPathButton.delegate = self;
    
    // Configure item buttons
    //
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-music"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-place"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-place-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
//    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-camera"]
//                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-camera-highlighted"]
//                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
//                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
//    
//    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]
//                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]
//                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
//                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
//    
//    DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]
//                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]
//                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
//                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    // Add the item button into the center button
    //
    [dcPathButton addPathItems:@[itemButton_1,
                                 itemButton_2,
//                                 itemButton_3,
//                                 itemButton_4,
//                                 itemButton_5
                                 ]];
    
    // Change the bloom radius, default is 105.0f
    //
    dcPathButton.bloomRadius = 110.0f;
    dcPathButton.bloomAngel = 70.0;
    
    // Change the DCButton's center
    //
    dcPathButton.dcButtonCenter = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 25.5f);
    
    // Setting the DCButton appearance
    //
    dcPathButton.allowSounds = YES;
    dcPathButton.allowCenterButtonRotation = YES;
    
    dcPathButton.bottomViewColor = [UIColor blackColor];
    
    dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTop;
    
    [self.view addSubview:dcPathButton];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - DCPathButton Delegate

- (void)willPresentDCPathButtonItems:(DCPathButton *)dcPathButton {
    
    NSLog(@"ItemButton will present");
    
}

- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@"You tap %@ at index : %tu", dcPathButton, itemButtonIndex);
    
    if (itemButtonIndex == 0) {
        ScanController *controller = [ScanController new];
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        RITLPhotoNavigationViewModel * viewModel = [RITLPhotoNavigationViewModel new];
        
        __weak typeof(self) weakSelf = self;
        
        //    设置需要图片剪切的大小，不设置为图片的原比例大小
        //    viewModel.imageSize = _assetSize;
        
        viewModel.RITLBridgeGetImageBlock = ^(NSArray <UIImage *> * images){
            
            //获得图片
            __strong typeof(weakSelf) strongSelf = weakSelf;
            

            
        };
        
        viewModel.RITLBridgeGetImageDataBlock = ^(NSArray <NSData *> * datas){
            
            //可以进行数据上传操作..
            __strong typeof(weakSelf) strongSelf = weakSelf;

            
        };
        
        RITLPhotoNavigationViewController * viewController = [RITLPhotoNavigationViewController photosViewModelInstance:viewModel];
        
        [self presentViewController:viewController animated:true completion:nil];
    }
}

- (void)didPresentDCPathButtonItems:(DCPathButton *)dcPathButton {
    
    NSLog(@"ItemButton did present");
    
}


@end




