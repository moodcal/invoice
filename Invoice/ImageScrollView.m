//
//  ImageScrollView.m
//  Links
//
//  Created by zeppo on 14/11/26.
//  Copyright (c) 2014年 邻客物流. All rights reserved.
//

#import "ImageScrollView.h"

@interface ImageScrollView () <UIScrollViewDelegate>
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *button;

@end

@implementation ImageScrollView

- (id)initWithImage:(UIImage *)image frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.delegate = self;
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        self.zoomScale = 1.0;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.button = [UIUtil drawButtonInView:self frame:self.bounds iconName:@"" target:self action:@selector(clickPhoto)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView = imageView;
        
        float width = image.size.width;
        float height = image.size.height;
        
        imageView.width = width;
        imageView.height = height;
        
        if (width > self.width) {
            if (height > self.height) {
                if (width/self.width > height/self.height) {
                    imageView.width = self.width;
                    imageView.height = self.width*height/width;
                }
                else
                {
                    imageView.width = self.height*width/height;
                    imageView.height = self.height;
                }
            }
            else
            {
                imageView.width = self.width;
                imageView.height = self.width*height/width;
            }
        }
        else
        {
            if (height > self.height) {
                imageView.width = self.height*width/height;
                imageView.height = self.height;
            }
        }
        
        imageView.center = self.center;
        
        [self addSubview:imageView];
    }
    
    return self;
}

- (void)clickPhoto
{
    if ([self.controller respondsToSelector:@selector(clickPhoto)]) {
        [self.controller performSelector:@selector(clickPhoto)];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //调整frame
    self.imageView.left = self.imageView.width > self.width ? 0 : (self.width - self.imageView.width)/2;
    self.imageView.top = self.imageView.height > self.height ? 0 : (self.height - self.imageView.height)/2;
    
    self.button.frame = self.bounds;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

@end
