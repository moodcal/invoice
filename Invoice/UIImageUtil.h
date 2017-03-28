//
//  UIImageUtil.h
//  LinksDriver
//
//  Created by wyf on 15/3/16.
//  Copyright (c) 2015年 wyf. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BIFSingleton.h"

@interface UIImageUtil : NSObject

+ (UIImageUtil *)sharedInstance;
- (UIImage *)processImage:(UIImage *)image;

@end
