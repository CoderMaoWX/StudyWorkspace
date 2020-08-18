//
//  NSString+Extension.h
//  Yoshop
//
//  Created by 7F-shigm on 16/6/29.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

/// YY里面拷贝过来的URL编码的方法
- (NSString *)stringByURLEncode;

- (NSString*)decodeFromPercentEscapeString:(NSString *)string;

- (CGSize)textSizeWithFont:(UIFont *)font
         constrainedToSize:(CGSize)size
             lineBreakMode:(NSLineBreakMode)lineBreakMode;


+ (CGSize)sizeForString:(NSString*)content
                   font:(UIFont*)font
               maxWidth:(CGFloat) maxWidth;


- (NSDate *)date;

/**
 * 去掉回车与换行符
 */
- (NSString *)replaceBrAndEnterChar;

/**
 *  获取文字内容大小
 */
- (CGSize)textSizeWithFont:(UIFont *)font
         constrainedToSize:(CGSize)size
             lineBreakMode:(NSLineBreakMode)lineBreakMode
            paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;

/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;


/**
 *  计算 HTML NSAttributedString文字内容大小
 */
- (void)calculateHTMLText:(CGSize)contentSize
                labelFont:(UIFont *)labelFont
                lineSpace:(NSNumber *)lineSpace
                alignment:(NSTextAlignment)alignment
               completion:(void (^)(NSAttributedString *stringAttributed, CGSize calculateSize))completion;

/**
 *  获取属性文字
 *
 *  @param textArr   需要显示的文字数组,如果有换行请在文字中添加 "\n"换行符
 *  @param fontArr   字体数组, 如果fontArr与textArr个数不相同则获取字体数组中最后一个字体
 *  @param colorArr  颜色数组, 如果colorArr与textArr个数不相同则获取字体数组中最后一个颜色
 *  @param spacing   换行的行间距
 *  @param alignment 换行的文字对齐方式
 */
+ (NSMutableAttributedString *)getAttriStrByTextArray:(NSArray *)textArr
                                              fontArr:(NSArray *)fontArr
                                             colorArr:(NSArray *)colorArr
                                          lineSpacing:(CGFloat)spacing
                                            alignment:(NSTextAlignment)alignment;

@end
