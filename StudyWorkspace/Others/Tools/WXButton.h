//
//  WXButton.h
//  StudyWorkspace
//
//  Created by Luke on 2022/3/13.
//  Copyright © 2022 MaoWX. All rights reserved.
//
// 此按钮用于约束布局时: 如果有 文本/图片 内容时需要设置内间距, 在无内容时整个按钮的大小自动为0, 并且所有内间距自动被忽略, 使用时只需根据自身逻辑设置 文本/图片 即可, 无需频繁更新约束来控制间距问题

#import <UIKit/UIKit.h>
#import "WXLayoutView.h"

//typedef NS_ENUM(NSUInteger, WXImagePlacementStyle) {
//    WXImagePlacementLeading = 0, // image在左，label在右
//    WXImagePlacementTrailing,    // image在右，label在左
//    WXImagePlacementTop,         // image在上，label在下
//    WXImagePlacementBottom,      // image在下，label在上
//};

@interface WXButton : UIButton

///图片和文本布局位置
@property (nonatomic, assign) WXImagePlacementStyle imagePlacement;
///图片和文本的间距
@property (nonatomic, assign) CGFloat imageTitleSpace;
///文本
@property(nonatomic, copy) NSString *title;
///富文本
@property(nonatomic, copy) NSAttributedString *attributedTitle;
///文本字体
@property(nonatomic, strong) UIFont *titleFont;
///文本颜色
@property(nonatomic, strong) UIColor *titleColor;
///换行显示行数
@property(nonatomic, assign) NSInteger numberOfLines;
///最大换行宽度
@property(nonatomic, assign) CGFloat preferredMaxLayoutWidth;
///文本链接模式
@property(nonatomic, assign) NSLineBreakMode textLineBreakMode;
///图片
@property(nonatomic, strong) UIImage *image;
///背景图片
@property(nonatomic, strong) UIImage *backgroundImage;

///内边距: (top/left/bottom/right)
@property (nonatomic, assign) CGFloat topPadding;
@property (nonatomic, assign) CGFloat leftPadding;
@property (nonatomic, assign) CGFloat bottomPadding;
@property (nonatomic, assign) CGFloat rightPadding;

@end
