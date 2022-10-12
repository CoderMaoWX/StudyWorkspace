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
#import "NSString+Extension.h"
#import "UIColor+YYAdd.h"

@interface StudyVC16 ()
@property (nonatomic, strong) WXButton *redBtn;
@property (nonatomic, strong) YYLabel *yyLabel;
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
    
//    [self debugUI];
}

- (void)debugUI {
    self.redBtn.backgroundColor = UIColor.clearColor;
    self.blueBtn.backgroundColor = UIColor.clearColor;
    self.yyLabel.backgroundColor = UIColor.clearColor;
    self.systemButton.backgroundColor = UIColor.clearColor;
    self.systemLabel.backgroundColor = UIColor.clearColor;
    self.brownBtn.backgroundColor = UIColor.clearColor;
    self.blackBtn.backgroundColor = UIColor.clearColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.yyLabel.text.length == 0) {
        self.yyLabel.text = @"一句话";
    } else {
        self.yyLabel.text = nil;
    }
    return;
    
    self.layoutView.text = nil;
    self.layoutView.image = nil;
    return;
    
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
//        self.layoutView.marginInset = UIEdgeInsetsZero;
        self.layoutView.image = [UIImage imageNamed:@"like_icon"];
        
//        self.blueBtn.title = nil;
//        self.blueBtn.image = [UIImage imageNamed:@"like_icon"];
    } else {
        self.layoutView.imageTextSpace = 10;
        self.layoutView.imagePlacement = WXImagePlacementTop;
        self.layoutView.text = @"WXLayoutView kit";
        self.layoutView.image = nil;
//        self.layoutView.image = [UIImage imageNamed:@"like_icon"];
//        self.layoutView.backgroundImage = [UIImage imageNamed:@"icon_qq_zone"];
        self.layoutView.marginInset = UIEdgeInsetsMake(20, 20, 20, 20);
        
        [self.layoutView textBackgroundColor:UIColor.clearColor
                                  colorInset:UIEdgeInsetsMake(15, 15, 15, 15)
                                cornerRadius:3];
        
        [self.layoutView textBorderColor:UIColor.orangeColor
                             borderWidth:2
                             borderInset:UIEdgeInsetsMake(15, 15, 15, 15)
                            cornerRadius:3];

//        self.systemButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);

//        self.blueBtn.imageTitleSpace = 10;
//        self.blueBtn.imagePlacement = WXImagePlacementBottom;
//        self.blueBtn.leftPadding = 20;
//        self.blueBtn.topPadding = 20;
//        self.blueBtn.rightPadding = 20;
//        self.blueBtn.bottomPadding = 20;
//        self.blueBtn.title = @"Blue Color WXButton";
//        self.blueBtn.image = [UIImage imageNamed:@"like_icon"];
//        self.blueBtn.backgroundImage = [UIImage imageNamed:@"icon_qq_zone"];
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
    //    WX_ShowToastWithText(self.view, button.description);
    button.selected = !button.selected;
    
    if (button.selected) {
        self.layoutView.text = @"SALE";
        self.layoutView.textColor = UIColor.redColor;
        
        [self.layoutView textBorderColor:UIColor.redColor
                             borderWidth:1
                             borderInset:UIEdgeInsetsMake(5, 5, 5, 5)
                            cornerRadius:3];
        
        [self.layoutView textBackgroundColor:UIColor.clearColor
                                  colorInset:UIEdgeInsetsMake(15, 15, 15, 15)
                                cornerRadius:3];
    } else {
        self.layoutView.text = self.getLoogText;
        self.layoutView.image = nil;
        self.layoutView.preferredMaxLayoutWidth = 250;
        self.layoutView.imageURL = @"https://files.catbox.moe/3oemef.png";
    }
}

