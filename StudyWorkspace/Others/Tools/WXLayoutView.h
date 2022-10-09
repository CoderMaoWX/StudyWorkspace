//
//  WXLayoutView.h
//  StudyWorkspace
//
//  Created by 610582 on 2022/9/23.
//  Copyright © 2022 MaoWX. All rights reserved.
//
// 此按钮用于约束布局时: 如果有 文本/图片 内容时需要设置外间距, 在无内容时整个按钮的大小自动为0,
// 并且所有外间距自动被忽略, 使用时只需根据自身逻辑设置 文本/图片 即可, 无需频繁更新约束来控制间距问题

#import <UIKit/UIKit.h>

///同时设置文本和图标时，控制图标和文本的排布位置
typedef NS_ENUM(NSUInteger, WXImagePlacementStyle) {
    WXImagePlacementLeading = 0, // 图标：左，文案：右
    WXImagePlacementTrailing,    // 图标：右，文案：左
    WXImagePlacementTop,         // 图标：上，文案：下
    WXImagePlacementBottom,      // 图标：下，文案：上
};

@interface WXLayoutView : UIView

///文本
@property(nonatomic, copy) NSString *text;
///文本对齐方式
@property(nonatomic) NSTextAlignment textAlignment;
///文本换行间距 (小于0将被忽略)
@property(nonatomic, assign) CGFloat lineSpacing;

///文本换行连接模式: (默认: NSLineBreakByTruncatingTail, 样式: "abcd...")
@property(nonatomic, assign) NSLineBreakMode lineBreakMode;
///文本字体
@property(nonatomic, strong) UIFont *font;
///文本颜色
@property(nonatomic, strong) UIColor *textColor;
///换行显示行数 (默认=0, 无限换行)
@property(nonatomic, assign) NSInteger numberOfLines;
///最大换行宽度
@property(nonatomic, assign) CGFloat preferredMaxLayoutWidth;
///富文本
@property(nonatomic, copy) NSAttributedString *attributedText;
///图片
@property(nonatomic, strong) UIImage *image;
///图片URL
@property(nonatomic, strong) NSString *imageURL;
///图片和文本布局位置
@property (nonatomic, assign) WXImagePlacementStyle imagePlacement;
///图片和文本的间距
@property (nonatomic, assign) CGFloat imageTextSpace;
///背景图片
@property(nonatomic, strong) UIImage *backgroundImage;
/**
 * 对控件设置外边距 (同时设置: 上/左/下/右)
 * 注意: 如果控件内容为空（文本和图标同时为空）时, 外边距自动被忽略, 控件宽高自动变为0, 控件不可见
 */
@property (nonatomic) UIEdgeInsets marginInset;

///单独设置: 上 外边距
@property (nonatomic, assign) CGFloat topMargin;
///单独设置: 左 外边距
@property (nonatomic, assign) CGFloat leftMargin;
///单独设置: 下 外边距
@property (nonatomic, assign) CGFloat bottomMargin;
///单独设置: 右 外边距
@property (nonatomic, assign) CGFloat rightMargin;

///简易版下载设置网络图片: 设置图片URL/placeholder/下载回调
- (void)setImageURL:(NSString *)imageURL
        placeholder:(UIImage *)placeholder
         completion:(UIImage *(^)(UIImage *))completion;

/**
 * 注意下面两个方法 (文字背景色 与 文字边框) 同时都调用时,
 * 内部内边距和圆角 优先生效的是 textBackgroundColor: 方法设置的
 */

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

