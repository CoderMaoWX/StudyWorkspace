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
@property (nonatomic) CGSize intrinsicSize;
@property(nonatomic, assign) BOOL hasSetLineSpacing;
@property(nonatomic, assign) BOOL hasSetLineBreakMode;
//适合打标的场景属性
@property(nonatomic, strong) UIColor *textBackgroundColor;
@property(nonatomic, assign) CGFloat textBgColorCornerRadius;
@property(nonatomic) UIEdgeInsets textBgColorInset;
//适合设置边框的场景属性
@property(nonatomic, strong) UIColor *textBorderColor;
@property(nonatomic, assign) CGFloat textBorderWidth;
@property(nonatomic, assign) CGFloat textBorderCornerRadius;
@property(nonatomic) UIEdgeInsets textBorderInset;
@end

@implementation WXLayoutView

//MARK: - Setter Method

///文本
- (void)setText:(NSString *)text {
    _attributedText = nil;
    _text = text;
    [self updateContent];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    [self needsUpdateTitleContent];
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    self.hasSetLineSpacing = YES;
    [self needsUpdateTitleContent];
}

///文本换行连接模式
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    _lineBreakMode = lineBreakMode;
    self.hasSetLineBreakMode = YES;
    [self needsUpdateTitleContent];
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

///富文本
- (void)setAttributedText:(NSAttributedString *)attributedText {
    _text = nil;
    _attributedText = attributedText;
    [self updateContent];
}

///图片
- (void)setImage:(UIImage *)image {
    _image = image;
    [self updateContent];
}

///下载图片URL
- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    [self downloadImage:imageURL completion:nil];
}

///简易版下载设置网络图片: 设置图片URL/placeholder/下载回调
- (void)setImageURL:(NSString *)imageURL
        placeholder:(UIImage *)placeholder
         completion:(UIImage *(^)(UIImage *))completion {
    self.image = placeholder;
    [self downloadImage:imageURL completion:completion];
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

///背景图片
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self needsUpdateBackgroundImage];
}

///上边距
- (void)setTopMargin:(CGFloat)topMargin {
    _topMargin = topMargin;
    [self refreshEdge:UIRectEdgeTop margin:topMargin];
}
///左边距
- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    [self refreshEdge:UIRectEdgeLeft margin:leftMargin];
}
///下边距
- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin;
    [self refreshEdge:UIRectEdgeBottom margin:bottomMargin];
}
///右边距
- (void)setRightMargin:(CGFloat)rightMargin {
    _rightMargin = rightMargin;
    [self refreshEdge:UIRectEdgeRight margin:rightMargin];
}

/// 更新外边距: (top/left/bottom/right)
- (void)refreshEdge:(UIRectEdge)directional
             margin:(CGFloat)margin {
    UIEdgeInsets insets = self.marginInset;
    switch (directional) {
    case UIRectEdgeTop: {
            insets.top = margin;
        }
        break;
    case UIRectEdgeLeft: {
            insets.left = margin;
        }
        break;
    case UIRectEdgeBottom: {
            insets.bottom = margin;
        }
        break;
    case UIRectEdgeRight: {
            insets.right = margin;
        }
        break;
    default:
        break;
    }
    self.marginInset = insets;
}

///外边距: (上,左,下,右)
- (void)setMarginInset:(UIEdgeInsets)marginInset {
    _marginInset = marginInset;
    _topMargin = marginInset.top;
    _leftMargin = marginInset.left;
    _bottomMargin = marginInset.bottom;
    _rightMargin = marginInset.right;
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

///绘制文本背景边框色/圆角 (类似于: 给文本打标的UI)
- (void)textBorderColor:(UIColor *)color
            borderWidth:(CGFloat)width
            borderInset:(UIEdgeInsets)inset
           cornerRadius:(CGFloat)radius {
    self.textBorderColor = color;
    self.textBorderWidth = width;
    self.textBorderInset = inset;
    self.textBorderCornerRadius = radius;
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

///简易版下载网络图片
- (void)downloadImage:(NSString *)imageURL
           completion:(UIImage *(^)(UIImage *))completion {
    
    NSURL *urlString = [NSURL URLWithString:imageURL];
    if (urlString) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:urlString];
            if (![imgData isKindOfClass:[NSData class]]) return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:imgData];
                if (completion) {
                    UIImage *clipImage = completion(image);
                    if (![clipImage isKindOfClass:[UIImage class]]) return;
                    self.image = clipImage;
                } else {
                    if (![image isKindOfClass:[UIImage class]]) return;
                    self.image = image;
                }
            });
        });
    }
}

