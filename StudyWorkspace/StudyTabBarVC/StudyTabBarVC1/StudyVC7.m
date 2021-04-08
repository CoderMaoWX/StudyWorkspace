//
//  StudyVC7.m
//  DrawDemo
//
//  Created by mao wangxin on 2017/6/5.
//  Copyright © 2017年 Luke. All rights reserved.
//

#import "StudyVC7.h"
#import "LukeLayer.h"

#define kAngle2Radian(x)   ((x / 180.0) * M_PI)

@interface StudyVC7 ()<CALayerDelegate,CAAnimationDelegate>
@property (nonatomic, strong) CALayer *layer;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UIImageView *imageView4;
@property (nonatomic, assign) BOOL goingToFront;
@property (nonatomic, strong) UIImageView *tempView;
@end

@implementation StudyVC7

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonAction1:(id)sender
{
    //测试动画
    [self viewAnimation];
}

- (IBAction)buttonAction2:(id)sender
{
    //测试动画
    [self coreAnimation];
}

- (void)viewDidLayoutSubviews
{
    //测试动画
    [self viewAnimation];
    
    //测试动画
    [self coreAnimation];
}

/**
 * 转场动画
 */
- (void)transitionAnimation
{
    CATransition *anima = [CATransition animation];
    
    //什么类型的动画
    anima.type = @"cube";
    
    //动画方向
    anima.subtype = kCATransitionFromRight;
    
    //动画开始地方的百分比
    // anim.startProgress = 0.0;
    
    //动画结束地方的百分比
    // anim.endProgress = 0.5;
    
    anima.duration = 1;
    
    anima.repeatCount = MAXFLOAT;
    
    [self.imageView3.layer addAnimation:anima forKey:@"haha"];
}


/**
 * 抖动动画
 */
- (void)shakeIconAnimation
{
    CAKeyframeAnimation *keyAnima = [CAKeyframeAnimation animation];
    keyAnima.keyPath = @"transform.rotation";
    keyAnima.values = @[@(kAngle2Radian(-1)),@(kAngle2Radian(1)),@(kAngle2Radian(-1))];
    keyAnima.duration = 0.2;
    keyAnima.repeatCount = MAXFLOAT;
    
    //保持动画不复原
    //    keyAnima.removedOnCompletion = NO;
    //    keyAnima.fillMode = kCAFillModeForwards;
    
    [self.imageView3.layer addAnimation:keyAnima forKey:@"keyAnima"];
}

/**
 * 初始化
 */
- (UIImageView *)tempView
{
    if(!_tempView){
        _tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 295, 80, 80)];
        _tempView.backgroundColor = [UIColor brownColor];
        _tempView.image = [UIImage imageNamed:@"1.JPG"];
        _tempView.layer.cornerRadius = 40;
        _tempView.layer.masksToBounds = YES;
        [self.view addSubview:_tempView];
    }
    return _tempView;
}

/**
 * UIView动画: 添加旋和平移转动画
 */
- (void)viewAnimation
{
    __block CGRect rect = self.tempView.frame;
    
    [UIView animateWithDuration:3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        //旋转
        self.tempView.transform = CGAffineTransformMakeRotation(M_PI);
        
        //平移
        //self.imageView3.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width-self.imageView3.bounds.size.width, 0);
        rect.origin.x = self.view.bounds.size.width-self.tempView.bounds.size.width;
        self.tempView.frame = rect;
        
    } completion:^(BOOL finished) {
        
        @weakify(self)
        [UIView animateWithDuration:3 animations:^{
            @strongify(self)
            //self.imageView3.transform = CGAffineTransformMakeTranslation(0, 0);
            self.tempView.transform = CGAffineTransformMakeRotation(-M_PI * 2);
            rect.origin.x = 0;
            self.tempView.frame = rect;
            
        } completion:^(BOOL finished) {
            @strongify(self)
            [self viewAnimation];
        }];
    }];
}

#pragma mark -===========旋和平移转动画===========

