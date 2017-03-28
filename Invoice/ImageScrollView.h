//
//  ImageScrollView.h
//  Links
//
//  Created by zeppo on 14/11/26.
//  Copyright (c) 2014年 邻客物流. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPhotoController.h"

@interface ImageScrollView : UIScrollView
@property (nonatomic,weak) UIViewController *controller;
- (id)initWithImage:(UIImage *)image frame:(CGRect)frame;
@end
