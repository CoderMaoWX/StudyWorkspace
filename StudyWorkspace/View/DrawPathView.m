//
//  DrawPathView.m
//  DrawDemo
//
//  Created by mao wangxin on 2017/6/4.
//  Copyright © 2017年 Luke. All rights reserved.
//

#import "DrawPathView.h"

@interface DrawPathView ()
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) CALayer *imageLayer;
@end

@implementation DrawPathView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

/**
 *  图片Layer
 */
- (CALayer *)imageLayer
{
    if (!_imageLayer) {
        _imageLayer = [CALayer layer];
        _imageLayer.contents = (id)[UIImage imageNamed:@"icon_qq_zone"].CGImage;
        _imageLayer.bounds =CGRectMake(0, 0, 50, 50);
        _imageLayer.position = CGPointMake(self.center.x, self.center.y);
        [self.layer addSublayer:_imageLayer];
    }
    return _imageLayer;
}

/**
 *  绘制的路径
 */
- (UIBezierPath *)bezierPath
{
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPath];
        _bezierPath.lineWidth = 3;
        _bezierPath.lineJoinStyle = kCGLineJoinRound;
        _bezierPath.lineCapStyle = kCGLineCapRound;
    }
    return _bezierPath;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touche = [touches anyObject];
    
    CGPoint startPoint = [touche locationInView:self];
    
    //得到一个绘制起始点
    [self.bezierPath moveToPoint:startPoint];
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touche = [touches anyObject];
    
    CGPoint movePoint = [touche locationInView:self];

    //绘制路径
    [self.bezierPath addLineToPoint:movePoint];
    
    [self setNeedsDisplay];
}

/**
 *  轨迹运动
 */
- (void)moveLayerFromPath
{
    CABasicAnimation *anima1 = [CABasicAnimation animation];
    anima1.keyPath = @"transform.rotation";
    anima1.toValue = @(M_PI*2);
    anima1.duration = 0.2;
//    anima1.autoreverses = YES;
    anima1.repeatCount = MAXFLOAT;
    
    CABasicAnimation *anima2 = [CABasicAnimation animation];
    anima2.keyPath = @"transform.scale";
    anima2.fromValue = @(0.5);
    anima2.toValue = @(1);
    anima2.duration = 2;
    anima2.autoreverses = YES;
    anima2.repeatCount = MAXFLOAT;
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.keyPath = @"position";
    keyAnimation.path = self.bezierPath.CGPath;
    keyAnimation.duration = 8;
    keyAnimation.autoreverses = YES;
    keyAnimation.repeatCount = MAXFLOAT;
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[anima1,anima2,keyAnimation];
    groupAnima.duration = 8;
    groupAnima.autoreverses = YES;
    groupAnima.repeatCount = MAXFLOAT;
    [self.imageLayer addAnimation:groupAnima forKey:@"groupAnimation"];
    
}


/**
 *  开始绘制
 */
- (void)startDrawPath
{
    [self bezierPath];
}


/**
 *  重新绘制
 */
- (void)afreshDrawPath
{
    self.bezierPath = nil;
    [self.imageLayer removeAnimationForKey:@"positionAnimation"];
    [self.imageLayer removeFromSuperlayer];
    self.imageLayer = nil;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [[UIColor redColor] set];
    
    [self.bezierPath stroke];
}


/**
 *  随机色
 */
- (UIColor *)arcColor {
    return [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
}

@end
