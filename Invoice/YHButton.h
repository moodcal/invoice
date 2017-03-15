//
//  YHButton.h
//  Super
//
//  Created by zeppo on 15/12/11.
//  Copyright © 2015年 邻客物流. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHButton : UIButton
@property (nonatomic,weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *clickColor;

@end
