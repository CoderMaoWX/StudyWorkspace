//
//  DrawCircleVC.m
//  DrawDemo
//
//  Created by mao wangxin on 2017/6/3.
//  Copyright © 2017年 Luke. All rights reserved.
//

#import "DrawCircleVC.h"

@interface DrawCircleVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) CALayer *circleLayer;
@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;
@end

@implementation DrawCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)drawCircleAction:(UIButton *)sender
{
    [self.circleLayer removeAllAnimations];
    [self.replicatorLayer removeFromSuperlayer];
    
    if (sender.selected) {
        sender.selected = NO;
        [sender setTitle:@"画圈" forState:0];
    } else {
        sender.selected = YES;
        [sender setTitle:@"停止画圈" forState:0];
        //画圈
        [self drawCircle];
    }
}

/**
 *  画圈
 */
- (void)drawCircle
{
    CGFloat smallCircleSize = 10;
    CGFloat duration = 2;
    CGFloat layerWidth = self.contentView.bounds.size.width*0.5;
    CGRect fromRect = CGRectMake(0, 0, 0, 0);
    CGRect toRect = CGRectMake(0, 0, smallCircleSize, smallCircleSize);
    NSInteger duplicateCount = 20;
    CGFloat angle = M_PI * 2 / duplicateCount;
    
    //每个小圆圈
    CALayer *circleLayer = [CALayer layer];
    circleLayer.backgroundColor = [UIColor redColor].CGColor;
    circleLayer.bounds = fromRect;
    circleLayer.position = CGPointMake((layerWidth-smallCircleSize)/2, smallCircleSize);
    circleLayer.cornerRadius = smallCircleSize/2;
    circleLayer.masksToBounds = YES;
    self.circleLayer = circleLayer;
    
    //复制图层
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds = CGRectMake(0, 0, layerWidth, layerWidth);
    replicatorLayer.position = CGPointMake(layerWidth, layerWidth);
    replicatorLayer.instanceCount = duplicateCount;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    replicatorLayer.instanceDelay = duration / duplicateCount;
    self.replicatorLayer = replicatorLayer;
    
    //给复制图层添加子图层
    [replicatorLayer addSublayer:circleLayer];
    //把复制图层显示到contentView视图上
    [self.contentView.layer addSublayer:replicatorLayer];

    //给复制的每个小圆圈添加缩放动画
    CABasicAnimation *anima = [CABasicAnimation animation];
    anima.keyPath = @"bounds";
    anima.fromValue = [NSValue valueWithCGRect:fromRect];
    anima.toValue = [NSValue valueWithCGRect:toRect];
    anima.duration = duration;
    anima.repeatCount = MAXFLOAT;
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    [circleLayer addAnimation:anima forKey:@"circleAnima"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
