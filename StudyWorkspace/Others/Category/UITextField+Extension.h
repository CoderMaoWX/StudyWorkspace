//
//  UITextField+WXExtension.h
//  StudyWorkspace
//
//  Created by mao wangxin on 16/12/26.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)


/** 左边文字 */
@property (nonatomic, copy) NSString *leftText;

/** 左边图片 */
@property (nonatomic, strong) UIImage *leftImage;

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholderText;

/** 占位文字颜色  要在placeholder设置之前才有效.*/
@property (nonatomic, strong) UIColor *placeholderColor;

/** 设置右侧按钮是否可点击 */
@property (nonatomic, assign) BOOL rightViewEnable;

/**
 *  设置统一外观风格
 */
- (void)addBorderStyle;

/**
 *  添加右侧按钮,返回点击回调
 */
- (UIButton *)setRightViewTitle:(NSString *)title
                     touchBlock:(void(^)(UIButton *))block;

/**
 *  快速创建UITextField
 *  @param placeholder 占位文字
 */
+(UITextField *)textfieldWithPlaceholder:(NSString *)placeholder;

/**
 *  设置选中的范围
 *
 *  @param range  range
 */
- (void)setSelectedRange:(NSRange)range;

/**
 *  得到选中的范围
 *
 *  @return  NSRange
 */
- (NSRange)selectedRange;

@end
