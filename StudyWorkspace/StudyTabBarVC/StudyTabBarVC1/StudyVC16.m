//
//  StudyVC16.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/11/12.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "StudyVC16.h"
#import "WXCFunctionTool.h"
#import "UIImage+YYWebImage_Copy.h"
#import "UIImage+GIF.h"
#import "UIButton+WXExtension.h"
#import "Masonry.h"
#import "UIButton+WXExtension.h"
#import "WXButton.h"
#import "YYText.h"
#import "WXLayoutView.h"

@interface StudyVC16 ()
@property (nonatomic, strong) WXButton *redBtn;
@property (nonatomic, strong) YYLabel *orangeLabel;
@property (nonatomic, strong) WXButton *blueBtn;
@property (nonatomic, strong) WXButton *brownBtn;
@property (nonatomic, strong) WXButton *blackBtn;
@property (nonatomic, strong) WXLayoutView *layoutView;
@property (nonatomic, strong) UIButton *systemButton;
@property (nonatomic, strong) UILabel *systemLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation StudyVC16

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.blueBtn.title = self.getLoogText;
    self.blueBtn.title = @"你好，李银河";
    self.blueBtn.numberOfLines = 0;
    self.blueBtn.preferredMaxLayoutWidth = 180;
    self.blueBtn.image = [UIImage imageNamed:@"like_icon"];
    self.blueBtn.imagePlacement = WXImagePlacementLeading;
    self.blueBtn.imageTitleSpace = 5;

    self.blueBtn.leftPadding = 0;
    self.blueBtn.topPadding = 0;
    self.blueBtn.rightPadding = 0;
    self.blueBtn.bottomPadding = 0;
    
//    self.orangeLabel.text = @"一句话";
//    self.orangeLabel.numberOfLines = 0;
//    self.orangeLabel.preferredMaxLayoutWidth = 180;
//    self.orangeLabel.text = self.getLoogText;
    
    if (self.orangeLabel.text.length == 0) {
        self.orangeLabel.text = @"一句话";
    } else {
        self.orangeLabel.text = nil;
    }

//    self.brownBtn.topPadding = 20;
//    self.brownBtn.leftPadding = 0;
//    self.brownBtn.bottomPadding = 30;
//    self.brownBtn.rightPadding = 0;
    self.brownBtn.backgroundColor = UIColor.clearColor;
    self.brownBtn.titleLabel.backgroundColor = UIColor.systemPinkColor;
    self.brownBtn.titleLabel.layer.masksToBounds = YES;
    self.brownBtn.titleLabel.layer.cornerRadius = 10;
//    self.brownBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//    self.brownBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//    self.brownBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//    self.brownBtn.title = nil;
    
    //设置图片
//    self.brownBtn.image = [self getGIFImage:@"cat_gif"];
//    self.imageView.image = [self getGIFImage:@"giftBox_gif"];
    
    
    if (self.layoutView.text.length != 0) {
        self.layoutView.text = nil;
//        self.layoutView.image = [UIImage imageNamed:@"like_icon"];
        
        self.blueBtn.title = nil;
        self.blueBtn.image = [UIImage imageNamed:@"like_icon"];
    } else {
        self.layoutView.imageTextSpace = 0;
        self.layoutView.imagePlacement = WXImagePlacementTrailing;
//        self.layoutView.paddingInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.layoutView.text = @"WXLayoutView kit";
//        self.layoutView.image = [UIImage imageNamed:@"like_icon"];
        self.layoutView.backgroundImage = [UIImage imageNamed:@"icon_qq_zone"];
        
//        self.systemButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//        [self.systemButton sizeToFit];

        self.blueBtn.imageTitleSpace = 20;
        self.blueBtn.imagePlacement = WXImagePlacementTrailing;
        self.blueBtn.leftPadding = 10;
        self.blueBtn.topPadding = 10;
        self.blueBtn.rightPadding = 10;
        self.blueBtn.bottomPadding = 10;
        self.blueBtn.title = @"WXLayoutView kit";
        self.blueBtn.image = [UIImage imageNamed:@"like_icon"];
        [self.blueBtn setBackgroundImage:[UIImage imageNamed:@"icon_qq_zone"]];
    }
}

///不导第三方库加载GIf图片
- (UIImage *)getGIFImage:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    UIImage *gifImage = [UIImage sd_imageWithGIFData:gifData];//SDWebImage方法不能设置大小
    gifImage = [UIImage yy_imageWithSmallGIFData:gifData scale:2]; //YYImage方法能设置大小
    return gifImage;
}

- (void)btnAction:(UIButton *)button {
    NSLog(@"btnAction: %@", button);
    WX_ShowToastWithText(self.view, button.description);
}

- (NSString *)getLoogText {
    NSString *title = @"我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案,我是一段很长的文案9";
    return title;
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
    
    [self.layoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.brownBtn.mas_bottom);
        make.centerX.offset(0);
    }];
    
    [self.systemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.layoutView.mas_bottom);
        make.centerX.offset(0);
    }];
    
    [self.systemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.systemButton.mas_bottom);
        make.centerX.offset(0);
    }];
    
    [self.blackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.systemLabel.mas_bottom);
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

- (YYLabel *)orangeLabel {
    if (!_orangeLabel) {
        _orangeLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _orangeLabel.backgroundColor = UIColor.orangeColor;
        _orangeLabel.font = [UIFont systemFontOfSize:16.0];
        _orangeLabel.textColor = UIColor.whiteColor;
        _orangeLabel.text = @"Orange Lbael";
//        _orangeLabel.textContainerInset = UIEdgeInsetsMake(10, 10, 20, 10);
        [self.view addSubview:_orangeLabel];
    }
    return _orangeLabel;
}

- (WXLayoutView *)layoutView {
    if (!_layoutView) {
        _layoutView = [[WXLayoutView alloc] initWithFrame:CGRectZero];
        _layoutView.backgroundColor = UIColor.lightGrayColor;
        _layoutView.font = [UIFont systemFontOfSize:16.0];
        _layoutView.textColor = UIColor.redColor;
//        _layoutView.text = @"WXLayoutView kit";
//        _layoutView.text = @"Orange Lbael";
        [self.view addSubview:_layoutView];
    }
    return _layoutView;
}

- (UIButton *)systemButton {
    if (!_systemButton) {
        _systemButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _systemButton.backgroundColor = UIColor.greenColor;
        _systemButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_systemButton setTitleColor:UIColor.redColor forState:(UIControlStateNormal)];
        [_systemButton setTitle:@"WXLayoutView kit" forState:(UIControlStateNormal)];
        [_systemButton setBackgroundImage:[UIImage imageNamed:@"icon_qq_zone"] forState:(UIControlStateNormal)];
        [self.view addSubview:_systemButton];
    }
    return _systemButton;
}

- (UILabel *)systemLabel {
    if (!_systemLabel) {
        _systemLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _systemLabel.backgroundColor = UIColor.lightGrayColor;
        _systemLabel.font = [UIFont systemFontOfSize:16];
        _systemLabel.textColor = UIColor.redColor;
        _systemLabel.text = @"WXLayoutView kit";
        [self.view addSubview:_systemLabel];
    }
    return _systemLabel;
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