/**
 * 核心动画: 添加旋和平移转动画
 */
- (void)coreAnimation
{
    //旋转动画
    CABasicAnimation *anima1 = [CABasicAnimation animation];
    anima1.keyPath = @"transform.rotation";
    anima1.toValue = @(M_PI * 2);
    
    CGFloat w = self.contentView.frame.size.width;
    CGFloat y = self.contentView.frame.origin.y+w/2;
    
    //平移动画
    CAKeyframeAnimation *keyAnima = [CAKeyframeAnimation animation];
    keyAnima.keyPath = @"position";
    NSValue *pointValue0 = [NSValue valueWithCGPoint:CGPointMake(w/2, y)];
    NSValue *pointValue1 = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width-w/2, y)];
    NSValue *pointValue2 = [NSValue valueWithCGPoint:CGPointMake(w/2, y)];
    keyAnima.values = @[pointValue0, pointValue1, pointValue2];
    
    //控制动画执行速度
    keyAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //添加到动画组
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[anima1, keyAnima];
    groupAnima.duration = 5;
    groupAnima.repeatCount = MAXFLOAT;
    [self.contentView.layer addAnimation:groupAnima forKey:@"rotation"];
}

#pragma mark -===========自定义图层===========

/**
 * testCustomLayer
 */
- (void)testCustomLayer
{
    LukeLayer *layer = [LukeLayer layer];
    layer.backgroundColor = [UIColor brownColor].CGColor;
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = CGPointMake(self.view.layer.bounds.size.width/2, self.view.layer.bounds.size.height/2);
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.view.layer addSublayer:layer];
}

- (void)testsystemLayer
{
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = CGPointMake(self.view.layer.bounds.size.width/2, self.view.layer.bounds.size.height/2);
    layer.anchorPoint = CGPointMake(0, 0);
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
    //    layer.delegate = self;
    //    [layer setNeedsDisplay];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextAddArc(ctx, 50, 50, 30, 0, M_PI_2, 0);
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextFillPath(ctx);
}

#pragma mark -===========测试===========

/**
 * testTransition
 */
- (void)testTransition
{
    NSString *imageName1 = [NSString stringWithFormat:@"%d.jpg",(arc4random() % 10)];
    self.imageView1.image = [UIImage imageNamed:imageName1];
    
    [UIView transitionWithView:self.imageView1
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];//防止设备横屏，新vc的View有异常旋转动画
                        [UIView setAnimationsEnabled:NO];
                        NSString *imageName2 = [NSString stringWithFormat:@"%d.jpg",(arc4random() % 10)];
                        self.imageView1.image = [UIImage imageNamed:imageName2];
                        [UIView setAnimationsEnabled:oldState];
                    } completion:^(BOOL finished) {
                        NSLog(@"动画完成");
                    }];
}

/**
 * UIView的反转动画: transitionWithView
 */
- (void)addXibUIAnimation
{
    self.goingToFront = !self.goingToFront;
    
    //    UIView *fromView = self.goingToFront ? self.imageView1 : self.imageView2;
    //    UIView *toView = self.goingToFront ? self.imageView2 : self.imageView1;
    //
    __block UIViewAnimationOptions transitionDirection = self.goingToFront ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    //
    //    [UIView transitionFromView:fromView
    //                        toView:toView
    //                      duration:0.5
    //                       options:transitionDirection
    //                    completion:^(BOOL finished) {
    //                        NSLog(@"动画完成\n===%@\n===%@\n===%@",self.imageView1,self.imageView2,self.contentView);
    //                        self.imageView1.frame = CGRectMake(0, 0, 150, 150);
    //                        self.imageView2.frame = CGRectMake(0, 0, 150, 150);
    //                    }];
    
    [UIView transitionWithView:self.contentView
                      duration:2
                       options:transitionDirection
                    animations:^{
                        [self.contentView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
                        [UIView setAnimationRepeatCount:MAXFLOAT];
                    } completion:^(BOOL finished) {
                        NSLog(@"动画完成");
                    }];
}


/**
 * UIView的反转动画: transitionFromView
 */
- (void)addCustomUIAnimation
{
    self.goingToFront = !self.goingToFront;
    
    self.imageView1.hidden = YES;
    self.imageView2.hidden = YES;
    
    UIView *fromView = self.goingToFront ? self.imageView3 : self.imageView4;
    UIView *toView = self.goingToFront ? self.imageView4 : self.imageView3;
    
    UIViewAnimationOptions transitionDirection = self.goingToFront ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:transitionDirection
                    completion:^(BOOL finished) {
                        NSLog(@"动画完成\n===%@\n===%@",self.imageView3,self.imageView4);
                    }];
}

