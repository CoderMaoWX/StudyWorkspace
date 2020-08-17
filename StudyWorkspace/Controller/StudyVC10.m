//
//  StudyVC10.m
//  DrawDemo
//
//  Created by mao wangxin on 2017/6/5.
//  Copyright © 2017年 Luke. All rights reserved.
//

#import "StudyVC10.h"
#import "ChartLineInfoView.h"

@interface StudyVC10 ()
@property (nonatomic, strong) ChartLineInfoView *chartLineInfoView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CALayer *circleLayer;
@end

@implementation StudyVC10

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


/**
 *  移除当前类所有动画
 */
- (void)removeSelfAllAnimation
{
    [self.shapeLayer removeAnimationForKey:@"strokeEndKey"];
    
    [[self.chartLineInfoView.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.chartLineInfoView removeFromSuperview];
    self.chartLineInfoView = nil;
    
    [self.circleLayer removeFromSuperlayer];
    self.circleLayer = nil;
}


/**
 *  绘制曲线图
 */
- (IBAction)drawBrokenLineAction:(UIButton *)sender
{
    //移除当前类所有动画
    [self removeSelfAllAnimation];
    
    [self drawChartLineInfoView];
}

/**
 * 会曲线图
 */
- (void)drawChartLineInfoView
{
    //y轴刻度值
    NSArray *yAxleArr = @[@"1000",@"800",@"600",@"400",@"200",@"0"];
    
    //x轴刻度值
    NSMutableArray *xAxleArr = [NSMutableArray array];
    for (int i=0; i<15; i++) {
        [xAxleArr addObject:[NSString stringWithFormat:@"%zd",2000+i]];
    }
    
    //绘图点数据
    NSMutableArray *drawPointArr = [NSMutableArray array];
    for (int i=0; i<15; i++) {
        int x = 150 +  (arc4random() % 800);
        [drawPointArr addObject:[NSString stringWithFormat:@"%zd",x]];
    }
    
    CGRect rect = CGRectMake(0, 150, self.view.bounds.size.width, 20*7);
    ChartLineInfoView *chartLineInfoView = [[ChartLineInfoView alloc] initWithFrame:rect
                                                                              lineColor:[UIColor orangeColor]
                                                                      leftScaleValueArr:yAxleArr
                                                                    bottomScaleValueArr:xAxleArr
                                                                            lineDataArr:drawPointArr];
    [self.view addSubview:chartLineInfoView];
    self.chartLineInfoView = chartLineInfoView;
}

/**
 * 测试渐变图层1
 */
- (void)testCAGradientLayer1
{
    //  创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    //  设置 gradientLayer 的 Frame
    gradientLayer.frame = CGRectMake(100, 100, 200, 200);
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(id)[UIColor redColor].CGColor,
                             (id)[UIColor yellowColor].CGColor,
                             (id)[UIColor blueColor].CGColor];
    
    // 渐变颜色的区间分布（分割点），locations的数组长度和colors一致。这个属性可不设，默认是nil，系统会平均分布颜色如果有特定需要可设置，数组设置为0 ~ 1之间单调递增。
    //gradientLayer.locations = @[@(0.33), @(0.66), @(0.99)];
    
    //映射locations中起始位置，用单位向量表示。比如（0, 0）表示从左上角开始变化。默认值是：(0.5, 0.0)。
    gradientLayer.startPoint = CGPointMake(0, 0);
    
    //映射locations中结束位置，用单位向量表示。比如（1, 1）表示到右下角变化结束。默认值是：(0.5, 1.0)。
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    //type：默认值是kCAGradientLayerAxial，表示按像素均匀变化。
    //gradientLayer.type = kCAGradientLayerAxial;
    
    //  添加渐变色到创建的 UIView 上去
    [self.view.layer addSublayer:gradientLayer];
    
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"endPoint"];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    anim.duration = 2;
    anim.repeatCount = HUGE_VAL;
    //anim.autoreverses = YES;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    [gradientLayer addAnimation:anim forKey:@"endPointKKey"];
    
}


/**
 *  绘制圆圈
 */
- (IBAction)drawCircleAction:(UIButton *)sender
{
    //移除当前类所有动画
    [self removeSelfAllAnimation];
    
    if (sender.selected) {
        sender.selected = NO;
        [sender setTitle:@"画圈" forState:0];
    } else {
        sender.selected = YES;
        [sender setTitle:@"停止画圈" forState:0];
        [self testCAGradientLayer2];
    }
}

/**
 * 绘制渐变圆圈
 */
- (void)testCAGradientLayer2
{
    //创建圆圈路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:150 startAngle:0 endAngle:(M_PI * 2) clockwise:1];
    
    //创建路径图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = 10;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    self.shapeLayer = shapeLayer;
    
    //创建渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(id)[UIColor redColor].CGColor,
                             (id)[UIColor yellowColor].CGColor,
                             (id)[UIColor blueColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [self.view.layer addSublayer:gradientLayer];
    
    //创建显示图层
    CALayer *layer = [CALayer layer];
    layer.frame = self.view.bounds;
    layer.position = self.view.center;
    [layer addSublayer:gradientLayer];
    [layer setMask:shapeLayer];
    [self.view.layer addSublayer:layer];
    self.circleLayer = layer;
    
    
    //给路径图层添加动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.fromValue = @(0);
    anim.toValue = @(1);
    anim.duration = 2;
    anim.repeatCount = HUGE_VAL;
    anim.autoreverses = YES;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    [shapeLayer addAnimation:anim forKey:@"strokeEndKey"];
    
}

@end
