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
@property (nonatomic, strong) WXButton *redBtn;
@property (nonatomic, strong) UILabel *orangeLabel;
@property (nonatomic, strong) WXButton *blueBtn;
@property (nonatomic, strong) WXButton *pinkBtn;
@property (nonatomic, strong) WXButton *blackBtn;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation StudyVC16

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubview];
//    [self refreshText];
}

- (void)refreshText {
    NSString *title = @"我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案9";
    
    self.blueBtn.title = title;
//    self.orangeLabel.text = title;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    self.orangeLabel.text = @"一句话";
//    self.orangeLabel.numberOfLines = 0;
//    self.orangeLabel.preferredMaxLayoutWidth = 180;
    
//    self.blueBtn.title = @"一句话很好";
    self.blueBtn.title = @"你好，李银河";
    self.blueBtn.numberOfLines = 0;
    self.blueBtn.preferredMaxLayoutWidth = 180;
//    [self refreshText];
    self.blueBtn.image = nil;//[UIImage imageNamed:@"tabbar_min_ser"];
    self.blueBtn.image = [UIImage imageNamed:@"live_video_like"]; //@"women"
//    self.blueBtn.imageTitleSpace = 5;
    self.blueBtn.imagePlacement = WXImagePlacementLeading;
    self.blueBtn.imageTitleSpace = 20;
    //图片
    //self.imageView.image = [UIImage imageNamed:@"Sticker Pack"];

    self.blueBtn.leftPadding = 0;
    self.blueBtn.topPadding = 0;
    self.blueBtn.rightPadding = 0;
    self.blueBtn.bottomPadding = 0;
    
//    self.pinkBtn.topPadding = 20;
//    self.pinkBtn.leftPadding = 0;
//    self.pinkBtn.bottomPadding = 30;
//    self.pinkBtn.rightPadding = 0;
    
//    self.pinkBtn.titleLabel.layer.masksToBounds = YES;
//    self.pinkBtn.titleLabel.layer.cornerRadius = 10;
    self.pinkBtn.title = nil;

}

#pragma mark -======== LayoutSubView ========

- (void)layoutSubview {
    [self.redBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.centerX.offset(0);
        make.width.mas_equalTo(180);
    }];
    
    [self.blueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.redBtn.mas_bottom);
        make.centerX.offset(0);
//        make.size.mas_equalTo(CGSizeMake(210, 100));
//        make.height.mas_equalTo(200);
    }];
    
    [self.orangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.blueBtn.mas_bottom);
        make.centerX.offset(0);
        make.height.mas_equalTo(200);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.orangeLabel);
    }];

    [self.pinkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orangeLabel.mas_bottom);
        make.centerX.offset(0);
    }];

    [self.blackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pinkBtn.mas_bottom);
        make.centerX.offset(0);
    }];
}

#pragma mark -======== setup UI ========

- (WXButton *)redBtn{
    if (!_redBtn) {
        _redBtn = [[WXButton alloc] initWithFrame:CGRectZero];
        _redBtn.backgroundColor = UIColor.redColor;
        _redBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
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
        _orangeLabel.font = [UIFont systemFontOfSize:16.0];
        _orangeLabel.textColor = UIColor.whiteColor;
        _orangeLabel.text = @"Orange Lbael";
        [self.view addSubview:_orangeLabel];
    }
    return _orangeLabel;
}

- (WXButton *)blueBtn {
    if (!_blueBtn) {
//        CGRect rect = CGRectMake(0, 0, 50, 50);
        _blueBtn = [[WXButton alloc] initWithFrame:CGRectZero];
        _blueBtn.backgroundColor = UIColor.blueColor;
        _blueBtn.titleFont = [UIFont systemFontOfSize:16.0];
        _blueBtn.titleColor = UIColor.whiteColor;
        _blueBtn.title = @"Blue Color WXButton";
        [self.view addSubview:_blueBtn];
//        [_blueBtn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _blueBtn;
}

- (WXButton *)pinkBtn {
    if (!_pinkBtn) {
        _pinkBtn = [[WXButton alloc] initWithFrame:CGRectZero];
        _pinkBtn.backgroundColor = UIColor.clearColor;
        _pinkBtn.titleLabel.backgroundColor = UIColor.systemPinkColor;
        _pinkBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_pinkBtn setTitle:@"Pink Color Button" forState:UIControlStateNormal];
        [_pinkBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.view addSubview:_pinkBtn];
    }
    return _pinkBtn;
}

- (WXButton *)blackBtn {
    if (!_blackBtn) {
        _blackBtn = [[WXButton alloc] initWithFrame:CGRectZero];
        _blackBtn.backgroundColor = UIColor.blackColor;
        _blackBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_blackBtn setTitle:@"Black Color Button" forState:UIControlStateNormal];
        [_blackBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.view addSubview:_blackBtn];
    }
    return _blackBtn;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"Sticker Pack"];
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

///不导第三方库加载GIf图片
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
