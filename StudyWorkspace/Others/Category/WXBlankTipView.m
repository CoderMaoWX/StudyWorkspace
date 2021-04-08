//
//  WXBlankTipView.m
//  CommonFrameWork
//
//  Created by mao wangxin on 2016/11/24.
//  Copyright © 2016年 okdeer. All rights reserved.
//

#import "WXBlankTipView.h"
#import "Masonry.h"

#define UIBlankColorRGB(R, G, B, a)         [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:a]
#define UIBlankColorFromHex(hexValue, a)    [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0x00FF00) >> 8))/255.0 blue:((float)(hexValue & 0x0000FF))/255.0 alpha:a]


@interface WXBlankTipView ()
@property (nonatomic, strong) UIView                *contenView;
@property (nonatomic, strong) UIImageView           *tipImageView;
@property (nonatomic, strong) UILabel               *tipLabel;
@property (nonatomic, strong) UILabel               *subTitleLabel;
@property (nonatomic, strong, readwrite) UIButton   *actionBtn;
@end

@implementation WXBlankTipView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self autoLayoutView];
        self.tag = kBlankTipViewTag;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - <Layout SubView>

- (void)initView {
    [self addSubview:self.contenView];
    [self.contenView addSubview:self.tipImageView];
    [self.contenView addSubview:self.tipLabel];
    [self.contenView addSubview:self.subTitleLabel];
    [self.contenView addSubview:self.actionBtn];
}

- (void)autoLayoutView {
    [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(self.mas_width);
    }];
    
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contenView.mas_top);
        make.centerX.mas_equalTo(self.contenView.mas_centerX);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipImageView.mas_bottom).offset(16);
        make.leading.mas_equalTo(self.contenView.mas_leading).offset(12);
        make.trailing.mas_equalTo(self.contenView.mas_trailing).offset(-12);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(0);
        make.leading.mas_equalTo(self.contenView.mas_leading).offset(12);
        make.trailing.mas_equalTo(self.contenView.mas_trailing).offset(-12);
    }];
    
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self.contenView.mas_centerX);
        make.height.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contenView.mas_bottom);
    }];
}

#pragma mark -======== Setter ========

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    self.tipImageView.image = iconImage;
    self.tipImageView.hidden = NO;
}

- (void)setTitle:(id)title {
    _title = title;
    if ([title isKindOfClass:[NSString class]]) {
        self.tipLabel.text = title;
        self.tipLabel.hidden = NO;
        
    } else if ([title isKindOfClass:[NSAttributedString class]]) {
        self.tipLabel.attributedText = title;
        self.tipLabel.hidden = NO;
    }
}

- (void)setSubTitle:(id)subTitle {
    _subTitle = subTitle;
    if ([subTitle isKindOfClass:[NSString class]]) {
        self.subTitleLabel.text = subTitle;
        self.subTitleLabel.hidden = NO;
        
    } else if ([subTitle isKindOfClass:[NSAttributedString class]]) {
        self.subTitleLabel.attributedText = subTitle;
        self.subTitleLabel.hidden = NO;
    }
    if (!self.subTitleLabel.isHidden) {
        [self.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(36);
        }];
    }
}

- (void)setButtonTitle:(id)buttonTitle {
    _buttonTitle = buttonTitle;
    if ([buttonTitle isKindOfClass:[NSString class]]) {
        [self.actionBtn setTitle:buttonTitle forState:0];
        self.actionBtn.hidden = NO;
        
    } else if ([buttonTitle isKindOfClass:[NSAttributedString class]]) {
        [self.actionBtn setAttributedTitle:buttonTitle forState:0];
        self.actionBtn.hidden = NO;
    }
    if (!self.actionBtn.isHidden) {
        [self.actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(40);
        }];
    }
}

- (void)setContenViewOffsetPoint:(CGPoint)contenViewOffsetPoint {
    _contenViewOffsetPoint = contenViewOffsetPoint;
    
    [self.contenView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(contenViewOffsetPoint.x);
        make.centerY.mas_equalTo(self.mas_centerY).offset(contenViewOffsetPoint.y);
        make.width.mas_equalTo(self.mas_width);
    }];
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 2.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,  [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark -======== Getter ========

- (UIView *)contenView {
    if (!_contenView) {
        _contenView = [[UIView alloc] initWithFrame:CGRectZero];
        _contenView.backgroundColor = [UIColor clearColor];
    }
    return _contenView;
}

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _tipImageView.backgroundColor = [UIColor clearColor];
        _tipImageView.contentMode = UIViewContentModeScaleAspectFill;
        _tipImageView.hidden = YES;
    }
    return _tipImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = UIBlankColorFromHex(0x999999, 1.0);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.adjustsFontSizeToFitWidth = YES;
        _tipLabel.numberOfLines = 0;
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textColor = UIBlankColorRGB(153, 153, 153, 1.0);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.adjustsFontSizeToFitWidth = YES;
        _subTitleLabel.numberOfLines = 0;
        CGFloat maxW = [UIScreen mainScreen].bounds.size.width - 12 * 2;
        _subTitleLabel.preferredMaxLayoutWidth = maxW;
        _subTitleLabel.hidden = YES;
    }
    return _subTitleLabel;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_actionBtn setTitleColor:[UIColor whiteColor] forState:0];
        _actionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_actionBtn setBackgroundImage:[self createImageWithColor:UIBlankColorFromHex(0xF29448, 1.0)] forState:UIControlStateNormal];
        [_actionBtn setBackgroundImage:[self createImageWithColor:UIBlankColorFromHex(0xF29448, 0.8)] forState:UIControlStateHighlighted];
        [_actionBtn addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
        _actionBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 28, 0, 28);
        _actionBtn.titleLabel.numberOfLines = 0;
        _actionBtn.layer.cornerRadius = 20;
        _actionBtn.layer.masksToBounds = YES;
        _actionBtn.hidden = YES;
    }
    return _actionBtn;
}

/** 提示按钮点击事件 */
- (void)buttonAction {
    if (self.actionBtnBlcok) {
        self.actionBtnBlcok();
    }
}

@end

