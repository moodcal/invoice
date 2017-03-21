//
//  SearchView.h
//  Invoice
//
//  Created by zeppo on 2017/3/20.
//  Copyright © 2017年 links. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegate <NSObject>

- (void)searchWithKeyword:(NSString *)keyword;

@end

@interface SearchView : UIView
@property (nonatomic,weak) id<SearchViewDelegate> delegate;
@end