/**
 * 初始化imageView3
 */
- (UIImageView *)imageView3
{
    if(!_imageView3){
        _imageView3 = [[UIImageView alloc] init];
        _imageView3.image = [UIImage imageNamed:@"2.jpg"];
        _imageView3.bounds = CGRectMake(0, 0, 150, 150);
        _imageView3.center = CGPointMake(self.contentView.bounds.size.width/2, self.contentView.bounds.size.height/2);
        [self.contentView addSubview:_imageView3];
    }
    return _imageView3;
}

/**
 * 初始化imageView3
 */
- (UIImageView *)imageView4
{
    if(!_imageView4){
        _imageView4 = [[UIImageView alloc] init];
        _imageView4.image = [UIImage imageNamed:@"6.jpg"];
        _imageView4.bounds = CGRectMake(0, 0, 150, 150);
        _imageView4.center = CGPointMake(self.contentView.bounds.size.width/2, self.contentView.bounds.size.height/2);
        [self.contentView addSubview:_imageView4];
    }
    return _imageView4;
}


- (void)testTranslate
{
    // 1.创建动画对象
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    // 2.设置动画对象
    // keyPath决定了执行怎样的动画, 调整哪个属性来执行动画
    //    anim.keyPath = @"transform.rotation";
    //    anim.keyPath = @"transform.scale.x";
    anim.keyPath = @"transform.translation.x";
    anim.toValue = @(100);
    //    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    anim.duration = 2.0;
    
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    // 3.添加动画
    [self.layer addAnimation:anim forKey:nil];
}

- (void)testRotate
{
    // 1.创建动画对象
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    // 2.设置动画对象
    // keyPath决定了执行怎样的动画, 调整哪个属性来执行动画
    anim.keyPath = @"transform";
    //    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, -1, 0)];
    anim.duration = 2.0;
    
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    anim.repeatCount = MAXFLOAT;
    
    // 3.添加动画
    [self.contentView.layer addAnimation:anim forKey:nil];
}

- (void)testScale
{
    // 1.创建动画对象
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    // 2.设置动画对象
    // keyPath决定了执行怎样的动画, 调整哪个属性来执行动画
    anim.keyPath = @"bounds";
    //    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
    anim.duration = 2.0;
    
    /**让图层保持动画执行完毕后的状态**/
    // 动画执行完毕后不要删除动画
    anim.removedOnCompletion = NO;
    // 保持最新的状态
    anim.fillMode = kCAFillModeForwards;
    
    // 3.添加动画
    [self.layer addAnimation:anim forKey:nil];
}

- (void)testTranslate2
{
    // 1.创建动画对象
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    // 2.设置动画对象
    // keyPath决定了执行怎样的动画, 调整哪个属性来执行动画
    anim.keyPath = @"position";
    //    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    // toValue : 最终变成什么值
    // byValue : 增加多少值
    anim.byValue = [NSValue valueWithCGPoint:CGPointMake(200, 300)];
    anim.duration = 2.0;
    
    /**让图层保持动画执行完毕后的状态**/
    // 动画执行完毕后不要删除动画
    anim.removedOnCompletion = NO;
    // 保持最新的状态
    anim.fillMode = kCAFillModeForwards;
    
    // 3.添加动画
    [self.layer addAnimation:anim forKey:nil];
}

@end

