//
//  UIView+WXExtension.m
//  StudyWorkspace
//
//  Created by mao wangxin on 16/12/26.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import "UIView+WXExtension.h"

@implementation UIView (WXExtension)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}
-(CGFloat)top{
    return self.frame.origin.y;
}

-(CGFloat)bottom{
    return self.frame.size.height + self.frame.origin.y;
}

-(CGFloat)left{
    return self.frame.origin.x;
}

-(CGFloat)right{
    return self.frame.size.width + self.frame.origin.x;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(void)setTop:(CGFloat)top{
    self.frame = CGRectMake(self.frame.origin.x, top, self.frame.size.width, self.frame.size.height);
}

-(void)setLeft:(CGFloat)left{
    self.frame = CGRectMake(left, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

-(void)setBottom:(CGFloat)bottom{
    self.frame = CGRectMake(self.frame.origin.x, bottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

-(void)setRight:(CGFloat)right{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, right - self.frame.size.width, self.frame.size.height);
}

-(void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

-(void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

@end
