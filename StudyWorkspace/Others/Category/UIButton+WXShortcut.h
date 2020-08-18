//
//  UIButton+Shortcut.h
//  StudyWorkspace
//
//  Created by mao wangxin on 16/12/26.
//  Copyright © 2016年 leixiang. All rights reserved.
//
//  利用链式编程语法来写UIButton控件

/**  eg:用法
 UIButton *button = UIButton.initWithFrame(CGRectMake(50, 100, 100, 50))
 .wx_setTitle(@"呵呵哒",0)
 .wx_setTitleColor(UIColor.green(),0)
 .wx_setBackgroundColor(UIColor.hex(@"#dedddd"),0)
 .wx_setCornerRadius(5)
 .wx_setBorderColor(UIColor.black())
 .wx_setBorderWidth(2)
 .wx_setFrame(CGRectMake(20, 100, 150, 50))
 .wx_addToView(self.view);
 
 button.touchUpInside(^(UIButton * button) {
 NSLog(@"touchUpInside---呵呵哒");
 });
 */

#import <UIKit/UIKit.h>

typedef void (^TouchBlock) (UIButton * button);


@interface UIButton (WXShortcut)


+ (UIButton * (^)(CGRect))initWithFrame;
+ (UIButton * (^)(UIButtonType))initWithType;

- (UIButton * (^)(CGRect))wx_setFrame;
- (UIButton * (^)(UIFont *))wx_setFont;
- (UIButton * (^)(NSString *,UIControlState state))wx_setTitle;

- (UIButton * (^)(UIColor *,UIControlState state))wx_setTitleColor;
- (UIButton * (^)(UIColor *,UIControlState state))wx_setTitleShadowColor;
- (UIButton * (^)(UIImage *,UIControlState state))wx_setBackgroundImage;
- (UIButton * (^)(UIImage *,UIControlState state))wx_setImage;
- (UIButton * (^)(UIColor *,UIControlState state))wx_setBackgroundColor;

- (UIButton * (^)(NSAttributedString *,UIControlState state))wx_setAttributedTitle;

- (UIButton * (^)(CGFloat))wx_setCornerRadius;
- (UIButton * (^)(CGFloat))wx_setBorderWidth;
- (UIButton * (^)(UIColor *))wx_setBorderColor;

- (UIButton * (^)(BOOL))wx_setUserInteractionEnabled;
- (UIButton * (^)(BOOL))wx_setEnabled;

- (UIButton * (^)(UIView *))wx_addToView;

- (void (^)(TouchBlock))touchUpInside;

- (void)touchUpInsideBlock:(TouchBlock)handler;

@end
