//
//  WXLayoutView.m
//  StudyWorkspace
//
//  Created by 610582 on 2022/9/23.
//  Copyright © 2022 MaoWX. All rights reserved.
//

#import "WXLayoutView.h"

@interface WXLayoutView ()
@property (nonatomic, strong) NSAttributedString *drawRectAttributedString;
@property (nonatomic) CGSize drawTextSize;
//适合打标的场景属性
@property(nonatomic, strong) UIColor *textBackgroundColor;
@property(nonatomic, assign) CGFloat textBgColorCornerRadius;
@property(nonatomic) UIEdgeInsets textBgColorInset;
@end

@implementation WXLayoutView


//MARK: - Setter Method

///文本
- (void)setText:(NSString *)text {
    _text = text;
    [self updateContent];
}

///富文本
- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    [self updateContent];
}

///文本字体
- (void)setFont:(UIFont *)font {
    _font = font;
    [self needsUpdateTitleContent];
}

///文本颜色
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self needsUpdateTitleContent];
}

///换行显示行数
- (void)setNumberOfLines:(NSInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    [self needsUpdateTitleContent];
}

///最大换行宽度
- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    [self needsUpdateTitleContent];
}

///文本换行连接模式
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    _lineBreakMode = lineBreakMode;
    [self needsUpdateTitleContent];
}

///文本和图片布局位置
- (void)setImagePlacement:(WXImagePlacementStyle)imagePlacement {
    _imagePlacement = imagePlacement;
    [self needsUpdateAllContent];
}

///文本和图片的间距
- (void)setImageTextSpace:(CGFloat)imageTextSpace {
    _imageTextSpace = imageTextSpace;
    [self needsUpdateAllContent];
}

///图片
- (void)setImage:(UIImage *)image {
    _image = image;
    [self updateContent];
}

///下载图片URL
- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    
    NSURL *urlString = [NSURL URLWithString:imageURL];
    if (urlString) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:urlString];
            if (![imgData isKindOfClass:[NSData class]]) return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:imgData];
                if (![image isKindOfClass:[UIImage class]]) return;
                self.image = image;
            });
        });
    } else {
        self.image = nil;
    }
}

///背景图片
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self needsUpdateBackgroundImage];
}

///上边距
- (void)setTopPadding:(CGFloat)topPadding {
    _topPadding = topPadding;
    [self refreshEdge:UIRectEdgeTop padding:topPadding];
}
///左边距
- (void)setLeftPadding:(CGFloat)leftPadding {
    _leftPadding = leftPadding;
    [self refreshEdge:UIRectEdgeLeft padding:leftPadding];
}
///下边距
- (void)setBottomPadding:(CGFloat)bottomPadding {
    _bottomPadding = bottomPadding;
    [self refreshEdge:UIRectEdgeBottom padding:bottomPadding];
}
///右边距
- (void)setRightPadding:(CGFloat)rightPadding {
    _rightPadding = rightPadding;
    [self refreshEdge:UIRectEdgeRight padding:rightPadding];
}

/// 更新内边距: (top/left/bottom/right)
- (void)refreshEdge:(UIRectEdge)directional
            padding:(CGFloat)padding {
    UIEdgeInsets insets = self.paddingInset;
    switch (directional) {
    case UIRectEdgeTop: {
            _topPadding = padding;
            insets.top = padding;
        }
        break;
    case UIRectEdgeLeft: {
            _leftPadding = padding;
            insets.left = padding;
        }
        break;
    case UIRectEdgeBottom: {
            _bottomPadding = padding;
            insets.bottom = padding;
        }
        break;
    case UIRectEdgeRight: {
            _rightPadding = padding;
            insets.right = padding;
        }
        break;
    default:
        break;
    }
    self.paddingInset = insets;
}

///内边距: (上,左,下,右)
- (void)setPaddingInset:(UIEdgeInsets)paddingInset {
    _paddingInset = paddingInset;
    _topPadding = paddingInset.top;
    _leftPadding = paddingInset.left;
    _bottomPadding = paddingInset.bottom;
    _rightPadding = paddingInset.right;
    [self needsUpdateBackgroundImage];
}

