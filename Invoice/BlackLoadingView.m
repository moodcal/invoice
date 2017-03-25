//
//  BlackLoadingView.m
//  Links
//
//  Created by zeppo on 14-5-16.
//  Copyright (c) 2014年 zhengpeng. All rights reserved.
//

#import "BlackLoadingView.h"

@interface BlackLoadingView ()
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong) UILabel *loadingLabel;
@end

@implementation BlackLoadingView

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.center = CGPointMake(self.width/2, self.height/2);
        _activityIndicatorView.backgroundColor = [UIColor clearColor];
        [_activityIndicatorView startAnimating];
    }
    return _activityIndicatorView;
}


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 80, 80);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        self.layer.cornerRadius = 10;
        [self addSubview:self.activityIndicatorView];
    }
    return self;
}

@end
