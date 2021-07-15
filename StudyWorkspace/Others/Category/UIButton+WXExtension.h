//
//  UIButton+WXExtension.h
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WXButtonEdgeInsetsStyle) {
    WXButtonEdgeInsetsStyleTop, // image在上，label在下
    WXButtonEdgeInsetsStyleLeft, // image在左，label在右
    WXButtonEdgeInsetsStyleBottom, // image在下，label在上
    WXButtonEdgeInsetsStyleRight // image在右，label在左
};

typedef void (^WXTouchedBlock)(UIButton *btn);

@interface UIButton (WXExtension)

#pragma mark - UIButton (EnlargeEdge) ==================================================

/**
 扩大点击范围
 
 @param size 要增加的上, 下, 左, 右范围.
 */
- (void)setEnlargeEdge:(CGFloat) size;


/**
 扩大按钮指定点击范围
 
 @param top 上部分距离
 @param right 右边距离
 @param bottom 底部距离
 @param left 左边距离
 */
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

/**
 设置按钮右上角BageValue (目前统一针对购物车按钮数字)
 
 @param numberValue 大于100显示99, 等于0不显示
 */
- (void)showShoppingCarsBageValue:(NSInteger)numberValue;

/**
 设置按钮右上角BageValue
 
 @param numberValue 大于100显示99, 等于0不显示
 */
- (void)showShoppingCarsBageValue:(NSInteger)numberValue
                      bageBgColor:(UIColor *)bgColor
                    bageTextColor:(UIColor *)textColor
                  bageBorderWidth:(CGFloat)width
                  bageBorderColor:(UIColor *)borderColor;

#pragma mark - UIButton (GraphicBtn) ==================================================

- (void)initWithTitle:(NSString *)titles andImageName:(NSString *)imageName andTopHeight:(CGFloat)topHeigt andTextColor:(UIColor *)textColor;

/**
 *  设置属性文字
 *
 *  @param textArr   需要显示的文字数组,如果有换行请在文字中添加 "\n"换行符
 *  @param fontArr   字体数组, 如果fontArr与textArr个数不相同则获取字体数组中最后一个字体
 *  @param colorArr  颜色数组, 如果colorArr与textArr个数不相同则获取字体数组中最后一个颜色
 *  @param spacing   换行的行间距
 *  @param alignment 换行的文字对齐方式
 */
- (void)setAttriStrWithTextArray:(NSArray *)textArr
                         fontArr:(NSArray *)fontArr
                        colorArr:(NSArray *)colorArr
                     lineSpacing:(CGFloat)spacing
                       alignment:(NSTextAlignment)alignment;

#pragma mark - UIButton (UIButtonImageWithLable) ==================================================

/*
 * 左右排版
 */
- (void)setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style 标题和图片的布局样式
 *  @param space 标题和图片的间距
 */
- (void)layoutStyle:(WXButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space;

/**
 按钮点击以Block方式回调
 
 @param handler 点击事件的回调
 */
- (void)addTouchUpInsideHandler:(WXTouchedBlock)handler;

/**
 button不同状态的背景颜色（代替图片）
 
 @param backgroundColor 图片代替背景色
 @param state 状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor
                  forState:(UIControlState)state;


@end

