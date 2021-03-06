//
//  UIColor+HexColor.h
//  Links
//
//  Created by zhengpeng on 14-4-8.
//  Copyright (c) 2014年 zhengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+ (UIColor *) colorWithHex:(uint) hex alpha:(CGFloat)alpha;

+ (UIColor *)mainColor;

@end
