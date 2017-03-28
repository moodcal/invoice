//
//  ViewPhotoController.m
//  Links
//
//  Created by zeppo on 14/11/25.
//  Copyright (c) 2014年 邻客物流. All rights reserved.
//

#import "ViewPhotoController.h"
#import "ImageScrollView.h"

@interface ViewPhotoController () <UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *webImageOperationArray;
@end

@implementation ViewPhotoController

- (void)dealloc
{
    //取消图片下载
    for (id <SDWebImageOperation> webImageOperation in self.webImageOperationArray) {
        [webImageOperation cancel];
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_scrollView.width*self.photoArray.count, _scrollView.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        
        [UIUtil drawButtonInView:_scrollView frame:CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height) iconName:@"" target:self action:@selector(clickPhoto)];

        for (int i = 0; i < self.photoArray.count; i++) {
            [UIUtil drawCustomImgViewInView:_scrollView frame:CGRectMake(i*self.view.width+(self.view.width-105.5)/2, (self.view.height-92.5)/2, 105.5, 92.5) imageName:@"ViewPhotos.png" tag:100+i];
            
            //下载图片
            if ([self.photoArray[i] isKindOfClass:[UIImage class]]) {
                UIImage *image = self.photoArray[i];
                UIImageView *defaultImageView = (UIImageView *)[self.scrollView viewWithTag:100+i];
                [defaultImageView removeFromSuperview];
                
                DLog(@"%f,%f",image.size.width,image.size.height);
                
                ImageScrollView *imageScrollView = [[ImageScrollView alloc] initWithImage:image frame:CGRectMake((100+i-100)*self.view.width, 0, self.view.width, self.view.height)];
                imageScrollView.controller = self;
                [self.scrollView addSubview:imageScrollView];
            } else {
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                id <SDWebImageOperation> webImageOperation = [manager downloadImageWithURL:[NSURL URLWithString:self.photoArray[i]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    //显示当前进度
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (error) {
                        DLog(@"-request fail:%@-",error.description);
                    } else {
                        UIImageView *defaultImageView = (UIImageView *)[self.scrollView viewWithTag:100+i];
                        [defaultImageView removeFromSuperview];
                        
                        DLog(@"%f,%f",image.size.width,image.size.height);
                        
                        ImageScrollView *imageScrollView = [[ImageScrollView alloc] initWithImage:image frame:CGRectMake(i*self.view.width, 0, self.view.width, self.view.height)];
                        imageScrollView.controller = self;
                        [self.scrollView addSubview:imageScrollView];
                    }
                    
                }];
                
                [self.webImageOperationArray addObject:webImageOperation];
                
            }
            
        }
        
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.height-30, self.view.width, 30)];
        _pageControl.numberOfPages = self.photoArray.count;
        _pageControl.currentPage = 0;
        _pageControl.hidesForSinglePage=YES;
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webImageOperationArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor blackColor];
        
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
    if (self.currentIdx) {
        self.pageControl.currentPage = self.currentIdx;
        [self.scrollView scrollRectToVisible:CGRectMake(self.currentIdx*self.view.width, 0, self.view.width, self.view.height) animated:YES];
    }
    self.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^(void){
        self.view.alpha = 1;
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:[self.class description]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:[self.class description]];
}

- (void)clickPhoto
{
    [UIView animateWithDuration:0.3 animations:^(void){
        self.view.alpha = 0;
    } completion:^(BOOL finished){
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

-(void)pageChanged:(id)sender{
    NSArray *array = self.scrollView.subviews;
    for (UIView *view in array) {
        if ([view isKindOfClass:[ImageScrollView class]]) {
            ImageScrollView *imageScrollView = (ImageScrollView *)view;
            imageScrollView.zoomScale = 1.0;
        }
    }
    
    UIPageControl* control = (UIPageControl*)sender;
    NSInteger page = control.currentPage;
    [self.scrollView scrollRectToVisible:CGRectMake(page*self.view.width, 0, self.view.width, self.view.height) animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / self.view.width;
    
    if (index != self.pageControl.currentPage) {
        NSArray *array = self.scrollView.subviews;
        for (UIView *view in array) {
            if ([view isKindOfClass:[ImageScrollView class]]) {
                ImageScrollView *imageScrollView = (ImageScrollView *)view;
                imageScrollView.zoomScale = 1.0;
            }
        }
        
        self.pageControl.currentPage = index;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        int index = scrollView.contentOffset.x / self.view.width;
        
        if (index != self.pageControl.currentPage) {
            NSArray *array = self.scrollView.subviews;
            for (UIView *view in array) {
                if ([view isKindOfClass:[ImageScrollView class]]) {
                    ImageScrollView *imageScrollView = (ImageScrollView *)view;
                    imageScrollView.zoomScale = 1.0;
                }
            }
            
            self.pageControl.currentPage = index;
        }
    }
}



@end
