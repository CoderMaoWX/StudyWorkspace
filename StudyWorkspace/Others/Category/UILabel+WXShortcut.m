//
//  UILabel+Shortcut.m
//  StudyWorkspace
//
//  Created by mao wangxin on 16/12/26.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import "UILabel+WXShortcut.h"

@implementation UILabel (WXShortcut)


+ (UILabel *(^)(CGRect))initWithFrame {
    
    return ^UILabel * (CGRect rect) {
        UILabel * label = [[UILabel alloc] initWithFrame:rect];
        return label;
        
    };
}

- (UILabel * (^)(NSString *))wx_setText {
    
    return ^UILabel * (NSString * text) {        
        [self setText:text];
        return self;
    };
}

- (UILabel * (^)(UIFont *))wx_setFont {
    
    return ^UILabel * (UIFont * font) {
        [self setFont:font];
        return self;
    };
}

- (UILabel * (^)(UIColor *))wx_setTextColor {
    
    return ^UILabel * (UIColor * color) {
        [self setTextColor:color];
        return self;
    };
}

- (UILabel * (^)(UIColor *))wx_setBackgroundColor
{
    return ^UILabel *(UIColor * color){
        self.backgroundColor = color;
        return self;
    };
}

- (UILabel * (^)(UIColor *))wx_setShadowColor {
    
    return ^UILabel * (UIColor * color) {
        [self setShadowColor:color];
        return self;
    };
}


- (UILabel *(^)(UIColor *))wx_setBorderColor {
    
    return ^UILabel * (UIColor * color) {
        if (!self.layer.masksToBounds) {
            self.layer.masksToBounds = YES;
        }
        self.layer.borderColor = color.CGColor;
        return self;
    };
}

- (UILabel *(^)(CGFloat))wx_setBorderWidth {
    
    return  ^UILabel * (CGFloat force) {
        if (!self.layer.masksToBounds) {
            self.layer.masksToBounds = YES;
        }
        self.layer.borderWidth = force;
        return self;
    };
}

- (UILabel *(^)(CGFloat))wx_setCornerRadius {
    
    return  ^UILabel * (CGFloat force) {
        if (!self.layer.masksToBounds) {
            self.layer.masksToBounds = true;
        }
        self.layer.cornerRadius = force;
        return self;
    };
}

- (UILabel * (^)(CGSize))wx_setShadowOffset {
    
    return ^UILabel * (CGSize size) {
        [self setShadowOffset:size];
        return self;
    };
}

- (UILabel * (^)(NSTextAlignment))wx_setTextAlignment {
    
    return ^UILabel * (NSTextAlignment alignment) {
        [self setTextAlignment:alignment];
        return self;
    };
}

- (UILabel * (^)(NSLineBreakMode))wx_setLineBreakMode {
    
    return ^UILabel * (NSLineBreakMode mode) {
        [self setLineBreakMode:mode];
        return self;
    };
}

- (UILabel * (^)(NSAttributedString *))wx_setAttributedText {
    
    return ^UILabel * (NSAttributedString * attributed) {
        [self setAttributedText:attributed];
        return self;
    };
}

- (UILabel * (^)(UIColor *))wx_setHighlightedTextColor {
    
    return ^UILabel * (UIColor * color) {
        [self setHighlightedTextColor:color];
        return self;
    };
}

- (UILabel * (^)(BOOL))wx_setUserInteractionEnabled {
    
    return ^UILabel * (BOOL is) {
        [self setUserInteractionEnabled:is];
        return self;
    };
}

- (UILabel * (^)(BOOL))wx_setEnabled {
    
    return ^UILabel * (BOOL is) {
        [self setEnabled:is];
        return self;
    };
}

- (UILabel * (^)(NSInteger))wx_numberOfLines {
    
    return ^UILabel * (NSInteger number) {
        [self setNumberOfLines:number];
        return self;
    };
}

- (UILabel * (^)(UIView *))wx_addToView {
    
    return ^UILabel *(UIView *sub) {
        [sub addSubview:self];
        return self;
    };
}


@end

