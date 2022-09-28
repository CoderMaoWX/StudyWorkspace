//
//  WXLayoutView.h
//  StudyWorkspace
//
//  Created by 610582 on 2022/9/23.
//  Copyright © 2022 MaoWX. All rights reserved.
//
// 此按钮用于约束布局时: 如果有 文本/图片 内容时需要设置内间距, 在无内容时整个按钮的大小自动为0,
// 并且所有内间距自动被忽略, 使用时只需根据自身逻辑设置 文本/图片 即可, 无需频繁更新约束来控制间距问题

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WXImagePlacementStyle) {
    WXImagePlacementLeading = 0, // image在左，label在右
    WXImagePlacementTrailing,    // image在右，label在左
    WXImagePlacementTop,         // image在上，label在下
    WXImagePlacementBottom,      // image在下，label在上
};

@interface WXLayoutView : UIView

///图片和文本布局位置
@property (nonatomic, assign) WXImagePlacementStyle imagePlacement;
///图片和文本的间距
@property (nonatomic, assign) CGFloat imageTextSpace;
///文本
@property(nonatomic, copy) NSString *text;
///富文本
@property(nonatomic, copy) NSAttributedString *attributedText;
///文本字体
@property(nonatomic, strong) UIFont *font;
///文本颜色
@property(nonatomic, strong) UIColor *textColor;
///换行显示行数
@property(nonatomic, assign) NSInteger numberOfLines;
///最大换行宽度
@property(nonatomic, assign) CGFloat preferredMaxLayoutWidth;
///文本换行连接模式
@property(nonatomic, assign) NSLineBreakMode lineBreakMode;
///图片
@property(nonatomic, strong) UIImage *image;
///图片URL
@property(nonatomic, strong) NSString *imageURL;
///背景图片
@property(nonatomic, strong) UIImage *backgroundImage;
/**
 * 对控件设置内边距 (同时设置: 上/左/下/右)
 * 注意: 如果控件内容为空时, 内边距自动被忽略, 控件宽高自动变为0, 控件不可见
 */
@property (nonatomic) UIEdgeInsets paddingInset;

///单独设置 上 边距: (注意: 如果控件内容为空时, 内边距自动被忽略, 控件宽高自动变为0, 控件不可见)
@property (nonatomic, assign) CGFloat topPadding;
///单独设置 左 边距: (注意: 如果控件内容为空时, 内边距自动被忽略, 控件宽高自动变为0, 控件不可见)
@property (nonatomic, assign) CGFloat leftPadding;
///单独设置 下 边距: (注意: 如果控件内容为空时, 内边距自动被忽略, 控件宽高自动变为0, 控件不可见)
@property (nonatomic, assign) CGFloat bottomPadding;
///单独设置 右 边距: (注意: 如果控件内容为空时, 内边距自动被忽略, 控件宽高自动变为0, 控件不可见)
@property (nonatomic, assign) CGFloat rightPadding;

///绘制文本背景色/圆角 (类似于: 给文本打标的UI)
- (void)textBackgroundColor:(UIColor *)color
                 colorInset:(UIEdgeInsets)inset
               cornerRadius:(CGFloat)radius;

///绘制文本背景边框色/圆角 (类似于: 给文本打标的UI)
- (void)textBorderColor:(UIColor *)color
            borderWidth:(CGFloat)width
            borderInset:(UIEdgeInsets)inset
           cornerRadius:(CGFloat)radius;

@end

