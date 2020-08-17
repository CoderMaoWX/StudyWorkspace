//
//  DrawQuartz2DVC.m
//  DrawDemo
//
//  Created by mao wangxin on 2017/6/5.
//  Copyright © 2017年 Luke. All rights reserved.
//

#import "DrawQuartz2DVC.h"
#import "LukeView.h"

@interface DrawQuartz2DVC ()
@property (weak, nonatomic) IBOutlet LukeView *contentView;
@end

@implementation DrawQuartz2DVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self drawCircle];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self testBezierPathAnimaion];
}

/**
 * testBezierPathAnimaion
 */
- (void)testBezierPathAnimaion
{
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    transformAnima.fromValue = @(0);
    transformAnima.toValue = @(1);
    transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transformAnima.autoreverses = YES;
    transformAnima.repeatCount = HUGE_VAL;
    transformAnima.duration = 2;
    
    transformAnima.removedOnCompletion = NO;
    transformAnima.fillMode = kCAFillModeForwards;
    
    [self.drawCircle addAnimation:transformAnima forKey:nil];
}

- (CAShapeLayer *)drawCircle
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    // circleLayer.backgroundColor = [UIColor greenColor].CGColor;
    
    // 指定frame，只是为了设置宽度和高度
    shapeLayer.frame = self.view.bounds;//CGRectMake(0, 0, 400, 400);
    // 设置居中显示
    shapeLayer.position = self.view.center;
    
    // 设置线宽
    shapeLayer.lineWidth = 2.0;
    // 设置线的颜色
    shapeLayer.strokeColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1].CGColor;
    
    // 设置填充颜色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    //    shapeLayer.lineDashPhase = 1;
    
    shapeLayer.lineDashPattern = @[@5];
    
    // 使用UIBezierPath创建路径
    //    CGRect frame = CGRectMake(0, 0, 200, 200);
    //    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:frame];
    //    // 设置CAShapeLayer与UIBezierPath关联
    //    circleLayer.path = circlePath.CGPath;
    
    CGPoint pathPoint = shapeLayer.position;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(100, pathPoint.y-25)];
    [path addCurveToPoint:CGPointMake(self.view.bounds.size.width-100, pathPoint.y+25) controlPoint1:CGPointMake(170, pathPoint.y/2) controlPoint2:CGPointMake(self.view.bounds.size.width-170, pathPoint.y+100)];
    shapeLayer.path = path.CGPath;
    
    // 将CAShaperLayer放到某个层上显示
    [self.view.layer addSublayer:shapeLayer];
    
    return shapeLayer;
}

/**
 * testCABasicAnimation
 */
- (void)testCABasicAnimation
{
    self.contentView.layer.anchorPoint = CGPointMake(0, 1);
    
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //    transformAnima.fromValue = @(M_PI_2);
    transformAnima.toValue = @(M_PI_2);
    transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transformAnima.autoreverses = YES;
    transformAnima.repeatCount = 1;
    transformAnima.duration = 2;
    //    transformAnima.beginTime = CACurrentMediaTime() + 2;
    
    //    transformAnima.removedOnCompletion = NO;
    //    transformAnima.fillMode = kCAFillModeForwards;
    
    [self.contentView.layer addAnimation:transformAnima forKey:nil];
}


- (void)drawImage{
    
    // 加载图片
    UIImage *image = [UIImage imageNamed:@"小黄人"];
    
    // 0.获取上下文，之前的上下文都是在view的drawRect方法中获取（跟View相关联的上下文layer上下文）
    // 目前我们需要绘制图片到新的图片上，因此需要用到位图上下文
    
    // 怎么获取位图上下文,注意位图上下文的获取方式跟layer上下文不一样。位图上下文需要我们手动创建。
    
    // 开启一个位图上下文，注意位图上下文跟view无关联，所以不需要在drawRect.
    // size:位图上下文的尺寸（新图片的尺寸）
    // opaque: 不透明度 YES：不透明 NO:透明，通常我们一般都弄透明的上下文
    // scale:通常不需要缩放上下文，取值为0，表示不缩放
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    // 1.绘制原生的图片
    [image drawAtPoint:CGPointZero];
    
    
    // 1.获取上下文(位图上下文)
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.描述路径
    CGContextMoveToPoint(ctx, 75*[UIScreen mainScreen].scale, 50);
    
    CGContextAddLineToPoint(ctx, 200, 200);
    
    [[UIColor redColor] set];
    
    // 3.渲染上下文
    CGContextStrokePath(ctx);
    
    
    UIBezierPath *path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 300, 300)];
    [[UIColor redColor] set];
    [path stroke];
    
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 50, 100, 100) byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
    [[UIColor greenColor] set];
    [path1 stroke];
    
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 250) radius:50 startAngle:0 endAngle:M_PI clockwise:1];
    [[UIColor purpleColor] set];
    [path2 stroke];
    
    
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:CGPointMake(150, 400)];
    [path3 addLineToPoint:CGPointMake(50, 500)];
    [path3 addLineToPoint:CGPointMake(250, 550)];
    [path3 closePath];
    path3.lineCapStyle = kCGLineCapRound;
    path3.lineJoinStyle = kCGLineJoinRound;
    path3.flatness = 20;
    path3.lineWidth = 10;
    path3.miterLimit = 5;
    path3.usesEvenOddFillRule = YES;
    [[UIColor yellowColor] setStroke];
    [path3 stroke];
    
    
    // 2.给原生的图片添加文字
    NSString *str = @"友门鹿";
    
    // 创建字典属性
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor redColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    
    [str drawAtPoint:CGPointMake(200, 528) withAttributes:dict];
    
    // 3.生成一张图片给我们,从上下文中获取图片
    UIImage *imageWater = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    //显示图片
    self.view.layer.contents = (id)imageWater.CGImage;
    //    _contentView.image = imageWater;
}

@end
