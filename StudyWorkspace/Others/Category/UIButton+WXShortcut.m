//
//  UIButton+Shortcut.m
//  StudyWorkspace
//
//  Created by mao wangxin on 16/12/26.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import "UIButton+WXShortcut.h"
//#import "UIImage+WXExtension.h"
#import <objc/runtime.h>


static void * touchKey = &touchKey;

@implementation UIButton (WXShortcut)

+ (UIButton *(^)(CGRect))initWithFrame {
    
    return ^UIButton * (CGRect rect) {
        UIButton * button = [[UIButton alloc] initWithFrame:rect];
        return button;
    };
}

+ (UIButton *(^)(UIButtonType))initWithType {
    
    return ^UIButton * (UIButtonType type) {
        UIButton * button = [UIButton buttonWithType:type];
        return button;
    };
}

- (UIButton *(^)(CGRect))wx_setFrame {
    
    return ^UIButton * (CGRect rect) {        
        [self setFrame:rect];
        return self;
    };
}

- (UIButton *(^)(NSString *,UIControlState state))wx_setTitle {
    
    return ^UIButton * (NSString * title,UIControlState state) {
        [self setTitle:title forState:state];
        return self;
    };
}

- (UIButton *(^)(UIFont *))wx_setFont {
    
    return ^UIButton * (UIFont * font) {
        [self.titleLabel setFont:font];
        return self;
    };
}

- (UIButton *(^)(UIColor *,UIControlState state))wx_setTitleColor {
    
    return ^UIButton * (UIColor * color,UIControlState state) {
        [self setTitleColor:color forState:state];
        return self;
    };
}

- (UIButton *(^)(UIColor *,UIControlState state))wx_setTitleShadowColor {
    
    return ^UIButton * (UIColor * color,UIControlState state) {
        [self setTitleShadowColor:color forState:state];
        return self;
    };
}

- (UIButton *(^)(UIImage *,UIControlState state))wx_setBackgroundImage {
    
    return ^UIButton * (UIImage *image,UIControlState state) {
        [self setBackgroundImage:image forState:state];
        return self;
    };
}

- (UIButton *(^)(UIImage *,UIControlState state))wx_setImage {
    
    return ^UIButton * (UIImage *image,UIControlState state) {
        [self setImage:image forState:state];
        return self;
    };
}

- (UIButton * (^)(UIColor *,UIControlState state))wx_setBackgroundColor
{
    return ^UIButton * (UIColor *color,UIControlState state) {
//        [self setBackgroundImage:UIImage.withColor(color) forState:state];
        return self;
    };
}

- (UIButton * (^)(NSAttributedString *,UIControlState state))wx_setAttributedTitle
{
    return ^UIButton * (NSAttributedString *attr,UIControlState state) {
        [self setAttributedTitle:attr forState:state];
        return self;
    };
}

- (UIButton *(^)(CGFloat))wx_setCornerRadius {
    
    return  ^UIButton * (CGFloat force) {
        if (!self.layer.masksToBounds) {
            self.layer.masksToBounds = YES;
        }
        self.layer.cornerRadius = force;
        return self;
    };
}

- (UIButton *(^)(CGFloat))wx_setBorderWidth {
    
    return  ^UIButton * (CGFloat force) {
        if (!self.layer.masksToBounds) {
            self.layer.masksToBounds = YES;
        }
        self.layer.borderWidth = force;
        return self;
    };
}

- (UIButton *(^)(UIColor *))wx_setBorderColor {
    
    return ^UIButton * (UIColor * color) {
        if (!self.layer.masksToBounds) {
            self.layer.masksToBounds = YES;
        }
        self.layer.borderColor = color.CGColor;
        return self;
    };
}

- (UIButton * (^)(BOOL))wx_setUserInteractionEnabled {
    
    return ^UIButton * (BOOL is) {
        [self setUserInteractionEnabled:is];
        return self;
    };
}

- (UIButton * (^)(BOOL))wx_setEnabled {
    
    return ^UIButton * (BOOL is) {
        [self setEnabled:is];
        return self;
    };
}

- (UIButton * (^)(UIView *))wx_addToView {
    
    return ^UIButton *(UIView *sub) {
        [sub addSubview:self];
        return self;
    };
}

- (void (^)(TouchBlock))touchUpInside {
    
    return ^(TouchBlock block) {
        objc_setAssociatedObject(self, touchKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self addTarget:self action:@selector(touchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
        return;
    };
}

- (void)touchUpInSide:(UIButton *)btn{
    TouchBlock block = objc_getAssociatedObject(self, touchKey);
    if (block) {
        block(btn);
    }
}

/**
 按钮点击以Block方式回调
 
 @param handler 点击事件的回调
 */
-(void)touchUpInsideBlock:(TouchBlock)handler
{
    objc_setAssociatedObject(self, touchKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(wx_touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)wx_touchUpInsideAction:(UIButton *)btn{
    TouchBlock block = objc_getAssociatedObject(self, touchKey);
    if (block) {
        block(btn);
    }
}


@end
