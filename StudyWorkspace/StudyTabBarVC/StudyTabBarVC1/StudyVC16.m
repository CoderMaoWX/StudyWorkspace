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
#import "WXButton.h"

@interface StudyVC16 ()
@property (nonatomic, strong) UIButton *redBtn;
@property (nonatomic, strong) UILabel *orangeLabel;
@property (nonatomic, strong) WXButton *blueBtn;
@property (nonatomic, strong) UIButton *pinkBtn;
@end

@implementation StudyVC16

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSString *title = @"我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案9";
    
    self.blueBtn.title = title;
    self.blueBtn.topMargin = 15;
    self.blueBtn.trailingMargin = 15;
    self.blueBtn.backgroundImage = [UIImage imageNamed:@"women"];
    self.blueBtn.image = [UIImage imageNamed:@"tabbar_min_ser"];
    self.blueBtn.preferredMaxLayoutWidth = 150;
    self.blueBtn.numberOfLines = 0;
    self.blueBtn.imageTitleSpace = 5;
    self.blueBtn.imagePlacement = WXImagePlacementTop;
    
    NSLog(@"orangeLabel 111:%@", NSStringFromCGSize(self.orangeLabel.intrinsicContentSize));
    self.orangeLabel.text = nil;
    NSLog(@"orangeLabel 222:%@", NSStringFromCGSize(self.orangeLabel.intrinsicContentSize));
    
    self.orangeLabel.text = nil;
    self.orangeLabel.preferredMaxLayoutWidth = 150;
    self.orangeLabel.numberOfLines = 0;
}

#pragma mark -======== LayoutSubView ========

- (void)layoutSubview {
    [self.redBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.centerX.offset(0);
    }];
    
    [self.blueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.redBtn.mas_bottom);
        make.centerX.offset(0);
    }];
    
    [self.orangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.blueBtn.mas_bottom);
        make.centerX.offset(0);
    }];
    
    [self.pinkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orangeLabel.mas_bottom);
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

- (WXButton *)blueBtn {
    if (!_blueBtn) {
        _blueBtn = [WXButton buttonWithType:(UIButtonTypeCustom)];
        _blueBtn.backgroundColor = UIColor.blueColor;
        _blueBtn.titleFont = [UIFont boldSystemFontOfSize:16.0];
        _blueBtn.titleColor = UIColor.whiteColor;
        _blueBtn.title = @"Blue Color WXButton";
        [self.view addSubview:_blueBtn];
        
        [_blueBtn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _blueBtn;
}

- (UIButton *)pinkBtn {
    if (!_pinkBtn) {
        _pinkBtn = [[UIButton alloc] initWithFrame:CGRectZero];
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
    
    [_redBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction:(UIButton *)button {
    NSLog(@"btnAction: %@", button);
}

@end
