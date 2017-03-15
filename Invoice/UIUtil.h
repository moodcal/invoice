//
//  UtilUI.h
//  Anjuke
//
//  Created by zhengpeng on 12-11-12.
//  Copyright 2011年 anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHButton.h"

/*
 通用UI处理类
 */
@interface UIUtil : NSObject
//clear button
+ (YHButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame normalColor:(UIColor *)normalColor clickColor:(UIColor *)clickColor target:(id)target action:(SEL)action;
+ (YHButton *)getButtonWithFrame:(CGRect)frame normalColor:(UIColor *)normalColor clickColor:(UIColor *)clickColor target:(id)target action:(SEL)action;
//image button
+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action;
+ (UIButton *)getButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action;
+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets target:(id)target action:(SEL)action;
+ (UIButton *)getButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets target:(id)target action:(SEL)action;
+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action tag:(NSInteger)tag;
+ (UIButton *)getButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action tag:(NSInteger)tag;
+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets target:(id)target action:(SEL)action tag:(NSInteger)tag;
+ (UIButton *)getButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets target:(id)target action:(SEL)action tag:(NSInteger)tag;
//text button
+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action;
+ (UIButton *)getButtonWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action;
//image text button
+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets text:(NSString *)text font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action;
+ (UIButton *)getButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets text:(NSString *)text font:(UIFont *)font color:(UIColor *)color  target:(id)target action:(SEL)action;
//image clickbackground button
+ (UIButton *)drawClickBackgroundButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action;
+ (UIButton *)getClickBackgroundButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action;
//image image button
//+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets iconName2:(NSString *)iconName2 target:(id)target action:(SEL)action;
//+ (UIButton *)getButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets iconName2:(NSString *)iconName2 target:(id)target action:(SEL)action;
//image
+ (UIImageView *)drawCustomImgViewInView:(UIView *)view frame:(CGRect)frame imageName:(NSString *)imageName;
+ (UIImageView *)getCustomImgViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;
+ (UIImageView *)drawCustomImgViewInView:(UIView *)view frame:(CGRect)frame imageName:(NSString *)imageName tag:(NSInteger)tag;
+ (UIImageView *)getCustomImgViewWithFrame:(CGRect)frame imageName:(NSString *)imageName tag:(NSInteger)tag;
+ (UIImageView *)drawCustomImgViewInView:(UIView *)view frame:(CGRect)frame imageName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets;
+ (UIImageView *)getCustomImgViewWithFrame:(CGRect)frame imageName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets;
+ (UIImageView *)drawCustomImgViewInView:(UIView *)view frame:(CGRect)frame imageName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets tag:(NSInteger)tag;
+ (UIImageView *)getCustomImgViewWithFrame:(CGRect)frame imageName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets tag:(NSInteger)tag;
//label
+ (UILabel *)drawLabelInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter;
+ (UILabel *)getLabelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter;
+ (UILabel *)drawLabelInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter tag:(NSInteger)tag;
+ (UILabel *)getLabelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter tag:(NSInteger)tag;
+ (UILabel *)drawLabelInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter color:(UIColor *)color;
+ (UILabel *)getLabelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter color:(UIColor *)color;
//+ (UILabel *)drawLabelInView:(UIView *)view font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter color:(UIColor *)color;
+ (UILabel *)drawLabelMutiLineInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter;
+ (UILabel *)getLabelMutiLineWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter;
+ (UILabel *)drawLabelMutiLineInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter tag:(NSInteger)tag;
+ (UILabel *)getLabelMutiLineWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter tag:(NSInteger)tag;
+ (UILabel *)drawLabelMutiLineInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter color:(UIColor *)color;
+ (UILabel *)getLabelMutiLineWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter color:(UIColor *)color;
//textview
+ (UITextView *)drawTextViewInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text;
+ (UITextView *)getTextViewWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text;
//textfield
+ (UITextField *)drawTextFieldInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder  text:(NSString *)text;
+ (UITextField *)getTextFieldWithFrame:(CGRect)frame font:(UIFont *)font  placeholder:(NSString *)placeholder text:(NSString *)text;
//line
+ (UIView *)drawLineInView:(UIView *)view frame:(CGRect)frame color:(UIColor *)color;
+ (UIView *)drawLineInView:(UIView *)view frame:(CGRect)frame;
+ (UIView *)drawDefaultLineInView:(UIView *)view frame:(CGRect)frame;
+ (UIView *)getLineWithFrame:(CGRect)frame color:(UIColor *)color;
//other
+ (CGFloat)lineWidth;
+ (CGFloat)textWidth:(NSString *)text font:(UIFont *)font;
+ (CGFloat)textHeight:(NSString *)text font:(UIFont *)font;
+ (CGRect)textRect:(NSString *)text font:(UIFont *)font;
+ (CGRect)textRect:(NSString *)text font:(UIFont *)font size:(CGSize)size;
+ (CGFloat)labelWidth:(UILabel *)lbl;
+ (CGFloat)lableHeight:(UILabel *)lbl;


@end


