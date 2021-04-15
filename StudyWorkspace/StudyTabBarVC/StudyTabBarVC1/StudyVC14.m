//
//  StudyVC14.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/4/14.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "StudyVC14.h"
#import <Accelerate/Accelerate.h>

// 默认的触摸清晰size
static NSInteger const touchSize = 350;

@interface StudyVC14 ()
@property (nonatomic, weak) CALayer             *imageMaskLayer;
@property (nonatomic, strong) UIImageView       *bgImgView;
@property (nonatomic, strong) UIImageView       *maskImgView;
@end

@implementation StudyVC14

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldPanBack = NO;
}

- (void)longGesture:(UIGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:gesture.view];
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        self.imageMaskLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.imageMaskLayer.position = CGPointMake(touchPoint.x, touchPoint.y - 50);
        [CATransaction commit];
    } else  {
        self.imageMaskLayer.hidden = YES;
    }
}

- (void)wx_InitView {
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.maskImgView];
}

- (void)wx_AutoLayoutView {
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.maskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.image = [self blurImageWithDegree:15 originImage:self.maskImgView.image];;
    }
    return _bgImgView;
}

- (UIImageView *)maskImgView {
    if (!_maskImgView) {
        _maskImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _maskImgView.contentMode = UIViewContentModeScaleAspectFill;
        _maskImgView.userInteractionEnabled = YES;
        _maskImgView.image = [UIImage imageNamed:@"women"];
        
        CALayer *imageMaskLayer = [CALayer layer];
        UIImage *displayerImage = [UIImage imageNamed:@"fingerMask"];
        imageMaskLayer.contents = (__bridge id)displayerImage.CGImage;
        imageMaskLayer.frame = CGRectMake(0, 0, touchSize, touchSize);
        _maskImgView.layer.mask = imageMaskLayer;
        imageMaskLayer.hidden = YES;
        self.imageMaskLayer = imageMaskLayer;
        
        UIPanGestureRecognizer *longPre = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
        // longPre.minimumPressDuration = 0.5;
        [_maskImgView addGestureRecognizer:longPre];
    }
    return _maskImgView;
}

///原图 -> 高斯模糊图
- (UIImage *)blurImageWithDegree:(CGFloat)blurDegree originImage:(UIImage *)originImage
{
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, [originImage scale]);
    CGContextRef effectInContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(effectInContext, 1.0, -1.0);
    CGContextTranslateCTM(effectInContext, 0, -originImage.size.height);
    CGContextDrawImage(effectInContext, CGRectMake(0, 0, originImage.size.width, originImage.size.height), originImage.CGImage);
    vImage_Buffer effectInBuffer;
    effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
    effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
    effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
    effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
    
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, [originImage scale]);
    CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
    vImage_Buffer effectOutBuffer;
    effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
    effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
    effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
    effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
    
    BOOL hasBlur = blurDegree > __FLT_EPSILON__;
    
    if (hasBlur) {
        CGFloat inputRadius = blurDegree * [[UIScreen mainScreen] scale];
        int radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
        if (radius % 2 != 1) {
            radius += 1; // force radius to be odd so that the three box-blur methodology works.
        }
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
    }
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

@end
