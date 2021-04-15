//
//  StudyVC14.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/4/14.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "StudyVC14.h"
#import "UIImage+Extension.h"

// 默认的触摸清晰size
static NSInteger const touchSize = 350;

@interface StudyVC14 ()
@property (nonatomic, strong) UIImageView       *bgImgView;
@property (nonatomic, strong) UIImageView       *maskImgView;
@property (nonatomic, weak) CALayer             *imageMaskLayer;

@property (nonatomic, strong) UILabel           *backgroundTextLabel;
@property (nonatomic, strong) UILabel           *foregroundTextLabel;
@property (nonatomic, weak) CALayer             *textMaskLayer;
@property (nonatomic, assign) CGFloat           textMaskWidth;
@property (nonatomic, strong) NSTimer           *textTimer;
@end

@implementation StudyVC14

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldPanBack = NO;
    
    //开始显示歌词效果
    [self.textTimer fire];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.textTimer invalidate];
}

- (void)wx_InitView {
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.maskImgView];
    [self.view addSubview:self.backgroundTextLabel];
    [self.view addSubview:self.foregroundTextLabel];
}

- (void)wx_AutoLayoutView {
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.maskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.backgroundTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(12);
        make.trailing.offset(-12);
        make.top.offset(40);
    }];
    
    [self.foregroundTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.backgroundTextLabel);
    }];
}

#pragma mark -======== 按住看图效果 ========

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.image = [self.maskImgView.image blurImageWithDegree:15];;
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
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        // longPre.minimumPressDuration = 0.5;
        [_maskImgView addGestureRecognizer:panGesture];
    }
    return _maskImgView;
}

- (void)panGestureAction:(UIGestureRecognizer *)panGesture {
    CGPoint touchPoint = [panGesture locationInView:panGesture.view];
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
        self.imageMaskLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.imageMaskLayer.position = CGPointMake(touchPoint.x, touchPoint.y - 50);
        [CATransaction commit];
    } else  {
        self.imageMaskLayer.hidden = YES;
    }
}

#pragma mark -======== 歌词效果 ========

- (UILabel *)backgroundTextLabel {
    if (!_backgroundTextLabel) {
        _backgroundTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _backgroundTextLabel.backgroundColor = [UIColor whiteColor];
        _backgroundTextLabel.text = @"我是一句很长很长很长很长很长很长很长的歌词";
    }
    return _backgroundTextLabel;
}

- (UILabel *)foregroundTextLabel {
    if (!_foregroundTextLabel) {
        _foregroundTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _foregroundTextLabel.backgroundColor = [UIColor whiteColor];
        _foregroundTextLabel.text = self.backgroundTextLabel.text;
        _foregroundTextLabel.textColor = [UIColor redColor];
        _foregroundTextLabel.userInteractionEnabled = YES;
        
        CALayer *textMaskLayer = [CALayer layer];
        textMaskLayer.backgroundColor = [UIColor redColor].CGColor;
        textMaskLayer.frame = CGRectMake(0, 0, 0, 30);
        _foregroundTextLabel.layer.mask = textMaskLayer;
        self.textMaskLayer = textMaskLayer;
//        UIImage *displayerImage = [UIImage imageNamed:@"header_bg_ios7"];
//        textMaskLayer.contents = (__bridge id)displayerImage.CGImage;
//        textMaskLayer.position = CGPointMake(0, 0);
    }
    return _foregroundTextLabel;
}

- (NSTimer *)textTimer {
    if (!_textTimer) {
        _textTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerfire) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_textTimer forMode:NSRunLoopCommonModes];
    }
    return _textTimer;
}

- (void)timerfire {
    self.textMaskWidth += 5;
    if (self.textMaskWidth >= (kScreenWidth - 12 *2)) {
        self.textMaskWidth = 0;
    }
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.textMaskLayer.frame = CGRectMake(0, 0, self.textMaskWidth, 30);
    [CATransaction commit];
}

@end
