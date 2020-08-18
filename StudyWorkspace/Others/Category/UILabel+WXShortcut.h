//
//  UILabel+Shortcut.h
//  StudyWorkspace
//
//  Created by mao wangxin on 16/12/26.
//  Copyright © 2016年 leixiang. All rights reserved.
//
//  利用链式编程语法来写UILabel控件

/** eg:用法
 UILabel.initWithFrame(CGRectMake(50, 300, 100, 50))
 .wx_setText(@"哈哈乐")
 .wx_setTextColor(UIColor.blue())
 .wx_setTextAlignment(NSTextAlignmentCenter)
 .wx_setShadowColor([UIColor brownColor])
 .wx_setBackgroundColor([UIColor yellowColor])
 .wx_setBorderColor(UIColor.red())
 .wx_setBorderWidth(2)
 .wx_setCornerRadius(5)
 .wx_addToView(self.view);
 */

#import <UIKit/UIKit.h>

@interface UILabel (WXShortcut)

+ (UILabel * (^)(CGRect))initWithFrame;

- (UILabel * (^)(NSString *))wx_setText;
- (UILabel * (^)(UIFont *))wx_setFont;
- (UILabel * (^)(UIColor *))wx_setTextColor;
- (UILabel * (^)(UIColor *))wx_setBackgroundColor;
- (UILabel * (^)(UIColor *))wx_setShadowColor;
- (UILabel * (^)(UIColor *))wx_setBorderColor;
- (UILabel * (^)(CGFloat))wx_setBorderWidth;
- (UILabel * (^)(CGFloat))wx_setCornerRadius;

- (UILabel * (^)(CGSize))wx_setShadowOffset;
- (UILabel * (^)(NSTextAlignment))wx_setTextAlignment;
- (UILabel * (^)(NSLineBreakMode))wx_setLineBreakMode;
- (UILabel * (^)(NSAttributedString *))wx_setAttributedText;
- (UILabel * (^)(UIColor *))wx_setHighlightedTextColor;
- (UILabel * (^)(BOOL))wx_setUserInteractionEnabled;
- (UILabel * (^)(BOOL))wx_setEnabled;
- (UILabel * (^)(NSInteger))wx_numberOfLines;

- (UILabel * (^)(UIView *))wx_addToView;


@end
