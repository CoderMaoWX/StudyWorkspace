//
//  StudyVC16.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/11/12.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "StudyVC16.h"
#import "UIImage+YYWebImage.h"
#import "UIButton+WXExtension.h"
#import "Masonry.h"
#import "UIButton+WXExtension.h"

@interface WXButton : UIButton
@end

@implementation WXButton

- (CGSize)intrinsicContentSize {
    CGSize s = [super intrinsicContentSize];

//    CGFloat w = s.width + self.titleEdgeInsets.left;
    if (!self.currentTitle && !self.currentImage) {
        return CGSizeZero;
    }
    return s;
}

@end

@interface StudyVC16 ()
@property (nonatomic, strong) UIButton *redBtn;
@property (nonatomic, strong) UILabel *orangeLabel;
@property (nonatomic, strong) UIButton *blueBtn;
@property (nonatomic, strong) UIButton *pinkBtn;
@end

@implementation StudyVC16

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"blueBtn 111 :%@", NSStringFromCGSize(self.blueBtn.intrinsicContentSize));
    [self.blueBtn setTitle:nil forState:UIControlStateNormal];
    NSLog(@"blueBtn 222 :%@", NSStringFromCGSize(self.blueBtn.intrinsicContentSize));
    
    
    NSLog(@"orangeLabel 111:%@", NSStringFromCGSize(self.orangeLabel.intrinsicContentSize));
    self.orangeLabel.text = nil;
    NSLog(@"orangeLabel 222:%@", NSStringFromCGSize(self.orangeLabel.intrinsicContentSize));

    return;
    
//    self.blueBtn.intrinsicContentSize
//    self.blueBtn.frame = CGRectMake(100, 100, 200, 50);
//    [self.blueBtn setTitle:@"Blue Color Button" forState:UIControlStateNormal];
    [self.blueBtn setTitle:nil forState:UIControlStateNormal];
    [self.blueBtn setImage:nil forState:UIControlStateNormal];
    self.blueBtn.contentEdgeInsets = UIEdgeInsetsZero;
    self.blueBtn.imageEdgeInsets = UIEdgeInsetsZero;
    self.blueBtn.titleEdgeInsets = UIEdgeInsetsZero;
    NSLog(@"intrinsicContentSize222 :%@", NSStringFromCGSize(self.blueBtn.intrinsicContentSize));
}

#pragma mark -======== LayoutSubView ========

- (void)layoutSubview {
    [self.redBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.centerX.offset(0);
    }];
    
    [self.orangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.redBtn.mas_bottom);
        make.centerX.offset(0);
    }];
    
    [self.blueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orangeLabel.mas_bottom);
        make.centerX.offset(0);
    }];
    
    [self.pinkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.blueBtn.mas_bottom);
        make.centerX.offset(0);
    }];
}

#pragma mark -======== setup UI ========

- (UIButton *)redBtn{
    if (!_redBtn) {
        _redBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _redBtn.backgroundColor = UIColor.redColor;
        _redBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [_redBtn setTitle:@"Red Color Button" forState:UIControlStateNormal];
        [_redBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.view addSubview:_redBtn];
    }
    return _redBtn;
}

- (UILabel *)orangeLabel {
    if (!_orangeLabel) {
        _orangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _orangeLabel.backgroundColor = UIColor.orangeColor;
        _orangeLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _orangeLabel.textColor = UIColor.whiteColor;
        _orangeLabel.text = @"Orange Lbael";
        [self.view addSubview:_orangeLabel];
    }
    return _orangeLabel;
}

- (UIButton *)blueBtn {
    if (!_blueBtn) {
        _blueBtn = [[WXButton alloc] initWithFrame:CGRectZero];
        _blueBtn.backgroundColor = UIColor.blueColor;
        _blueBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [_blueBtn setTitle:@"Blue Color Button" forState:UIControlStateNormal];
        [_blueBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.view addSubview:_blueBtn];
    }
    return _blueBtn;
}

- (UIButton *)pinkBtn {
    if (!_pinkBtn) {
        _pinkBtn = [[WXButton alloc] initWithFrame:CGRectZero];
        _pinkBtn.backgroundColor = UIColor.purpleColor;
        _pinkBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [_pinkBtn setTitle:@"Pink Color Button" forState:UIControlStateNormal];
        [_pinkBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.view addSubview:_pinkBtn];
    }
    return _pinkBtn;
}

- (void)setButtonGIFImage {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"checkout_arrow" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    //UIImage *gifImage = [UIImage sd_imageWithGIFData:gifData];//SDWebImage方法不能设置大小
    UIImage *gifImage = [UIImage yy_imageWithSmallGIFData:gifData scale:3];
    [_redBtn setImage:gifImage forState:UIControlStateNormal];
    [_redBtn layoutStyle:(WXButtonEdgeInsetsStyleRight) imageTitleSpace:5];
    
    [_redBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction {
    
}

@end
