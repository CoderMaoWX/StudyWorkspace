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
@end

@implementation WXLayoutView


//MARK: - Setter Method

///文本
- (void)setText:(NSString *)text {
    _text = text;
    [self needsUpdateTitleContent];
}

///富文本
- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
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
    [self needsUpdateImageContent];
}

///背景图片
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self needsUpdateAllContent];
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
    self.paddingInset = insets;
}

///内边距: (上,左,下,右)
- (void)setPaddingInset:(UIEdgeInsets)paddingInset {
    _paddingInset = paddingInset;
    if (self.text || self.image){
        [self updateContent];
    }
}

//MARK: - 私有方法

- (void)needsUpdateTitleContent {
    self.text ? [self updateContent] : nil;
}

- (void)needsUpdateImageContent {
    self.image ? [self updateContent] : nil;
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
    if (text == nil || [text length] <= 0) {
        return CGSizeZero;
    }
    
    //如果不指定字体则用默认的字体。
    UIFont *textFont = self.font;
    if (textFont == nil) {
        textFont = [UIFont systemFontOfSize:17];
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

    NSMutableDictionary *attributesDict = [NSMutableDictionary dictionary];
    attributesDict[NSFontAttributeName] = textFont;
    attributesDict[NSParagraphStyleAttributeName] = paragraphStyle;
    attributesDict[NSForegroundColorAttributeName] = self.textColor ?: UIColor.blackColor;
    
    NSAttributedString *calcAttributedString = self.attributedText;
    
    if (!calcAttributedString) {
        
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
    CGSize fitsSize = self.bounds.size;
    
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
//    // 强制更新布局，以获得最新的 imageView 和 titleLabel 的 frame
//    [self layoutIfNeeded];
    
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
    if (textWidth == 0 || textHeight == 0 || imgWidth == 0 || imgHeight == 0) {
        imageTextSpace = 0;
    }
    
    //上下布局
    if (hasTextAndImage &&
        (self.imagePlacement == WXImagePlacementTop || self.imagePlacement == WXImagePlacementBottom)) {
        
        CGFloat width = self.leftPadding + MAX(textWidth, imgWidth) + self.rightPadding;
        CGFloat height = self.topPadding + textHeight + imageTextSpace + imgHeight + self.bottomPadding;
        
        //NSLog(@"固有大小 上下布局: 宽: %.2f, 高:%.2f", width, height);
        return CGSizeMake(width, height);
        
    } else {//左右布局
        CGFloat width = self.leftPadding + textWidth + imageTextSpace + imgWidth + self.rightPadding;
        CGFloat height = self.topPadding + MAX(textHeight, imgHeight) + self.bottomPadding;
        
        //NSLog(@"固有大小 左右布局: 宽: %.2f, 高:%.2f", width, height);
        return CGSizeMake(width, height);
    }
}

//MARK: - 绘制控件内容

- (void)drawRect:(CGRect)rect {
    CGRect textRect = CGRectStandardize(rect);
    textRect.size = self.drawTextSize;
    textRect.origin.x = 10;
    textRect.origin.y = 20;
    
    //绘制文案
    [self.drawRectAttributedString drawInRect:textRect];
    
    switch (self.imagePlacement) {
    case WXImagePlacementTop: {
        
    }
        break;
        
    case WXImagePlacementLeading: {
        
    }
        break;
        
    case WXImagePlacementBottom: {
        
    }
        break;
        
    case WXImagePlacementTrailing: {
        
    }
        break;
    default:
        break;
    }
    
}


//MARK: - Getter Method

@end
