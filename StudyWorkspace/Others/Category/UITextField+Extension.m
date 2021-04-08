//
//  UITextField+Extension.m
//  StudyWorkspace
//
//  Created by mao wangxin on 16/12/26.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import "UITextField+Extension.h"
#import "NSString+Extension.h"
#import "UIView+WXExtension.h"
#import <objc/runtime.h>
#import "WXPublicHeader.h"

/** 通过这个属性名，就可以修改textField内部的占位文字颜色 */
static NSString * const LXPlaceholderColorKeyPath = @"placeholderLabel.textColor";
static const void *kLeftTextKey   = "leftTextKey";
static const void *kLeftViewWidth = "kLeftViewWidth";
static const void *UIButtonBlockKey = &UIButtonBlockKey;

typedef void (^TouchedBlock)(UIButton *btn);

/** 输入框字体大小 */
#define TextFieldFontSize           [UIFont systemFontOfSize:16]

/** 输入框字体颜色 */
#define TextFieldFontColor          Color_BlackFont

/** 输入框占位文字颜色 */
#define TextFieldPlaceholderColor   Color_grayFont

/** 输入框边框颜色 */
#define TextFieldborderColor        Color_TextBorderColor

/** 输入框右侧按钮背景色 */
#define TextFieldRightBgColor       Color_Main

/** 输入框右侧按钮不可点击色 */
#define TextFieldRightDisableColor  Color_grayFont

@implementation UITextField (Extension)

@dynamic leftText, leftImage, rightViewEnable;

/**
 *  设置左边文字
 */
- (void)setLeftText:(NSString *)leftText {
    objc_setAssociatedObject(self, kLeftTextKey, leftText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!leftText) return;
    
    UILabel *leftLab = [[UILabel alloc] init];
    leftLab.text = leftText;
    leftLab.font = TextFieldFontSize;
    leftLab.textColor = TextFieldFontColor;
    
    CGSize size = [leftText sizeWithFont:TextFieldFontSize constrainedToHeight:self.height];
    leftLab.frame = CGRectMake(0, 0, self.leftviewWidth?self.leftviewWidth.floatValue:size.width, self.height);
    
    self.leftView = leftLab;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (NSString *)leftText
{
    return objc_getAssociatedObject(self, kLeftTextKey);
}

- (NSNumber *)leftviewWidth
{
    return objc_getAssociatedObject(self, kLeftViewWidth);
}

- (void)setLeftviewWidth:(NSNumber *)leftviewWidth
{
    objc_setAssociatedObject(self, kLeftViewWidth, leftviewWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  设置左边图片
 */
- (void)setLeftImage:(UIImage *)leftImage
{
    if (!leftImage) return;
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, self.height)];
    leftView.contentMode = UIViewContentModeCenter;
    leftView.image = leftImage;
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

/**
 *  设置统一占位文字
 */
- (void)setPlaceholderText:(NSString *)placeholderText
{
    if (!placeholderText) return;
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: UIColorFromHex(0xc1c1c1), NSFontAttributeName: TextFieldFontSize}];
}

- (NSString *)placeholderText
{
    NSString *placeText = self.attributedPlaceholder.string;
    return placeText;
}

/**
 *  设置占位文字颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    // 这3行代码的作用：1> 保证创建出placeholderLabel，2> 保留曾经设置过的占位文字
    NSString *placeholder = self.placeholder;
    self.placeholder = @" ";
    self.placeholder = placeholder;
    
    // 处理xmg_placeholderColor为nil的情况：如果是nil，恢复成默认的占位文字颜色
    if (placeholderColor == nil) {
        placeholderColor = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
    }
    
    // 设置占位文字颜色
    [self setValue:placeholderColor forKeyPath:LXPlaceholderColorKeyPath];
}

/**
 *  获得占位文字颜色
 */
- (UIColor *)placeholderColor
{
    return [self valueForKeyPath:LXPlaceholderColorKeyPath];
}

/**
 *  设置右侧按钮是否可点击
 */
- (void)setRightViewEnable:(BOOL)rightViewEnable
{
    if (self.rightView && [self.rightView isKindOfClass:[UIButton class]]) {
        UIButton *rightBtn = (UIButton *)self.rightView;
        rightBtn.enabled = rightViewEnable;
    }
}

/**
 *  设置统一外观风格
 */
- (void)addBorderStyle {
    self.font = TextFieldFontSize;
    self.layer.borderColor = TextFieldborderColor.CGColor;
    self.returnKeyType = UIReturnKeyNext;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}

/**
 *  添加右侧按钮,返回点击回调
 */
- (UIButton *)setRightViewTitle:(NSString *)title
                     touchBlock:(void(^)(UIButton *))block
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 172/2, self.height)];
    rightBtn.titleLabel.font = TextFieldFontSize;
    [rightBtn setTitle:title forState:0];
    [rightBtn setTitle:title forState:UIControlStateDisabled];
    [rightBtn setTitleColor:WhiteColor forState:0];
    rightBtn.layer.cornerRadius = 3;
    rightBtn.layer.masksToBounds = YES;
    [rightBtn setTitleColor:TextFieldRightDisableColor forState:UIControlStateDisabled];
    rightBtn.backgroundColor = Color_Main;
//    [rightBtn setBackgroundImage:[UIImage wx_imageWithColor:Color_Main]  forState:UIControlStateNormal];
//    [rightBtn setBackgroundImage:[UIImage wx_imageWithColor:[Color_Main colorWithAlphaComponent:0.4]]  forState:UIControlStateHighlighted];
//    [rightBtn setBackgroundImage:[UIImage wx_imageWithColor:UIColorFromHex(0xdcdcdc)] forState:UIControlStateDisabled];
    
    self.rightView = rightBtn;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    if (block) {
        objc_setAssociatedObject(self, UIButtonBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [rightBtn addTarget:self action:@selector(wx_touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return rightBtn;
}

- (void)wx_touchUpInside:(UIButton *)rightBtn {
    TouchedBlock block = objc_getAssociatedObject(self, UIButtonBlockKey);
    if (block) {
        block(rightBtn);
    }
}

/**
 *  快速创建UITextField
 *  @param placeholder 占位文字
 */
+(UITextField *)textfieldWithPlaceholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*2/3, kDefaultCellHeight)];
    textField.font = TextFieldFontSize;
    textField.textColor = Color_BlackFont;
    textField.returnKeyType = UIReturnKeyNext;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textAlignment = NSTextAlignmentRight;
    textField.placeholderText = placeholder;
    return textField;
}

/**
 *  设置选中的范围
 *  备注：UITextField必须为第一响应者才有效
 *  @param range  range
 */
- (void) setSelectedRange:(NSRange)range
{
    UITextPosition* beginning = self.beginningOfDocument;

    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];

    [self setSelectedTextRange:selectionRange];
}

/**
 *  得到选中的范围
 *
 *  @return  NSRange
 */
- (NSRange) selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

@end
