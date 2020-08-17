//
//  LukeView.m
//  DrawDemo
//
//  Created by mao wangxin on 2017/5/25.
//  Copyright © 2017年 Luke. All rights reserved.
//

#import "LukeView.h"

@implementation LukeView

- (void)drawRect:(CGRect)rect
{
    drawDemo(rect);
}


- (IBAction)praiseAction:(UIButton *)sender {
}
/**
 *  绘制二次贝兹曲线
 *  通过调用CGContextAddQuadCurveToPoint()来绘制
 */
void drawBezier(CGRect rect)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context,2.0);
    
    CGContextSetStrokeColorWithColor(context,[UIColor blueColor].CGColor);
    
    CGContextMoveToPoint(context,10,200);
    
    CGContextAddQuadCurveToPoint(context,150,10,300,200);
    
    //    CGContextAddCurveToPoint(context, 50, 400, 250, 400, rect.size.width/2, 60);
    
    CGContextStrokePath(context);
    
}


void drawbeiSai ()
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context,2.0);
    
    CGContextSetStrokeColorWithColor(context,[UIColor blueColor].CGColor);
    
    CGContextMoveToPoint(context,10,10);
    
    CGContextAddCurveToPoint(context,0,50,300,250,300,400);
    
    CGContextStrokePath(context);
}

void drawDemo (CGRect rect)
{
    //    self.radius += 1;
    //
    //    if (self.radius >= 100) {
    //        self.radius = 1;
    //    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    //    CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, 50, 0, M_PI * 2, 0);
    
    //    CGContextAddEllipseInRect(ctx, CGRectMake(50, 50, 100, 100));
    
    CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, 50, 0, M_PI, 0);
    
    //    CGContextSetFillColorWithColor(ctx, [self randomColor].CGColor);
    
    CGContextSetLineWidth(ctx, 20);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetLineJoin(ctx, kCGLineJoinBevel);
    
    [[UIColor redColor] set];
    
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
    
    CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, 50, 0, M_PI, 1);
    
    CGContextStrokePath(ctx);
    
    
    //    CGContextFillPath(ctx);
}


/**
 *  画圆形
 */
void drawCircle(){
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(ctx, 150, 150, 100, 0, M_PI_2, 1);
    
    CGContextAddLineToPoint(ctx, 150, 150);
    
    [[UIColor redColor] set];
    
    CGContextClosePath(ctx);
    
    CGContextFillPath(ctx);
    
    CGContextMoveToPoint(ctx, 150, 250);
    
    CGContextAddLineToPoint(ctx, 250, 250);
    
    CGContextAddLineToPoint(ctx, 250, 150);
    
    CGFloat lengths[] = {10,10};
    CGContextSetLineDash(ctx, 0, lengths, 2);
    
    CGContextStrokePath(ctx);
    
}

/**
 *  画线条
 */
void drawLine() {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGContextMoveToPoint(ctx, 50, 50);
    CGContextAddLineToPoint(ctx, 200, 90);
    CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 1);
    
    CGContextAddLineToPoint(ctx, 110, 150);
    CGContextClosePath(ctx);
    [[UIColor brownColor] setStroke];
    CGContextStrokePath(ctx);
    
}

/**
 *  画四边形
 */
void draw4Rect(){

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, CGRectMake(50, 50, 100, 100));
    
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineWidth(ctx, 3);
    
    CGFloat lengths[] = {10,10};
    CGContextSetLineDash(ctx, 0, lengths, 2);
    
    [[UIColor redColor] setStroke];
    
    CGContextStrokePath(ctx);
}

@end
