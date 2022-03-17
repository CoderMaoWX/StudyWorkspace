//
//  WXButton.m
//  StudyWorkspace
//
//  Created by Luke on 2022/3/13.
//  Copyright © 2022 MaoWX. All rights reserved.
//

#import "WXButton.h"

@implementation WXButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    _attributedTitle = nil;
    self.titleLabel.attributedText = nil;
    [self setAttributedTitle:nil forState:UIControlStateNormal];
    
    self.titleLabel.text = title;
    [self setTitle:title forState:(UIControlStateNormal)];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self setTitleColor:titleColor forState:(UIControlStateNormal)];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    self.titleLabel.numberOfLines = numberOfLines;
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    _attributedTitle = attributedTitle;
    
    _title = nil;
    self.titleLabel.text = nil;
    [self setTitle:nil forState:(UIControlStateNormal)];
    
    self.titleLabel.attributedText = attributedTitle;
    [self setAttributedTitle:attributedTitle forState:UIControlStateNormal];
}

- (void)setTextLineBreakMode:(NSLineBreakMode)textLineBreakMode {
    _textLineBreakMode = textLineBreakMode;
    self.titleLabel.lineBreakMode = textLineBreakMode;
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    self.titleLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (CGSize)intrinsicContentSize {
    // 强制更新布局，以获得最新的 imageView 和 titleLabel 的 frame
    [self layoutIfNeeded];
    
    if (!self.currentTitle && !self.attributedTitle && !self.currentImage) {
        return CGSizeZero;
    }
    if (self.preferredMaxLayoutWidth > 0) {
        self.titleLabel.preferredMaxLayoutWidth = self.preferredMaxLayoutWidth;
    }
    CGSize titleSize = self.titleLabel.intrinsicContentSize;
    
    CGFloat titleWidth = 0.0;
    CGFloat titleHeight = 0.0;
    if (titleSize.width > 0 && titleSize.height > 0) {
        titleWidth = titleSize.width;
        titleHeight = titleSize.height;
    }
    if (self.preferredMaxLayoutWidth > 0) {
        titleWidth = MIN(self.preferredMaxLayoutWidth, titleWidth);
    }
    
    CGSize imgSize = self.imageView.intrinsicContentSize;
    
    CGFloat imgWidth = 0.0;
    CGFloat imgHeight = 0.0;
    if (imgSize.width > 0 && imgSize.height > 0) {
        imgWidth = imgSize.width;
        imgHeight = imgSize.height;
    }
    
    CGFloat imageTitleSpace = self.imageTitleSpace;
    if (titleWidth == 0 || imgWidth == 0) {
        imageTitleSpace = 0;
    }
    //左右布局
    if (self.imagePlacement == WXImagePlacementLeading ||
        self.imagePlacement == WXImagePlacementTrailing) {
        
        CGFloat width = self.leftPadding + titleWidth + imageTitleSpace + imgWidth + self.rightPadding;
        CGFloat height = self.topPadding + MAX(titleHeight, imgHeight) + self.bottomPadding;
        
        return CGSizeMake(width, height);
        
    } else {  //上下布局
        CGFloat width = self.leftPadding + MAX(titleWidth, imgWidth) + self.rightPadding;
        CGFloat height = self.topPadding + titleHeight + imageTitleSpace + imgHeight + self.bottomPadding;
        
        return CGSizeMake(width, height);
    }
}

- (void)setTopPadding:(CGFloat)topPadding {
    _topPadding = topPadding;
    UIEdgeInsets insets = self.contentEdgeInsets;
    insets.top = topPadding;
    self.contentEdgeInsets = insets;
    [self layoutIfNeeded];
}

- (void)setBottomPadding:(CGFloat)bottomPadding {
    _bottomPadding = bottomPadding;
    UIEdgeInsets insets = self.contentEdgeInsets;
    insets.bottom = bottomPadding;
    self.contentEdgeInsets = insets;
    [self layoutIfNeeded];
}

- (void)setLeftPadding:(CGFloat)leftPadding {
    _leftPadding = leftPadding;
    UIEdgeInsets insets = self.contentEdgeInsets;
    insets.left = leftPadding;
    self.contentEdgeInsets = insets;
    [self layoutIfNeeded];
}

- (void)setRightPadding:(CGFloat)rightPadding {
    _rightPadding = rightPadding;
    UIEdgeInsets insets = self.contentEdgeInsets;
    insets.right = rightPadding;
    self.contentEdgeInsets = insets;
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIImageView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]] && CGSizeEqualToSize(subView.bounds.size, self.bounds.size)) {
            subView.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
    
    if (self.preferredMaxLayoutWidth > 0) {
        self.titleLabel.preferredMaxLayoutWidth = self.preferredMaxLayoutWidth;
    }
    
    //内边距: (top/left/bottom/right)
    if (UIEdgeInsetsEqualToEdgeInsets(self.contentEdgeInsets, UIEdgeInsetsZero)) {
        self.contentEdgeInsets = UIEdgeInsetsMake(self.topPadding,
                                                  self.leftPadding,
                                                  self.bottomPadding,
                                                  self.rightPadding);
    }
    [self layoutStyle:self.imagePlacement space:self.imageTitleSpace];
}

