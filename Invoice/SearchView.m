//
//  SearchView.m
//  Invoice
//
//  Created by zeppo on 2017/3/20.
//  Copyright © 2017年 links. All rights reserved.
//

#import "SearchView.h"

@interface SearchView () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UILabel *searchLabel;
@property (nonatomic,strong) UIView *textFieldBG;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;

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
        
        self.textFieldBG.backgroundColor = [UIColor clearColor];
        searchCancelButton.backgroundColor = [UIColor clearColor];        
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
        _textField.delegate = self;
    }
    return _textField;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, self.searchView.bottom, self.width-16*2, self.height-self.searchView.bottom) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        
        [UIUtil drawLineInView:self frame:self.bounds color:[UIColor colorWithHex:0x000000 alpha:0.9]];
        
        [self addSubview:self.searchView];
        [self addSubview:self.tableView];
        
        
        //搜索记录
        self.dataArray = [NSMutableArray array];
        
        NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"SearchHistory.plist"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
            [self.dataArray addObjectsFromArray:array];
        }
        
        
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count > 0) {
        return self.dataArray.count+1;
    } else {
        return 2;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.contentView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.9];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArray.count > 0) {
        
        if (indexPath.row == 0) {
            
            [UIUtil drawLabelInView:cell.contentView frame:CGRectMake(0, 0, tableView.width, 44) font:[UIFont systemFontOfSize:14] text:@"最近搜索" isCenter:NO color:[UIColor whiteColor]];
            
        } else {
            NSString *keyword = self.dataArray[indexPath.row-1];
            
            [UIUtil drawLabelInView:cell.contentView frame:CGRectMake(0, 0, tableView.width, 44) font:[UIFont systemFontOfSize:14] text:keyword isCenter:NO color:[UIColor whiteColor]];

        }
        
    } else {
        if (indexPath.row == 0) {
            [UIUtil drawLabelInView:cell.contentView frame:CGRectMake(0, 0, tableView.width, 44) font:[UIFont systemFontOfSize:14] text:@"最近搜索" isCenter:NO color:[UIColor whiteColor]];

        } else {
            [UIUtil drawLabelInView:cell.contentView frame:CGRectMake(0, 0, tableView.width, 44) font:[UIFont systemFontOfSize:14] text:@"暂无搜索历史" isCenter:YES color:[UIColor whiteColor]];

        }
    }
    
    [UIUtil drawLineInView:cell.contentView frame:CGRectMake(0, 44-[UIUtil lineWidth], tableView.width, [UIUtil lineWidth]) color:[UIColor grayColor]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataArray.count > 0) {
        
        if (indexPath.row > 0) {
            
            NSString *keyword = self.dataArray[indexPath.row-1];
            
            [self.delegate searchWithKeyword:keyword];
            [self clickCancel];
        }
        
    }
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *keyword = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (keyword.length > 0) {
        
        [self.dataArray insertObject:keyword atIndex:0];
        NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"SearchHistory.plist"];
        [self.dataArray writeToFile:filePath atomically:YES];
        
        [self.delegate searchWithKeyword:keyword];
        [self clickCancel];
        
        return YES;
    } else {
        return NO;
    }
    
}

@end
