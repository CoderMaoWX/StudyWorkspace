//
//  StudyVC16.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/11/12.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "StudyVC16.h"
#import "UIImage+YYWebImage.h"
#import "UIImage+GIF.h"
#import "UIButton+WXExtension.h"
#import "Masonry.h"
#import "UIButton+WXExtension.h"
#import "WXButton.h"

@interface StudyVC16 ()
@property (nonatomic, strong) WXButton *redBtn;
@property (nonatomic, strong) UILabel *orangeLabel;
@property (nonatomic, strong) WXButton *blueBtn;
@property (nonatomic, strong) WXButton *brownBtn;
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
    
    self.blueBtn.title = @"你好，李银河";
    self.blueBtn.numberOfLines = 0;
    self.blueBtn.preferredMaxLayoutWidth = 180;
//    [self refreshText];
    self.blueBtn.image = nil;//[UIImage imageNamed:@"tabbar_min_ser"];
    self.blueBtn.image = [UIImage imageNamed:@"live_video_like"];
//    self.blueBtn.imageTitleSpace = 5;
    self.blueBtn.imagePlacement = WXImagePlacementLeading;
    self.blueBtn.imageTitleSpace = 20;

    self.blueBtn.leftPadding = 0;
    self.blueBtn.topPadding = 0;
    self.blueBtn.rightPadding = 0;
    self.blueBtn.bottomPadding = 0;
    
//    self.orangeLabel.text = @"一句话";
//    self.orangeLabel.numberOfLines = 0;
//    self.orangeLabel.preferredMaxLayoutWidth = 180;
        
//    self.brownBtn.topPadding = 20;
//    self.brownBtn.leftPadding = 0;
//    self.brownBtn.bottomPadding = 30;
//    self.brownBtn.rightPadding = 0;
//    self.brownBtn.titleLabel.layer.masksToBounds = YES;
//    self.brownBtn.titleLabel.layer.cornerRadius = 10;
//    self.brownBtn.title = nil;
//    self.brownBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //设置图片
    [self setButtonGIFImage];
    self.imageView.image = [UIImage imageNamed:@"tab_call_nor"];
}

///不导第三方库加载GIf图片
- (void)setButtonGIFImage {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cat_gif" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    UIImage *gifImage = [UIImage sd_imageWithGIFData:gifData];//SDWebImage方法不能设置大小
    gifImage = [UIImage yy_imageWithSmallGIFData:gifData scale:2]; //YYImage方法能设置大小
    self.imageView.image = gifImage;
    self.brownBtn.image = gifImage;
}

- (void)btnAction:(UIButton *)button {
    NSLog(@"btnAction: %@", button);
}

#pragma mark -======== LayoutSubView ========

- (void)layoutSubview {
    [self.redBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.centerX.offset(0);
//        make.width.mas_equalTo(180);
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
//        make.height.mas_equalTo(200);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orangeLabel.mas_bottom);
        make.centerX.offset(0);
    }];

    [self.brownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom);
        make.centerX.offset(0);
    }];

    [self.blackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.brownBtn.mas_bottom);
        make.centerX.offset(0);
    }];
}

#pragma mark -======== setup UI ========

- (WXButton *)redBtn{
    if (!_redBtn) {
        _redBtn = [[WXButton alloc] initWithFrame:CGRectZero];
        _redBtn.backgroundColor = UIColor.redColor;
        _redBtn.titleFont = [UIFont systemFontOfSize:16.0];
        _redBtn.titleColor = UIColor.whiteColor;
        _redBtn.title = @"Red Color Button";
        [self.view addSubview:_redBtn];
    }
    return _redBtn;
}

- (WXButton *)blueBtn {
    if (!_blueBtn) {
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

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (WXButton *)brownBtn {
    if (!_brownBtn) {
        _brownBtn = [[WXButton alloc] initWithFrame:CGRectZero];
        _brownBtn.backgroundColor = UIColor.brownColor;
        _brownBtn.titleFont = [UIFont systemFontOfSize:16.0];
        _brownBtn.titleColor = UIColor.whiteColor;
        _brownBtn.title = @"Brown Color WXButton";
        [self.view addSubview:_brownBtn];
    }
    return _brownBtn;
}

- (WXButton *)blackBtn {
    if (!_blackBtn) {
        _blackBtn = [[WXButton alloc] initWithFrame:CGRectZero];
        _blackBtn.backgroundColor = UIColor.blackColor;
        _blackBtn.titleFont = [UIFont systemFontOfSize:16.0];
        _blackBtn.titleColor = UIColor.whiteColor;
        _blackBtn.title = @"Black Color Button";
        [self.view addSubview:_blackBtn];
    }
    return _blackBtn;
}

@end