/** 布局标题和图片位置
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutStyle:(WXImagePlacementStyle)style space:(CGFloat)space {
    
    // 强制更新布局，以获得最新的 imageView 和 titleLabel 的 frame
    [self layoutIfNeeded];
    
    // 1. 得到imageView和titleLabel的宽、高
    CGSize titleSize = self.titleLabel.intrinsicContentSize;
    
    CGFloat titleWidth = 0.0;
    CGFloat titleHeight = 0.0;
    if (titleSize.width > 0 && titleSize.height > 0) {
        titleWidth = titleSize.width;
        titleHeight = titleSize.height;
    }
    if (self.preferredMaxLayoutWidth > 0) {
        titleWidth = MIN(self.preferredMaxLayoutWidth, titleWidth);
    }
    
    CGSize imgSize = self.imageView.intrinsicContentSize;
    
    CGFloat imgWidth = 0.0;
    CGFloat imgHeight = 0.0;
    if (imgSize.width > 0 && imgSize.height > 0) {
        imgWidth = imgSize.width;
        imgHeight = imgSize.height;
    }
    
    if (titleWidth == 0 || imgWidth == 0) {
        space = 0;
    }
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    BOOL isRightToLeftShow = NO;//是否从右往左布局 (如: 阿拉伯语布局)
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case WXImagePlacementTop: // image在上，label在下
        {
            if (isRightToLeftShow) {//阿语
                imageEdgeInsets = UIEdgeInsetsMake(-titleHeight-space/2.0, -titleWidth, 0, 0);
                labelEdgeInsets = UIEdgeInsetsMake(0, 0, -imgHeight-space/2.0, -imgWidth);
            } else {
                imageEdgeInsets = UIEdgeInsetsMake(-titleHeight-space/2.0, 0, 0, -titleWidth);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imgWidth, -imgHeight-space/2.0, 0);
            }
        }
            break;
        case WXImagePlacementLeading: // image在左，label在右
        {
            if (isRightToLeftShow) {//阿语
                imageEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            } else {
                imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
            }
        }
            break;
        case WXImagePlacementBottom: // image在下，label在上
        {
            if (isRightToLeftShow) {//阿语
                imageEdgeInsets = UIEdgeInsetsMake(0, -titleWidth, -titleHeight-space/2.0, 0);
                labelEdgeInsets = UIEdgeInsetsMake(-imgHeight-space/2.0, 0, 0, -imgWidth);
            } else  {
                imageEdgeInsets = UIEdgeInsetsMake(0, 0, -titleHeight-space/2.0, -titleWidth);
                labelEdgeInsets = UIEdgeInsetsMake(-imgHeight-space/2.0, -imgWidth, 0, 0);
            }
        }
            break;
        case WXImagePlacementTrailing: // image在右，label在左
        {
            if (isRightToLeftShow) {//阿语
                imageEdgeInsets = UIEdgeInsetsMake(0, -titleWidth-space/2.0, 0, titleWidth+space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, imgWidth+space/2.0, 0, -imgWidth-space/2.0);
            } else {
                imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth+space/2.0, 0, -titleWidth-space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imgWidth-space/2.0, 0, imgWidth+space/2.0);
            }
        }
            break;
        default:
            break;
    }
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
