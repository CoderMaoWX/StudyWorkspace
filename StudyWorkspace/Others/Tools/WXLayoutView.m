//
//  WXLayoutView.m
//  StudyWorkspace
//
//  Created by 610582 on 2022/9/23.
//  Copyright © 2022 MaoWX. All rights reserved.
//

#import "WXLayoutView.h"

@interface WXLayoutView ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation WXLayoutView

//MARK: - 初始化布局

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubViews];
    }
    return self;
}

- (void)_initSubViews {
}

//MARK: - Setter Method

///文本
- (void)setText:(NSString *)text {
    _text = text;
    self.titleLabel.attributedText = nil;
    self.titleLabel.text = text;
    if (!self.titleLabel.superview){
        [self addSubview:self.titleLabel];
    }
    [self needsUpdateTitleContentSize];
}

///富文本
- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    _attributedTitle = attributedTitle;
    self.titleLabel.text = nil;
    self.titleLabel.attributedText = attributedTitle;
    if (!self.titleLabel.superview){
        [self addSubview:self.titleLabel];
    }
    [self needsUpdateTitleContentSize];
}

///文本字体
- (void)setFont:(UIFont *)titleFont {
    _font = titleFont;
    self.titleLabel.font = titleFont;
    [self needsUpdateTitleContentSize];
}

///文本颜色
- (void)setTextColor:(UIColor *)titleColor {
    _textColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

///换行显示行数
- (void)setNumberOfLines:(NSInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    self.titleLabel.numberOfLines = numberOfLines;
    [self needsUpdateTitleContentSize];
}

///最大换行宽度
- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    self.titleLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    [self needsUpdateTitleContentSize];
}

///文本换行连接模式
- (void)setTextLineBreakMode:(NSLineBreakMode)textLineBreakMode {
    _textLineBreakMode = textLineBreakMode;
    self.titleLabel.lineBreakMode = textLineBreakMode;
    [self needsUpdateTitleContentSize];
}

///图片和文本布局位置
- (void)setImagePlacement:(WXImagePlacementStyle)imagePlacement {
    _imagePlacement = imagePlacement;
    if (self.titleLabel.superview && self.imageView.superview){
        [self invalidateIntrinsicContentSize];
    }
}

///图片和文本的间距
- (void)setImageTitleSpace:(CGFloat)imageTitleSpace {
    _imageTitleSpace = imageTitleSpace;
    if (self.titleLabel.superview && self.imageView.superview){
        [self invalidateIntrinsicContentSize];
    }
}

///图片
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
    if (!self.imageView.superview){
        [self addSubview:self.imageView];
    }
    [self needsUpdateImageContentSize];
}

///背景图片
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
    if (!self.backgroundImageView.superview){
        [self addSubview:self.backgroundImageView];
    }
//    [self invalidateIntrinsicContentSize]
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
    if (self.titleLabel.superview || self.imageView.superview){
        [self invalidateIntrinsicContentSize];
    }
}

//MARK: - 私有方法

- (BOOL)needsUpdateTitleContentSize {
    if (self.titleLabel.superview) {
        [self invalidateIntrinsicContentSize];
        return YES;
    }
    return NO;
}

- (BOOL)needsUpdateImageContentSize {
    if (self.imageView.superview) {
        [self invalidateIntrinsicContentSize];
        return YES;
    }
    return NO;
}

//MARK: - 配置自适应大小