//MARK: - 配置自适应大小

- (CGSize)calculateAttributedTextSize {
    
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
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = self.hasSetLineBreakMode ? self.lineBreakMode : NSLineBreakByTruncatingTail;
    if (self.hasSetLineSpacing){
        paragraphStyle.lineSpacing = MAX(self.lineSpacing, 0);
    }
    //系统大于等于11才设置行断字策略。
    if (systemVersion >= 11.0) {
        @try {
            [paragraphStyle setValue:@(1) forKey:@"lineBreakStrategy"];
        } @catch (NSException *exception) {}
    }
    
    NSAttributedString *attributedString = self.attributedText;
    
    if (!attributedString) {
        
        //如果不指定字体则用默认的字体。
        UIFont *textFont = self.font ? : [UIFont systemFontOfSize:17];
        NSMutableDictionary *attributesDict = [NSMutableDictionary dictionary];
        attributesDict[NSFontAttributeName] = textFont;
        attributesDict[NSParagraphStyleAttributeName] = paragraphStyle;
        attributesDict[NSForegroundColorAttributeName] = self.textColor ?: UIColor.blackColor;
        
        if ([text isKindOfClass:NSString.class]) {
            attributedString = [[NSAttributedString alloc] initWithString:text attributes:attributesDict];
        }
    } else {
//        NSAttributedString *originAttributedString = (NSAttributedString *)text;
//        //对于属性字符串总是加上默认的字体和段落信息。
//        NSMutableAttributedString *mutableCalcAttributedString = [[NSMutableAttributedString alloc] initWithString:originAttributedString.string attributes:attributesDict];
//
//        //再附加上原来的属性。
//        [originAttributedString enumerateAttributesInRange:NSMakeRange(0, originAttributedString.string.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
//            [mutableCalcAttributedString addAttributes:attrs range:range];
//        }];
        
        //这里再次取段落信息，因为有可能属性字符串中就已经包含了段落信息。
        if (systemVersion >= 11.0) {
            NSParagraphStyle *alternativeParagraphStyle = [attributedString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
            if (alternativeParagraphStyle != nil) {
                paragraphStyle = (NSMutableParagraphStyle *)alternativeParagraphStyle;
            }
        }
//        attributedString = mutableCalcAttributedString;
    }
    
    //限制最大宽度
    CGFloat maxLayoutWidth = self.bounds.size.width;
    
    if (self.bounds.size.width > 0) {
        if (self.preferredMaxLayoutWidth > 0) {
            maxLayoutWidth = MIN(self.bounds.size.width, self.preferredMaxLayoutWidth);
        }
    } else if (self.preferredMaxLayoutWidth > 0) {
        maxLayoutWidth = self.preferredMaxLayoutWidth;
    }
    
//    if (self.imagePlacement == WXImagePlacementLeading || self.imagePlacement == WXImagePlacementTrailing) {
//
//        //绘制背景色位置
//        UIEdgeInsets textInset = UIEdgeInsetsZero;
//        if (self.textBorderColor) {
//            textInset = self.textBorderInset;
//        }
//        if (self.textBackgroundColor) {
//            textInset = self.textBgColorInset;
//        }
//        CGFloat imgWidth = self.image.size.width;
//        BOOL hasTextAndImage = ((hasText || hasAttribText) && self.image);
//        CGFloat imageTextSpace = hasTextAndImage ? self.imageTextSpace : 0;
//        BOOL hasTextOrAttr = (hasText || hasAttribText); //是否为单一内容: 只有图片的场景
//        CGFloat textHMargin = hasTextOrAttr ? (textInset.left + textInset.right) : 0;
//        CGFloat otherSpace = self.leftMargin + imgWidth + textHMargin + imageTextSpace + self.rightMargin;
//
//        if (maxLayoutWidth > otherSpace) {
//            maxLayoutWidth -= otherSpace;
//
//        } else { //此场景为: 图片超过self的宽度
//            maxLayoutWidth = CGFLOAT_MAX;
//        }
//    }
    
    NSInteger numberOfLines = self.numberOfLines;
    
    //fitsSize 指定限制的尺寸，参考UILabel中的sizeThatFits中的参数的意义。
    CGSize fitsSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    fitsSize.width = maxLayoutWidth;
    
    //调整fitsSize的值, 这里的宽度调整为只要宽度小于等于0或者显示一行都不限制宽度，而高度则总是改为不限制高度。
    fitsSize.height = FLT_MAX;
    if (fitsSize.width <= 0 || numberOfLines == 1) {
        fitsSize.width = FLT_MAX;
    }
    
    //构造出一个换行模式的: NSStringDrawContext
    NSStringDrawingContext *context = [self getDrawingContext];
       
    //计算属性字符串的bounds值。
    CGRect textRect = [attributedString boundingRectWithSize:fitsSize options:NSStringDrawingUsesLineFragmentOrigin context:context];
    
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
            NSString *string = attributedString.string;
            NSCharacterSet *charset = [NSCharacterSet newlineCharacterSet];
            NSArray *lines = [string componentsSeparatedByCharactersInSet:charset]; //得到文本内容的行数
            NSString *lastLine = lines.lastObject;
            //有效的内容行数要减去最后一行为空行的情况。
            NSInteger numberOfContentLines = lines.count - (NSInteger)(lastLine.length == 0);

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
    
    self.drawRectAttributedString = attributedString;
    self.drawTextSize = textRect.size;
    return textRect.size;
}

///构造出一个换行模式的: NSStringDrawContext
- (NSStringDrawingContext *)getDrawingContext {
    NSInteger numberOfLines = self.numberOfLines;
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
    
    return context;
}

///更新布局大小
- (CGSize)intrinsicContentSize {
    
    BOOL hasText = (self.text && self.text.length != 0);
    BOOL hasAttribText = (self.attributedText && self.attributedText.string.length != 0);
    
    //空内容就返回: Zero
    if (!hasText && !hasAttribText && !self.image) {
        return CGSizeZero;
    }
    
    CGSize textSize = [self calculateAttributedTextSize];
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
    if (textWidth == 0 || textHeight == 0 || imgWidth == 0 || imgHeight == 0) {
        imageTextSpace = 0;
    }
    
    //绘制背景色位置
    UIEdgeInsets textInset = UIEdgeInsetsZero;
    if (self.textBorderColor) {
        textInset = self.textBorderInset;
    }
    if (self.textBackgroundColor) {
        textInset = self.textBgColorInset;
    }
    BOOL hasTextOrAttr = (hasText || hasAttribText); //是否为单一内容: 只有图片的场景
    CGFloat textHMargin = hasTextOrAttr ? (textInset.left + textInset.right) : 0;
    CGFloat textVMargin = hasTextOrAttr ? (textInset.top + textInset.bottom) : 0;
    
    textHeight += textVMargin;
    textWidth += textHMargin;

    //上下布局
    if (hasTextAndImage &&
        (self.imagePlacement == WXImagePlacementTop || self.imagePlacement == WXImagePlacementBottom)) {
        
        CGFloat width = self.leftMargin + MAX(textWidth, imgWidth) + self.rightMargin;
        CGFloat height = self.topMargin + textHeight + imageTextSpace + imgHeight + self.bottomMargin;
        self.intrinsicSize = CGSizeMake(ceilf(width), ceilf(height));
        
        NSLog(@"固有大小,上下布局: {宽, 高}=%@", NSStringFromCGSize(self.intrinsicSize));
        
    } else {//左右布局
        CGFloat width = self.leftMargin + textWidth + imageTextSpace + imgWidth + self.rightMargin;
        CGFloat height = self.topMargin + MAX(textHeight, imgHeight) + self.bottomMargin;
        self.intrinsicSize = CGSizeMake(ceilf(width), ceilf(height));
        
        NSLog(@"固有大小,左右布局: {宽, 高}==%@", NSStringFromCGSize(self.intrinsicSize));
    }
    return self.intrinsicSize;
}

//MARK: - 绘制控件内容

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSLog(@"绘制控件内容: {宽, 高}==%@", NSStringFromCGSize(rect.size));
    
    BOOL hasText = (self.text && self.text.length != 0);
    BOOL hasAttribText = (self.attributedText && self.attributedText.string.length != 0);
    
    //空内容就返回: Zero
    if (!hasText && !hasAttribText && !self.image) {
        return;
    }
    
    if (!CGSizeEqualToSize(rect.size, self.intrinsicSize) && self.preferredMaxLayoutWidth == 0) {
        NSLog(@"外部有约束自身控件大小: %@", NSStringFromCGRect(self.frame));
        /**
         * 外部有约束/宽高度, 但是没有设置preferredMaxLayoutWidth时,
         * 需要重新调用self.calculateAttributedTextSize方法,再获取一次文本布局限制最大宽度
         */
        [self calculateAttributedTextSize];
    }
    
    CGSize textSize = self.drawTextSize;
    CGSize imgSize = self.image.size;
    
    BOOL hasTextAndImage = ((hasText || hasAttribText) && self.image);
    CGFloat imageTextSpace = hasTextAndImage ? self.imageTextSpace : 0;
    if (textSize.width == 0 || textSize.height == 0 || imgSize.width == 0 || imgSize.height == 0) {
        imageTextSpace = 0;
    }
    
    //绘制背景色位置
    UIEdgeInsets textInset = UIEdgeInsetsZero;
    if (self.textBorderColor) {
        textInset = self.textBorderInset;
    }
    if (self.textBackgroundColor) {
        textInset = self.textBgColorInset;
    }
    BOOL hasTextOrAttr = (hasText || hasAttribText); //是否为单一内容: 只有图片的场景
    CGFloat textHMargin = hasTextOrAttr ? (textInset.left + textInset.right) : 0;
    CGFloat textVMargin = hasTextOrAttr ? (textInset.top + textInset.bottom) : 0;

    CGRect colorTextRect = CGRectZero;
    colorTextRect.size.width = MIN(rect.size.width, self.drawTextSize.width + textHMargin);
    colorTextRect.size.height = MIN(rect.size.height, self.drawTextSize.height + textVMargin);
    
    CGRect imageRect = CGRectZero;
    imageRect.size.width = MIN(rect.size.width, self.image.size.width);
    imageRect.size.height = MIN(rect.size.height, self.image.size.height);
    
    CGFloat imgWidth = imageRect.size.width;
    CGFloat imgHeight = imageRect.size.height;
    CGFloat colorTextWidth = colorTextRect.size.width;
    CGFloat colorTextHeight = colorTextRect.size.height;
    CGFloat absWidth = fabs( (colorTextWidth - imgWidth)/2.0 );
    CGFloat absHeight = fabs( (colorTextHeight - imgHeight)/2.0 );

    //是否居中模式显示
    BOOL shouldLayoutCenter = (self.textAlignment == NSTextAlignmentCenter || hasTextAndImage);
    CGFloat absWidthCenter = fabs( (rect.size.width - self.intrinsicSize.width)/2.0 );
    CGFloat absHeightCenter = fabs( (rect.size.height - self.intrinsicSize.height)/2.0 );
    
    switch (self.imagePlacement) {
    case WXImagePlacementTop: {
        
        //1.Image位置: 在上
        if (rect.size.height > self.intrinsicSize.height) {
            imageRect.origin.y = absHeightCenter;
        } else {
            imageRect.origin.y = self.topMargin;
        }
        
        //2.Title位置: 在下
        colorTextRect.origin.y = CGRectGetMaxY(imageRect) + imageTextSpace;
        
        //Image 比 Text 宽
        if (imgWidth > colorTextWidth) {
            imageRect.origin.x = self.leftMargin;
            colorTextRect.origin.x = imageRect.origin.x + absWidth;
            
        } else {
            colorTextRect.origin.x = self.leftMargin;
            imageRect.origin.x = colorTextRect.origin.x + absWidth;
        }
    }
        break;
        
    case WXImagePlacementLeading: {
        
        //1.Image位置: 在左
        if (shouldLayoutCenter && (rect.size.width > self.intrinsicSize.width)) {
            imageRect.origin.x = absWidthCenter;
        } else {
            imageRect.origin.x = self.leftMargin;
        }
        //2.Text位置: 在右
        colorTextRect.origin.x = CGRectGetMaxX(imageRect) + imageTextSpace;
        
        //Image 比 Text 高
        if (imgHeight > colorTextHeight) {
            imageRect.origin.y = self.topMargin;
            colorTextRect.origin.y = imageRect.origin.y + absHeight;
            
        } else {
            colorTextRect.origin.y = self.topMargin;
            imageRect.origin.y = colorTextRect.origin.y + absHeight;
        }
    }
        break;
        
    case WXImagePlacementBottom: {
        
        //1.Text位置: 在上
        if (rect.size.height > self.intrinsicSize.height) {
            colorTextRect.origin.y = absHeightCenter;
        } else {
            colorTextRect.origin.y = self.topMargin;
        }

        //2.Image位置: 在下
        imageRect.origin.y = CGRectGetMaxY(colorTextRect) + imageTextSpace;
        
        //Image 比 Text 宽
        if (imgWidth > colorTextWidth) {
            imageRect.origin.x = self.leftMargin;
            colorTextRect.origin.x = imageRect.origin.x + absWidth;
            
        } else {
            colorTextRect.origin.x = self.leftMargin;
            imageRect.origin.x = colorTextRect.origin.x + absWidth;
        }
    }
        break;
        
    case WXImagePlacementTrailing: {
        
        //1.Text位置: 在左
        if (shouldLayoutCenter && (rect.size.width > self.intrinsicSize.width)) {
            colorTextRect.origin.x = absWidthCenter;
        } else {
            colorTextRect.origin.x = self.leftMargin;
        }
        //1.Image位置: 在右
        imageRect.origin.x = CGRectGetMaxX(colorTextRect) + imageTextSpace;
        
        //Image 比 Text 高
        if (imgHeight > colorTextHeight) {
            imageRect.origin.y = self.topMargin;
            colorTextRect.origin.y = imageRect.origin.y + absHeight;
            
        } else {
            colorTextRect.origin.y = self.topMargin;
            imageRect.origin.y = colorTextRect.origin.y + absHeight;
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
    if(self.image && imageRect.size.width >0 && imageRect.size.height) {
        [self.image drawInRect:imageRect];
    }
    
    // 3.绘制文案
    if((hasText || hasAttribText) && colorTextRect.size.width >0 && colorTextRect.size.height) {
        //3.1 绘制文本 背景/圆角/边框
        [self drawTextBackgroundStyle:colorTextRect];
        
        //3.2 绘制文案
        CGRect drawTextRect = CGRectStandardize(colorTextRect);
        drawTextRect.origin.x = colorTextRect.origin.x + textInset.left;
        drawTextRect.origin.y = colorTextRect.origin.y + textInset.top;
        drawTextRect.size.width = colorTextRect.size.width - textHMargin;
        drawTextRect.size.height = colorTextRect.size.height - textVMargin;
        
        [self.drawRectAttributedString drawWithRect:drawTextRect
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                            context:[self getDrawingContext]];
    }
}

///绘制文本 背景/圆角/边框 (类似于: 给文本打标的UI)
- (void)drawTextBackgroundStyle:(CGRect)colorRect {
    UIColor *textBgColor = self.textBackgroundColor;
    UIColor *textBorderColor = self.textBorderColor;
    
    if (![textBgColor isKindOfClass:[UIColor class]] && ![textBorderColor isKindOfClass:[UIColor class]]) {
        return;
    }
    // 绘制背景/圆角
    CGFloat textRadius = 0;
    //绘制背景色位置
    UIEdgeInsets textInset = UIEdgeInsetsZero;
    
    if (self.textBorderColor) {
        textInset = self.textBorderInset;
        textRadius = MAX(0, self.textBorderCornerRadius);
    }
    if (self.textBackgroundColor) {
        textInset = self.textBgColorInset;
        textRadius = MAX(0, self.textBgColorCornerRadius);
    }
    
    float x1 = colorRect.origin.x;
    float y1 = colorRect.origin.y;
    float x2 = x1 + colorRect.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1 + colorRect.size.height;
    float x4 = x1;
    float y4 = y3;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制边框线条
    CGFloat lineSize = MAX(0, self.textBorderWidth);
    CGContextSetLineWidth(context, lineSize);
    CGContextSetStrokeColorWithColor(context, (textBorderColor ? : UIColor.clearColor).CGColor);
    
    // 绘制路径圆弧
    CGContextMoveToPoint(context,   x1, y1 + textRadius);
    CGContextAddArcToPoint(context, x1, y1, x1 + textRadius, y1, textRadius);
    CGContextAddArcToPoint(context, x2, y2, x2, y2 + textRadius, textRadius);
    CGContextAddArcToPoint(context, x3, y3, x3 - textRadius, y3, textRadius);
    CGContextAddArcToPoint(context, x4, y4, x4, y4 - textRadius, textRadius);
    CGContextAddLineToPoint(context, x1, y1 + textRadius - lineSize/2);//关闭路径,回到原点
    
    CGContextSetFillColorWithColor(context, (textBgColor ? : UIColor.clearColor).CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