- (NSString *)getLoogText {
    NSString *title = @"此按钮用于约束布局时: 如果有 文本/图片 内容时需要设置外间距, 在无内容时整个按钮的大小自动为0, 并且所有外间距自动被忽略, 使用时只需根据自身逻辑设置 文本/图片 即可, 无需频繁更新约束来控制间距问题";
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
    
    [self.yyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.blueBtn.mas_bottom);
        make.centerX.offset(0);
//        make.height.mas_equalTo(200);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.yyLabel.mas_bottom);
        make.centerX.offset(0);
    }];

    [self.brownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom);
        make.centerX.offset(0);
    }];
    
    [self.layoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.brownBtn.mas_bottom);
        make.centerX.offset(0);
//        make.size.mas_equalTo(CGSizeMake(200, 200));
//        make.height.mas_equalTo(90);
//        make.width.mas_equalTo(200);
    }];
    
    [self.systemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.layoutView.mas_bottom);
        make.centerX.offset(0);
    }];
    
    [self.systemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.systemButton.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(200, 200));
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
    }
    return _blueBtn;
}

- (YYLabel *)yyLabel {
    if (!_yyLabel) {
        _yyLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _yyLabel.backgroundColor = UIColor.orangeColor;
        _yyLabel.font = [UIFont systemFontOfSize:16.0];
        _yyLabel.textColor = UIColor.whiteColor;
        _yyLabel.text = @"Test YY Label";
        _yyLabel.textContainerInset = UIEdgeInsetsMake(10, 10, 20, 10);
//        _yyLabel.attributedText = self.fetchAlertTitle;
        [self.view addSubview:_yyLabel];
    }
    return _yyLabel;
}

/// 主弹框标题
- (NSAttributedString *)fetchAlertTitle {
    return [NSString getAttriStrByTextArray:@[@"💐 我是一段富文本:", @"测试自定义富文本显示效果"]
                                    fontArr:@[[UIFont systemFontOfSize:26.0], [UIFont systemFontOfSize:16.0]]
                                   colorArr:@[[UIColor blackColor], [UIColor redColor]]
                                lineSpacing:0
                                  alignment:0];
}

- (WXLayoutView *)layoutView {
    if (!_layoutView) {
        _layoutView = [[WXLayoutView alloc] initWithFrame:CGRectZero];
        _layoutView.backgroundColor = UIColor.lightGrayColor;
        _layoutView.font = [UIFont systemFontOfSize:12];
        _layoutView.textColor = UIColor.blackColor;
        _layoutView.numberOfLines = 4;
        _layoutView.lineSpacing = 10;
        _layoutView.preferredMaxLayoutWidth = 250;
        _layoutView.imageTextSpace = 10;
        _layoutView.imagePlacement = WXImagePlacementTop;
        _layoutView.image = [UIImage imageNamed:@"mghome_manage"];
//        _layoutView.backgroundImage = [UIImage imageNamed:@"mghome_official"];
        _layoutView.marginInset = UIEdgeInsetsMake(10, 15, 5, 20);
//        [_layoutView textBackgroundColor:UIColor.blackColor colorInset:UIEdgeInsetsMake(0, 0, 0, 0) cornerRadius:3];
//        [_layoutView textBackgroundColor:UIColor.redColor colorInset:UIEdgeInsetsZero cornerRadius:3];
        _layoutView.textAlignment = NSTextAlignmentLeft;
        _layoutView.attributedText = [self fetchAlertTitle];
        [self.view addSubview:_layoutView];
    }
    return _layoutView;
}

- (UIButton *)systemButton {
    if (!_systemButton) {
        _systemButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _systemButton.backgroundColor = UIColor.greenColor;
        _systemButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_systemButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        [_systemButton setTitle:@"System Button" forState:(UIControlStateNormal)];
//        [_systemButton setBackgroundImage:[UIImage imageNamed:@"like_icon"] forState:(UIControlStateNormal)];
        [_systemButton addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:_systemButton];
    }
    return _systemButton;
}

- (UILabel *)systemLabel {
    if (!_systemLabel) {
        _systemLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _systemLabel.backgroundColor = UIColor.lightGrayColor;
        _systemLabel.font = [UIFont systemFontOfSize:12];
        _systemLabel.textColor = UIColor.whiteColor;
        _systemLabel.textAlignment = NSTextAlignmentCenter;
        _systemLabel.text = @"System Label kit";
//        _systemLabel.text = self.getLoogText;
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
