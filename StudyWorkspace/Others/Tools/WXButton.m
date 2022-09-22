//
//  WXButton.m
//  StudyWorkspace
//
//  Created by Luke on 2022/3/13.
//  Copyright © 2022 MaoWX. All rights reserved.
//

#import "WXButton.h"

@interface WXButton ()
@property (nonatomic, assign) BOOL hasLayoutCustomUI;
@end

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
    [self refreshTitleLabelInfo];
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

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    self.titleLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
}

- (void)setTextLineBreakMode:(NSLineBreakMode)textLineBreakMode {
    _textLineBreakMode = textLineBreakMode;
    self.titleLabel.lineBreakMode = textLineBreakMode;
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    _attributedTitle = attributedTitle;
    
    _title = nil;
    self.titleLabel.text = nil;
    [self setTitle:nil forState:(UIControlStateNormal)];
    
    self.titleLabel.attributedText = attributedTitle;
    [self setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [self refreshTitleLabelInfo];
}

- (void)refreshTitleLabelInfo {
    if (self.preferredMaxLayoutWidth > 0) {
        self.titleLabel.preferredMaxLayoutWidth = self.preferredMaxLayoutWidth;
    }
    if (self.numberOfLines > 0) {
        self.titleLabel.numberOfLines = self.numberOfLines;
    }
    if (self.textLineBreakMode) {
        self.titleLabel.lineBreakMode = self.textLineBreakMode;
    } else {
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
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

- (void)setTopPadding:(CGFloat)topPadding {
    _topPadding = topPadding;
    [self refreshPadding:UIRectEdgeTop padding:topPadding];
}

- (void)setLeftPadding:(CGFloat)leftPadding {
    _leftPadding = leftPadding;
    [self refreshPadding:UIRectEdgeLeft padding:leftPadding];
}

- (void)setBottomPadding:(CGFloat)bottomPadding {
    _bottomPadding = bottomPadding;
    [self refreshPadding:UIRectEdgeBottom padding:bottomPadding];
}

- (void)setRightPadding:(CGFloat)rightPadding {
    _rightPadding = rightPadding;
    [self refreshPadding:UIRectEdgeRight padding:rightPadding];
}

/// 更新内边距: (top/left/bottom/right)
- (void)refreshPadding:(UIRectEdge)directional
               padding:(CGFloat)padding {
    UIEdgeInsets insets = self.contentEdgeInsets;
    switch (directional) {
        case UIRectEdgeTop:
            insets.top = padding;
            break;
        case UIRectEdgeLeft:
            insets.left = padding;
            break;
        case UIRectEdgeBottom:
            insets.bottom = padding;
            break;
        case UIRectEdgeRight:
            insets.right = padding;
            break;
        default:
            break;
    }
    self.contentEdgeInsets = insets;
}

- (CGSize)intrinsicContentSize {
    // 强制更新布局，以获得最新的 imageView 和 titleLabel 的 frame
    [self layoutIfNeeded];
    
    BOOL hasTitle = (self.currentTitle && self.currentTitle.length != 0);
    BOOL hasAttribTitle = (self.attributedTitle && self.attributedTitle.string.length != 0);
    
    //空内容就返回: Zero
    if (!hasTitle && !hasAttribTitle && !self.currentImage) {
        return CGSizeZero;
    }
    
    CGSize titleSize = self.titleLabel.intrinsicContentSize;
    CGFloat titleWidth = 0.0;
    CGFloat titleHeight = 0.0;
    if (titleSize.width > 0 && titleSize.height > 0) {
        titleHeight = titleSize.height;
        if (self.preferredMaxLayoutWidth > 0) {
            titleWidth = MIN(self.preferredMaxLayoutWidth, titleSize.width);
        } else {
            titleWidth = titleSize.width;
        }
    }
    
    CGSize imgSize = self.imageView.intrinsicContentSize;
    CGFloat imgWidth = 0.0;
    CGFloat imgHeight = 0.0;
    if (imgSize.width > 0 && imgSize.height > 0) {
        imgWidth = imgSize.width;
        imgHeight = imgSize.height;
    }

    BOOL hasTitleAndImage = ((hasTitle || hasAttribTitle) && self.currentImage);
    CGFloat imageTitleSpace = hasTitleAndImage ? self.imageTitleSpace : 0;
    if (titleWidth == 0 || titleHeight == 0 ||
        imgWidth == 0 || imgHeight == 0) {
        imageTitleSpace = 0;
    }
    
    //上下布局
    if (hasTitleAndImage &&
        (self.imagePlacement == WXImagePlacementTop || self.imagePlacement == WXImagePlacementBottom)) {
        
        CGFloat width = self.leftPadding + MAX(titleWidth, imgWidth) + self.rightPadding;
        CGFloat height = self.topPadding + titleHeight + imageTitleSpace + imgHeight + self.bottomPadding;
        
        //NSLog(@"固有大小 上下布局: %@", NSStringFromCGSize(CGSizeMake(width, height)));
        return CGSizeMake(width, height);
        
    } else {//左右布局
        CGFloat width = self.leftPadding + titleWidth + imageTitleSpace + imgWidth + self.rightPadding;
        CGFloat height = self.topPadding + MAX(titleHeight, imgHeight) + self.bottomPadding;
        
        //NSLog(@"固有大小 左右布局: %@", NSStringFromCGSize(CGSizeMake(width, height)));
        return CGSizeMake(width, height);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //防止调用 layoutImageTitleStyle 方法后会死循环调用 layoutSubviews
    if (!self.hasLayoutCustomUI) {
        self.hasLayoutCustomUI = YES;
        
        //如果有背景图
        if (self.currentBackgroundImage) {
            for (UIImageView *subView in self.subviews) {
                if ([subView isKindOfClass:[UIImageView class]] && CGSizeEqualToSize(subView.bounds.size, self.bounds.size)) {
                    subView.contentMode = UIViewContentModeScaleAspectFill;
                }
            }
        }
        //布局Image和Title位置
        [self layoutImageTitleStyle];
        
        self.hasLayoutCustomUI = NO;
        //NSLog(@"布局大小: %@", self);
    }

}

/** 布局Image和Title位置
 *  设置button的titleLabel和imageView的布局样式，及间距
 */
- (void)layoutImageTitleStyle {
    CGFloat maxWidth = self.frame.size.width; //[self intrinsicContentSize].width;
    CGFloat maxHeight = self.frame.size.height; //[self intrinsicContentSize].height;

    UIEdgeInsets contentEdge = self.contentEdgeInsets;
    if (!UIEdgeInsetsEqualToEdgeInsets(contentEdge, UIEdgeInsetsZero)) {
        self.contentEdgeInsets = UIEdgeInsetsZero;
        _topPadding = contentEdge.top;
        _leftPadding = contentEdge.left;
        _bottomPadding = contentEdge.bottom;
        _rightPadding = contentEdge.right;
        return;
    }
    
    // 1. 得到titleLabel的宽、高
    CGSize titleSize = self.titleLabel.intrinsicContentSize;
    
    CGFloat titleWidth = 0.0;
    CGFloat titleHeight = 0.0;
    if (titleSize.width > 0 && titleSize.height > 0) {
        titleWidth = MIN(maxWidth-(self.leftPadding + self.rightPadding), titleSize.width);
        titleHeight = MIN(maxHeight-(self.topPadding + self.bottomPadding), titleSize.height);
    }
    
    // 2.得到imageView的宽、高
    CGSize imgSize = self.imageView.intrinsicContentSize;
    
    CGFloat imgWidth = 0.0;
    CGFloat imgHeight = 0.0;
    if (imgSize.width > 0 && imgSize.height > 0) {
        imgWidth = MIN(maxWidth-(self.leftPadding + self.rightPadding), imgSize.width);
        imgHeight = MIN(maxHeight-(self.topPadding + self.bottomPadding), imgSize.height);
    }
    
    BOOL hasTitle = (self.currentTitle && self.currentTitle.length != 0);
    BOOL hasAttribTitle = (self.attributedTitle && self.attributedTitle.string.length != 0);
    BOOL hasTitleAndImage = ((hasTitle || hasAttribTitle) && self.currentImage);
    
    CGFloat imageTitleSpace = hasTitleAndImage ? self.imageTitleSpace : 0;
    if (titleWidth == 0 || titleHeight == 0 ||
        imgWidth == 0 || imgHeight == 0) {
        imageTitleSpace = 0;
    }

    switch (self.imagePlacement) {
        case WXImagePlacementTop: {
            //1.Image位置
            CGRect imageRect = self.imageView.frame;
            imageRect.size = self.imageView.image.size;
            imageRect.origin.y = self.topPadding;
            self.imageView.frame = imageRect;

            //2.Title位置
            CGRect titleRect = self.titleLabel.frame;
            titleRect.origin.y = CGRectGetMaxY(imageRect) + imageTitleSpace;
            titleRect.origin.x = self.leftPadding;
            CGFloat tmpWidth = maxWidth - (self.leftPadding + self.rightPadding);
            CGFloat tmpHeight = maxHeight - titleRect.origin.y;
            if (tmpWidth > 0){
                titleRect.size.width = tmpWidth;
            }
            if (tmpHeight > 0){
                titleRect.size.height = tmpHeight;
            }
            
            self.titleLabel.frame = titleRect;
            
            //Title 比 Image宽
            if (titleSize.width > imgSize.width) {
                CGPoint point = self.imageView.center;
                point.x = self.titleLabel.center.x;
                self.imageView.center = point;
                
            } else {//Image 比 Title宽
                imageRect.origin.x = self.leftPadding;
                self.imageView.frame = imageRect;
                
                titleRect.origin.x = 0;
                titleRect.size.width = maxWidth;
                self.titleLabel.frame = titleRect;
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
        }
            break;
            
        case WXImagePlacementLeading: {
            //1.Image位置
            CGRect imageRect = self.imageView.frame;
            imageRect.size = self.imageView.image.size;
            imageRect.origin.x = self.leftPadding;
            self.imageView.frame = imageRect;

            //2.Title位置
            CGRect titleRect = self.titleLabel.frame;
            titleRect.origin.x = CGRectGetMaxX(imageRect) + imageTitleSpace;
            titleRect.origin.y = self.topPadding;
            CGFloat tmpWidth = maxWidth - (self.leftPadding + imageTitleSpace + imgWidth + self.rightPadding);
            CGFloat tmpHeight = maxHeight - (self.topPadding + self.bottomPadding);
            if (tmpWidth > 0){
                titleRect.size.width = tmpWidth;
            }
            if (tmpHeight > 0){
                titleRect.size.height = tmpHeight;
            }
            self.titleLabel.frame = titleRect;
            
            CGPoint point = self.imageView.center;
            point.y = self.titleLabel.center.y;
            self.imageView.center = point;
        }
            break;
            
        case WXImagePlacementBottom: {
            //1.Title位置
            CGRect titleRect = self.titleLabel.frame;
            titleRect.origin.y = self.topPadding;
            titleRect.origin.x = self.leftPadding;
            CGFloat tmpWidth = maxWidth - (self.leftPadding + self.rightPadding);
            CGFloat tmpHeight = maxHeight - (self.topPadding + imgHeight + imageTitleSpace + self.bottomPadding);
            if (tmpWidth > 0){
                titleRect.size.width = tmpWidth;
            }
            if (tmpHeight > 0){
                titleRect.size.height = tmpHeight;
            }
            self.titleLabel.frame = titleRect;

            //2.Image位置
            CGRect imageRect = self.imageView.frame;
            imageRect.size = self.imageView.image.size;
            imageRect.origin.y = imageTitleSpace + CGRectGetMaxY(titleRect);
            self.imageView.frame = imageRect;
            
            //Title 比 Image宽
            if (titleSize.width > imgSize.width) {
                CGPoint point = self.imageView.center;
                point.x = self.titleLabel.center.x;
                self.imageView.center = point;
                
            } else {//Image 比 Title宽
                imageRect.origin.x = self.leftPadding;
                self.imageView.frame = imageRect;
                
                titleRect.origin.x = 0;
                titleRect.size.width = maxWidth;
                self.titleLabel.frame = titleRect;
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
        }
            break;
            
        case WXImagePlacementTrailing: {
            //1.Title位置
            CGRect titleRect = self.titleLabel.frame;
            titleRect.origin.x = self.leftPadding;
            titleRect.origin.y = self.topPadding;
            CGFloat tmpWidth = maxWidth - (self.leftPadding + imageTitleSpace + imgWidth + self.rightPadding);
            CGFloat tmpHeight = maxHeight - (self.topPadding + self.bottomPadding);
            if (tmpWidth > 0){
                titleRect.size.width = tmpWidth;
            }
            if (tmpHeight > 0){
                titleRect.size.height = tmpHeight;
            }
            self.titleLabel.frame = titleRect;

            //2.Image位置
            CGRect imageRect = self.imageView.frame;
            imageRect.size = self.imageView.image.size;
            imageRect.origin.x = CGRectGetMaxX(titleRect) + imageTitleSpace;
            self.imageView.frame = imageRect;
            
            CGPoint point = self.imageView.center;
            point.y = self.titleLabel.center.y;
            self.imageView.center = point;
        }
            break;
        default:
            break;
    }
    //调试查看文本位置大小
#ifdef DEBUG
    //self.titleLabel.backgroundColor = [[UIColor systemPinkColor] colorWithAlphaComponent:0.5];
#endif
}

@end
