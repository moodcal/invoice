//
//  SearchView.m
//  Invoice
//
//  Created by zeppo on 2017/3/20.
//  Copyright © 2017年 links. All rights reserved.
//

#import "SearchView.h"

@interface SearchView ()
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UILabel *searchLabel;
@property (nonatomic,strong) UIView *textFieldBG;

@end

@implementation SearchView

- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.width, 44)];
        _searchView.backgroundColor = [UIColor clearColor];
        
        UIButton *searchCancelButton = [UIUtil drawButtonInView:_searchView frame:CGRectMake(_searchView.width-52, 0, 52, _searchView.height) text:@"取消" font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] target:self action:@selector(clickCancel)];
        [searchCancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        self.textFieldBG = [UIUtil drawLineInView:_searchView frame:CGRectMake(16, (_searchView.height-34)/2, _searchView.width-16-52, 34) color:[UIColor clearColor]];
        self.textFieldBG.layer.cornerRadius = self.textFieldBG.height/2;
        self.textFieldBG.layer.borderWidth = [UIUtil lineWidth];
        self.textFieldBG.layer.borderColor = [UIColor blueColor].CGColor;
        self.textFieldBG.userInteractionEnabled = YES;
        
        [UIUtil drawButtonInView:self.textFieldBG frame:self.textFieldBG.bounds iconName:@"" target:self action:@selector(clickInput)];
        
        UIImage *image = [UIImage imageNamed:@"search_icon.png"];

        [UIUtil drawCustomImgViewInView:self.textFieldBG frame:CGRectMake(10, (self.textFieldBG.height-image.size.height)/2, image.size.width, image.size.height) imageName:@"search_icon.png"];
        
        [self.textFieldBG addSubview:self.textField];
        
        self.searchLabel = [UIUtil drawLabelInView:self.textFieldBG frame:CGRectMake(self.textField.left, 0, [UIUtil textWidth:@"搜索" font:[UIFont systemFontOfSize:15]], self.textFieldBG.height) font:[UIFont systemFontOfSize:15] text:@"搜索" isCenter:NO color:[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1]];
        
    }
    return _searchView;
}

- (UITextField *)textField
{
    if (!_textField) {
        UIImage *image = [UIImage imageNamed:@"search_icon.png"];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10+image.size.width+5, (self.textFieldBG.height-20)/2, self.textFieldBG.width-(10+image.size.width+5)-10, 20)];
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.textColor = [UIColor whiteColor];
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        
        [UIUtil drawLineInView:self frame:self.bounds color:[UIColor colorWithHex:0x000000 alpha:0.8]];
        
        [UIUtil drawLineInView:self frame:CGRectMake(0, 0, self.width, 20+44) color:[UIColor blackColor]];

        
        [self addSubview:self.searchView];
        
        
    }
    return self;
}

- (void)clickCancel
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (void)clickInput
{
    if (![self.textField isFirstResponder]) {
        [self.textField becomeFirstResponder];
    }
}

- (void)textFieldDidChange:(id)sender
{
    self.searchLabel.hidden = self.textField.text.length > 0 ? YES : NO;
    
}
@end