- (CGSize)intrinsicContentSize {
    // 强制更新布局，以获得最新的 imageView 和 titleLabel 的 frame
//    [self layoutIfNeeded];
    
    BOOL hasTitle = (self.text && self.text.length != 0);
    BOOL hasAttribTitle = (self.attributedTitle && self.attributedTitle.string.length != 0);
    BOOL hasImage = (self.image && !CGSizeEqualToSize(self.image.size, CGSizeZero));

    //空内容就返回: Zero
    if (!hasTitle && !hasAttribTitle && !hasImage) {
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

    BOOL hasTitleAndImage = ((hasTitle || hasAttribTitle) && hasImage);
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
    return CGSizeZero;
}

/// 使用此方法时请标明源作者：欧阳大哥2013。本方法符合MIT协议规范。
/// github地址：https://github.com/youngsoft
/// 计算简单文本或者属性字符串的自适应尺寸
/// @param fitsSize 指定限制的尺寸，参考UILabel中的sizeThatFits中的参数的意义。
/// @param text 要计算的简单文本NSString或者属性字符串NSAttributedString对象
/// @param numberOfLines 指定最大显示的行数，如果为0则表示不限制最大行数
/// @param font 指定计算时文本的字体，可以为nil表示使用UILabel控件的默认17号字体
/// @param textAlignment 指定文本对齐方式默认是NSTextAlignmentNatural
/// @param lineBreakMode 指定多行时断字模式，默认可以用UILabel的默认断字模式NSLineBreakByTruncatingTail
/// @param minimumScaleFactor 指定文本的最小缩放因子，默认填写0。这个参数用于那些定宽时可以自动缩小文字字体来自适应显示的场景。
/// @param shadowOffset 指定阴影的偏移位置，需要注意的是这个偏移位置是同时指定了阴影颜色和偏移位置才有效。如果不考虑阴影则请传递CGSizeZero，否则阴影会参与尺寸计算。
/// @return 返回自适应的最合适尺寸
CGSize calcTextSize(CGSize fitsSize, id text, NSInteger numberOfLines, UIFont *font, NSTextAlignment textAlignment, NSLineBreakMode lineBreakMode, CGFloat minimumScaleFactor, CGSize shadowOffset) {
    
    if (text == nil || [text length] <= 0) {
        return CGSizeZero;
    }
    
    NSAttributedString *calcAttributedString = nil;

    //如果不指定字体则用默认的字体。
    if (font == nil) {
        font = [UIFont systemFontOfSize:17];
    }
    
    CGFloat systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
        
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = textAlignment;
    paragraphStyle.lineBreakMode = lineBreakMode;
    //系统大于等于11才设置行断字策略。
    if (systemVersion >= 11.0) {
        @try {
            [paragraphStyle setValue:@(1) forKey:@"lineBreakStrategy"];
        } @catch (NSException *exception) {}
    }
        
    if ([text isKindOfClass:NSString.class]) {
        calcAttributedString = [[NSAttributedString alloc] initWithString:(NSString *)text attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
    } else {
        NSAttributedString *originAttributedString = (NSAttributedString *)text;
        //对于属性字符串总是加上默认的字体和段落信息。
        NSMutableAttributedString *mutableCalcAttributedString = [[NSMutableAttributedString alloc] initWithString:originAttributedString.string attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
        
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
    
    //调整fitsSize的值, 这里的宽度调整为只要宽度小于等于0或者显示一行都不限制宽度，而高度则总是改为不限制高度。
    fitsSize.height = FLT_MAX;
    if (fitsSize.width <= 0 || numberOfLines == 1) {
        fitsSize.width = FLT_MAX;
    }
        
    //构造出一个NSStringDrawContext
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
    CGRect rect = [calcAttributedString boundingRectWithSize:fitsSize options:NSStringDrawingUsesLineFragmentOrigin context:context];
    
    //需要对段落的首行缩进进行特殊处理！
    //如果只有一行则直接添加首行缩进的值，否则进行特殊处理。。
    CGFloat firstLineHeadIndent = paragraphStyle.firstLineHeadIndent;
    if (firstLineHeadIndent != 0.0 && systemVersion >= 11.0) {
        //得到绘制出来的行数
        NSInteger numberOfDrawingLines = [[context valueForKey:@"numberOfLineFragments"] integerValue];
        if (numberOfDrawingLines == 1) {
            rect.size.width += firstLineHeadIndent;
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
            if (numberOfLines > numberOfContentLines)
                numberOfLines = numberOfContentLines;
            
            //只有绘制的行数和指定的行数相等时才添加上首行缩进！这段代码根据反汇编来实现，但是不理解为什么相等才设置？
            if (numberOfDrawingLines == numberOfLines) {
                rect.size.width += firstLineHeadIndent;
            }
        }
    }
    
    //取fitsSize和rect中的最小宽度值。
    if (rect.size.width > fitsSize.width) {
        rect.size.width = fitsSize.width;
    }
    
    //加上阴影的偏移
    rect.size.width += fabs(shadowOffset.width);
    rect.size.height += fabs(shadowOffset.height);
       
    //转化为可以有效显示的逻辑点, 这里将原始逻辑点乘以缩放比例得到物理像素点，然后再取整，然后再除以缩放比例得到可以有效显示的逻辑点。
    CGFloat scale = [UIScreen mainScreen].scale;
    rect.size.width = ceil(rect.size.width * scale) / scale;
    rect.size.height = ceil(rect.size.height *scale) / scale;
    
    return rect.size;
}

//上述方法的精简版本
NS_INLINE CGSize calcTextSizeV2(CGSize fitsSize, id text, NSInteger numberOfLines, UIFont *font) {
    return calcTextSize(fitsSize, text, numberOfLines, font, NSTextAlignmentNatural, NSLineBreakByTruncatingTail,0.0, CGSizeZero);
}

//MARK: - 绘制控件内容

- (void)drawRect:(CGRect)rect {

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置字符间距
    CGContextSetCharacterSpacing(ctx, 4);
    //设置填充颜色
    CGContextSetRGBFillColor(ctx, 1, 0, 1, 1);
    //设置线条颜色
    CGContextSetRGBStrokeColor(ctx, 0, 0, 1, 1);
    //设置使用填充模式绘制文字
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    //绘制文字
    [self.text drawAtPoint:CGPointMake(10, 20) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial Rounded MT Bold" size:45], NSFontAttributeName,[UIColor magentaColor],NSForegroundColorAttributeName, nil]];
}

//MARK: - Getter Method

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = self.backgroundColor;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = self.backgroundColor;
        _titleLabel.textColor = UIColor.blackColor;
    }
    return _titleLabel;
}
@end
