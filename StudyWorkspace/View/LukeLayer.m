//
//  LukeLayer.m
//  DrawDemo
//
//  Created by mao wangxin on 2017/5/25.
//  Copyright © 2017年 Luke. All rights reserved.
//

#import "LukeLayer.h"

@implementation LukeLayer

- (void)drawInContext:(CGContextRef)ctx
{
//    CGContextAddRect(ctx, CGRectMake(25, 25, 50, 50));
    
    CGContextAddEllipseInRect(ctx, CGRectMake(25, 25, 50, 25));
    
//    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);

    [[UIColor redColor] setFill];
    
    CGContextFillPath(ctx);
}

@end