///绘制文本背景色/圆角 (类似于: 给文本打标的UI)
- (void)textBackgroundColor:(UIColor *)color
                 colorInset:(UIEdgeInsets)inset
               cornerRadius:(CGFloat)radius {
    self.textBackgroundColor = color;
    self.textBgColorCornerRadius = radius;
    self.textBgColorInset = inset;
    [self needsUpdateTitleContent];
}

//MARK: - 私有方法

- (void)needsUpdateTitleContent {
    self.text ? [self updateContent] : nil;
}

- (void)needsUpdateBackgroundImage {
    (self.text || self.image) ? [self updateContent] : nil;
}

- (void)needsUpdateAllContent {
    (self.text && self.image) ? [self updateContent] : nil;
}

- (void)updateContent {
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

//MARK: - 配置自适应大小

- (CGSize)configAttributedStringSize {
    
    NSString *text = self.text;
    BOOL hasText = (self.text && self.text.length != 0);
    BOOL hasAttribText = (self.attributedText && self.attributedText.string.length != 0);
    
    //空内容就返回: Zero
    if (!hasText && !hasAttribText) {
        self.drawRectAttributedString = nil;
        self.drawTextSize = CGSizeZero;
        return CGSizeZero;
    }
    
    CGFloat systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    //系统大于等于11才设置行断字策略。
    if (systemVersion >= 11.0) {
        @try {
            [paragraphStyle setValue:@(1) forKey:@"lineBreakStrategy"];
        } @catch (NSException *exception) {}
    }
    
    NSAttributedString *calcAttributedString = self.attributedText;
    if (!calcAttributedString) {
        
        //如果不指定字体则用默认的字体。
        UIFont *textFont = self.font;
        if (textFont == nil) {
            textFont = [UIFont systemFontOfSize:17];
        }

        NSMutableDictionary *attributesDict = [NSMutableDictionary dictionary];
        attributesDict[NSFontAttributeName] = textFont;
        attributesDict[NSParagraphStyleAttributeName] = paragraphStyle;
        attributesDict[NSForegroundColorAttributeName] = self.textColor ?: UIColor.blackColor;
        
        if ([text isKindOfClass:NSString.class]) {
            calcAttributedString = [[NSAttributedString alloc] initWithString:(NSString *)text attributes:attributesDict];
        } else {
            NSAttributedString *originAttributedString = (NSAttributedString *)text;
            //对于属性字符串总是加上默认的字体和段落信息。
            NSMutableAttributedString *mutableCalcAttributedString = [[NSMutableAttributedString alloc] initWithString:originAttributedString.string attributes:attributesDict];
            
            //再附加上原来的属性。
            [originAttributedString enumerateAttributesInRange:NSMakeRange(0, originAttributedString.string.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
                [mutableCalcAttributedString addAttributes:attrs range:range];
            }];
            
            //这里再次取段落信息，因为有可能属性字符串中就已经包含了段落信息。
            if (systemVersion >= 11.0) {
                NSParagraphStyle *alternativeParagraphStyle = [mutableCalcAttributedString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
                if (alternativeParagraphStyle != nil) {
                    paragraphStyle = (NSMutableParagraphStyle*)alternativeParagraphStyle;
                }
            }
            calcAttributedString = mutableCalcAttributedString;
        }
    }
    
    NSInteger numberOfLines = self.numberOfLines;
    
    //fitsSize 指定限制的尺寸，参考UILabel中的sizeThatFits中的参数的意义。
    CGSize fitsSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    //限制最大宽度
    if (self.preferredMaxLayoutWidth > 0) {
        fitsSize.width = self.preferredMaxLayoutWidth;
    }
    //调整fitsSize的值, 这里的宽度调整为只要宽度小于等于0或者显示一行都不限制宽度，而高度则总是改为不限制高度。
    fitsSize.height = FLT_MAX;
    if (fitsSize.width <= 0 || numberOfLines == 1) {
        fitsSize.width = FLT_MAX;
    }
        
    //构造出一个NSStringDrawContext
    CGFloat minimumScaleFactor = 0.0;
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = minimumScaleFactor;
    @try {
        //因为下面几个属性都是未公开的属性，所以我们用KVC的方式来实现。
        [context setValue:@(numberOfLines) forKey:@"maximumNumberOfLines"];
        if (numberOfLines != 1) {
            [context setValue:@(YES) forKey:@"wrapsForTruncationMode"];
        }
        [context setValue:@(YES) forKey:@"wantsNumberOfLineFragments"];
    } @catch (NSException *exception) {}
       
    //计算属性字符串的bounds值。
    CGRect textRect = [calcAttributedString boundingRectWithSize:fitsSize options:NSStringDrawingUsesLineFragmentOrigin context:context];
    
    //需要对段落的首行缩进进行特殊处理！
    //如果只有一行则直接添加首行缩进的值，否则进行特殊处理。。
    CGFloat firstLineHeadIndent = paragraphStyle.firstLineHeadIndent;
    if (firstLineHeadIndent != 0.0 && systemVersion >= 11.0) {
        //得到绘制出来的行数
        NSInteger numberOfDrawingLines = [[context valueForKey:@"numberOfLineFragments"] integerValue];
        if (numberOfDrawingLines == 1) {
            textRect.size.width += firstLineHeadIndent;
        } else {
            //取内容的行数。
            NSString *string = calcAttributedString.string;
            NSCharacterSet *charset = [NSCharacterSet newlineCharacterSet];
            NSArray *lines = [string componentsSeparatedByCharactersInSet:charset]; //得到文本内容的行数
            NSString *lastLine = lines.lastObject;
            NSInteger numberOfContentLines = lines.count - (NSInteger)(lastLine.length == 0);  //有效的内容行数要减去最后一行为空行的情况。
            
            if (numberOfLines == 0) {
                numberOfLines = NSIntegerMax;
            }
            if (numberOfLines > numberOfContentLines) {
                numberOfLines = numberOfContentLines;
            }
            //只有绘制的行数和指定的行数相等时才添加上首行缩进！这段代码根据反汇编来实现，但是不理解为什么相等才设置？
            if (numberOfDrawingLines == numberOfLines) {
                textRect.size.width += firstLineHeadIndent;
            }
        }
    }
    
    //取fitsSize和rect中的最小宽度值。
    if (textRect.size.width > fitsSize.width) {
        textRect.size.width = fitsSize.width;
    }
    
    CGSize shadowOffset = CGSizeZero;//默认阴影偏移
    //加上阴影的偏移
    textRect.size.width += fabs(shadowOffset.width);
    textRect.size.height += fabs(shadowOffset.height);
       
    //转化为可以有效显示的逻辑点, 这里将原始逻辑点乘以缩放比例得到物理像素点，然后再取整，然后再除以缩放比例得到可以有效显示的逻辑点。
    CGFloat scale = [UIScreen mainScreen].scale;
    textRect.size.width = ceil(textRect.size.width * scale) / scale;
    textRect.size.height = ceil(textRect.size.height *scale) / scale;
    
    self.drawRectAttributedString = calcAttributedString;
    self.drawTextSize = textRect.size;
    return textRect.size;
}

///更新布局大小
- (CGSize)intrinsicContentSize {
    
    BOOL hasText = (self.text && self.text.length != 0);
    BOOL hasAttribText = (self.attributedText && self.attributedText.string.length != 0);
    
    //空内容就返回: Zero
    if (!hasText && !hasAttribText && !self.image) {
        return CGSizeZero;
    }
    
    CGSize textSize = [self configAttributedStringSize];
    CGFloat textWidth = 0.0;
    CGFloat textHeight = 0.0;
    if (textSize.width > 0 && textSize.height > 0) {
        textHeight = textSize.height;
        textWidth = textSize.width;
    }
    
    CGSize imgSize = self.image.size;
    CGFloat imgWidth = 0.0;
    CGFloat imgHeight = 0.0;
    if (imgSize.width > 0 && imgSize.height > 0) {
        imgWidth = imgSize.width;
        imgHeight = imgSize.height;
    }
    
    BOOL hasTextAndImage = ((hasText || hasAttribText) && self.image);
    CGFloat imageTextSpace = hasTextAndImage ? self.imageTextSpace : 0;
    BOOL singContent = NO;
    if (textWidth == 0 || textHeight == 0 || imgWidth == 0 || imgHeight == 0) {
        imageTextSpace = 0;
        singContent = YES;
    }
    
    CGFloat textColorHMargin = singContent ? 0 : (self.textBgColorInset.left + self.textBgColorInset.right);
    CGFloat textColorVMargin = singContent ? 0 : (self.textBgColorInset.top + self.textBgColorInset.bottom);
    
    textHeight += textColorVMargin;
    textWidth += textColorHMargin;

    //上下布局
    if (hasTextAndImage &&
        (self.imagePlacement == WXImagePlacementTop || self.imagePlacement == WXImagePlacementBottom)) {
        
        CGFloat width = self.leftPadding + MAX(textWidth, imgWidth) + self.rightPadding;
        CGFloat height = self.topPadding + textHeight + imageTextSpace + imgHeight + self.bottomPadding;
        
        NSLog(@"固有大小 上下布局: 宽: %.2f, 高:%.2f", width, height);
        return CGSizeMake(width, height);
        
    } else {//左右布局
        CGFloat width = self.leftPadding + textWidth + imageTextSpace + imgWidth + self.rightPadding;
        CGFloat height = self.topPadding + MAX(textHeight, imgHeight) + self.bottomPadding;
        
        NSLog(@"固有大小 左右布局: 宽: %.2f, 高:%.2f", width, height);
        return CGSizeMake(width, height);
    }
}

//MARK: - 绘制控件内容

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSLog(@"绘制控件内容: 宽: %.2f, 高:%.2f", rect.size.width, rect.size.height);
    
    BOOL hasText = (self.text && self.text.length != 0);
    BOOL hasAttribText = (self.attributedText && self.attributedText.string.length != 0);
    
    //空内容就返回: Zero
    if (!hasText && !hasAttribText && !self.image) {
        return;
    }
    
    CGSize textSize = self.drawTextSize;
    CGSize imgSize = self.image.size;
    
    BOOL singContent = NO;
    BOOL hasTextAndImage = ((hasText || hasAttribText) && self.image);
    CGFloat imageTextSpace = hasTextAndImage ? self.imageTextSpace : 0;
    if (textSize.width == 0 || textSize.height == 0 || imgSize.width == 0 || imgSize.height == 0) {
        imageTextSpace = 0;
        singContent = YES;
    }
    
    CGFloat textBgColorTop = singContent ? 0 : self.textBgColorInset.top;
    CGFloat textBgColorLeft = singContent ? 0 : self.textBgColorInset.left;
    CGFloat textBgColorBottom = singContent ? 0 : self.textBgColorInset.bottom;
    CGFloat textBgColorRight = singContent ? 0 : self.textBgColorInset.right;
    CGFloat textColorHMargin = textBgColorLeft + textBgColorRight;
    CGFloat textColorVMargin = textBgColorTop + textBgColorBottom;
    
    CGFloat horizontalMargin = self.leftPadding + self.rightPadding + textColorHMargin;
    CGFloat verticalMargin = self.topPadding + self.bottomPadding + textColorVMargin;

    CGRect imageRect = CGRectZero;
    imageRect.size = self.image.size;
    
    CGRect textRect = CGRectZero;
    textRect.size = self.drawTextSize;
    
    CGFloat textContentW = textRect.size.width + textColorHMargin;
    CGFloat textContentH = textRect.size.height + textColorVMargin;
    
    switch (self.imagePlacement) {
    case WXImagePlacementTop: {
        
        //1.Image位置: 在上
        imageRect.origin.x = self.leftPadding;
        imageRect.origin.y = self.topPadding + textBgColorTop;
        
        //2.Title位置: 在下
        textRect.origin.x = self.leftPadding;
        textRect.origin.y = CGRectGetMaxY(imageRect) + textBgColorBottom + imageTextSpace;

        //Image 比 Text宽
        if (imageRect.size.width > textContentW) {
            textRect.origin.x = (imageRect.size.width + horizontalMargin - textContentW) / 2;

        } else {//Text 比 Image宽
            imageRect.origin.x = (textContentW + horizontalMargin - imageRect.size.width) / 2;
        }
    }
        break;
        
    case WXImagePlacementLeading: {
        
        //1.Image位置: 在左
        imageRect.origin.x = self.leftPadding + textBgColorLeft;
        imageRect.origin.y = self.topPadding;
        
        //2.Text位置: 在右
        textRect.origin.x = CGRectGetMaxX(imageRect) + textBgColorRight + imageTextSpace;
        textRect.origin.y = self.topPadding;
        
        //Image 比 Text高
        if (imageRect.size.height > textContentH) {
            textRect.origin.y = (imageRect.size.height + verticalMargin - textContentH) / 2;

        } else {//Text 比 Image高
            imageRect.origin.y = (textContentH + verticalMargin - imageRect.size.width) / 2;
        }
    }
        break;
        
    case WXImagePlacementBottom: {
        
        //1.Text位置: 在上
        textRect.origin.x = self.leftPadding;
        textRect.origin.y = self.topPadding + textBgColorTop;
        
        //2.Image位置: 在下
        imageRect.origin.x = self.leftPadding;
        imageRect.origin.y = CGRectGetMaxY(textRect) + textBgColorBottom + imageTextSpace;;
        
        //Text 比 Image宽
        if (textContentW > imageRect.size.width) {
            imageRect.origin.x = (textContentW + horizontalMargin - imageRect.size.width) / 2;

        } else {//Image 比 Text宽
            textRect.origin.x = (imageRect.size.width + horizontalMargin - textContentW) / 2;
        }
    }
        break;
        
    case WXImagePlacementTrailing: {
        
        //1.Text位置: 在左
        textRect.origin.x = self.leftPadding + textBgColorLeft;
        textRect.origin.y = self.topPadding;
        
        //1.Image位置: 在右
        imageRect.origin.x = CGRectGetMaxX(textRect) + textBgColorRight + imageTextSpace;
        imageRect.origin.y = self.topPadding;
        
        //Text 比 Image高
        if (textContentH > imageRect.size.height) {
            imageRect.origin.y = (textContentH + verticalMargin - imageRect.size.height) / 2;

        } else {//Image 比 Text高
            textRect.origin.y = (imageRect.size.height + verticalMargin - textContentH) / 2;
        }
    }
        break;
    default:
        break;
    }
    /** 提示: 一定要顺序绘制 */
    
    // 1.绘制背景图片
    if(self.backgroundImage && !CGRectEqualToRect(rect, CGRectZero)) {
        [self.backgroundImage drawInRect:rect];
    }
    // 2.绘制图片
    if(self.image && !CGRectEqualToRect(imageRect, CGRectZero)) {
        [self.image drawInRect:imageRect];
    }
    // 3.绘制文案
    if(hasText && !CGRectEqualToRect(textRect, CGRectZero)) {
        //3.1绘制文本背景色/圆角
        [self drawTextBackgroundStyle:textRect];
        //3.2绘制文案
        [self.drawRectAttributedString drawInRect:textRect];
    }
}

///绘制文本背景色/圆角 (类似于: 给文本打标的UI)
- (void)drawTextBackgroundStyle:(CGRect)textRect {
    
    CGFloat radius = MAX(0, self.textBgColorCornerRadius);
    UIColor *color = self.textBackgroundColor;
    if (![color isKindOfClass:[UIColor class]]) return;
    UIEdgeInsets inset = self.textBgColorInset;
    
    //绘制背景色位置
    CGRect colorRect = CGRectStandardize(textRect);
    colorRect.origin.x = textRect.origin.x - inset.left;
    colorRect.origin.y = textRect.origin.y - inset.top;
    colorRect.size.width = inset.left + textRect.size.width + inset.right;
    colorRect.size.height =  inset.top + textRect.size.height + inset.bottom;
    
    float x1 = colorRect.origin.x;
    float y1 = colorRect.origin.y;
    float x2 = x1 + colorRect.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1 + colorRect.size.height;
    float x4 = x1;
    float y4 = y3;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context,   x1, y1 + radius);
    CGContextAddArcToPoint(context, x1, y1, x1 + radius, y1, radius);
    CGContextAddArcToPoint(context, x2, y2, x2, y2 + radius, radius);
    CGContextAddArcToPoint(context, x3, y3, x3 - radius, y3, radius);
    CGContextAddArcToPoint(context, x4, y4, x4, y4 - radius, radius);
    
//    [[UIColor blueColor] setStroke];
//    CGContextStrokePath(context);
    
    //CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor);
    [color set];
    CGContextFillPath(context);
    
}



//MARK: - Getter Method

@end
