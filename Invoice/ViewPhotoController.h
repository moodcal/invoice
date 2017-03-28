//
//  ViewPhotoController.h
//  Links
//
//  Created by zeppo on 14/11/25.
//  Copyright (c) 2014年 邻客物流. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewPhotoController : UIViewController
@property (nonatomic,strong) NSArray *photoArray;
@property (nonatomic, assign) NSInteger currentIdx;
- (void)clickPhoto;
@end
