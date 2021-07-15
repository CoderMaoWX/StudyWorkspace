//
//  UIButton+WXExtension.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "UIButton+WXExtension.h"
#import "WXPublicHeader.h"
#import <objc/runtime.h>
#import "UIImage+Extension.h"

static const void *WXButtonBlockKey = &WXButtonBlockKey;

@implementation UIButton (WXExtension)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setEnlargeEdge:(CGFloat) size
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect {
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}

/**
 设置按钮右上角BageValue (目前统一针对购物车按钮数字)
 
 @param numberValue 大于100显示99, 等于0不显示
 */
- (void)showShoppingCarsBageValue:(NSInteger)numberValue
{
    [self showShoppingCarsBageValue:numberValue
                        bageBgColor:WX_ColorHex(0xFE5269)
                      bageTextColor:WX_ColorWhite()
                    bageBorderWidth:0
                    bageBorderColor:WX_ColorHex(0xFE5269)];
}

- (void)showShoppingCarsBageValue:(NSInteger)numberValue
                      bageBgColor:(UIColor *)bgColor
                    bageTextColor:(UIColor *)textColor
                  bageBorderWidth:(CGFloat)width
                  bageBorderColor:(UIColor *)borderColor
{
    if (numberValue>0) {
//        self.imageView.clipsToBounds = NO;
//        self.imageView.badgeBgColor = WX_ColorHex(0xFE5269;
//        self.imageView.badgeTextColor = WX_ColorWhite();
//        self.imageView.badgeFont = WXFontBoldSize(10.0);
//        [self.imageView showBadgeWithStyle:WBadgeStyleNumber value:numberValue];
//        self.imageView.badgeCenterOffset = CGPointMake(-4.5, 2);
//        if (bgColor) {
//            self.imageView.badgeBgColor = bgColor;
//        }
//        if (textColor) {
//            self.imageView.badgeTextColor = textColor;
//        }
//        if (width > 0) {
//            self.imageView.badge.layer.borderWidth = width;
//        }
//        if (borderColor) {
//            self.imageView.badge.layer.borderColor = borderColor.CGColor;
//            self.imageView.badge.layer.masksToBounds = YES;
//        }
//    } else {
//        if (self.imageView.badge) {
//            [self.imageView clearBadge];
//        }
    }
}

#pragma mark - UIButton (GraphicBtn) ==================================================

- (void)initWithTitle:(NSString *)titles andImageName:(NSString *)imageName andTopHeight:(CGFloat)topHeigt andTextColor:(UIColor *)textColor{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(topHeigt);
        make.size.mas_equalTo(CGSizeMake(24, 18));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = titles;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = textColor;
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(imageView.mas_bottom).offset(5);
    }];
}

/**
 *  设置属性文字
 *
 *  @param textArr   需要显示的文字数组,如果有换行请在文字中添加 "\n"换行符
 *  @param fontArr   字体数组, 如果fontArr与textArr个数不相同则获取字体数组中最后一个字体
 *  @param colorArr  颜色数组, 如果colorArr与textArr个数不相同则获取字体数组中最后一个颜色
 *  @param spacing   换行的行间距
 *  @param alignment 换行的文字对齐方式
 */
- (void)setAttriStrWithTextArray:(NSArray *)textArr
                         fontArr:(NSArray *)fontArr
                        colorArr:(NSArray *)colorArr
                     lineSpacing:(CGFloat)spacing
                       alignment:(NSTextAlignment)alignment
{
    if (textArr.count >0 && fontArr.count >0 && colorArr.count > 0) {
        
        NSMutableString *allString = [NSMutableString string];
        for (NSString *tempText in textArr) {
            [allString appendFormat:@"%@",tempText];
        }
        
        NSRange lastTextRange = NSMakeRange(0, 0);
        NSMutableArray *rangeArr = [NSMutableArray array];
        
        for (NSString *tempText in textArr) {
            NSRange range = [allString rangeOfString:tempText];
            
            //如果存在相同字符,则换一种查找的方法
            if ([allString componentsSeparatedByString:tempText].count>2) { //存在多个相同字符
                range = NSMakeRange(lastTextRange.location+lastTextRange.length, tempText.length);
            }
            
            [rangeArr addObject:NSStringFromRange(range)];
            lastTextRange = range;
        }
        
        //设置属性文字
        NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:allString];
        for (int i=0; i<textArr.count; i++) {
            NSRange range = NSRangeFromString(rangeArr[i]);
            
            UIFont *font = (i > fontArr.count-1) ? [fontArr lastObject] : fontArr[i];
            [textAttr addAttribute:NSFontAttributeName value:font range:range];
            
            UIColor *color = (i > colorArr.count-1) ? [colorArr lastObject] : colorArr[i];
            [textAttr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        
        //如果需要换行
        if ([allString rangeOfString:@"\n"].location != NSNotFound) {
            self.titleLabel.numberOfLines = 0;
        }
        
        [self setAttributedTitle:textAttr forState:0];
        
        //段落 <如果有换行 或者 字体宽度超过一行就设置行间距>
        if (self.frame.size.width > [UIScreen mainScreen].bounds.size.width || [allString rangeOfString:@"\n"].location != NSNotFound) {
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = spacing;
            paragraphStyle.alignment = alignment;
            self.titleLabel.numberOfLines = 0;
            [textAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,allString.length)];
            [self setAttributedTitle:textAttr forState:0];
        }
    } else {
        WX_Log(@"文字,颜色,字体 每个数组至少有一个");
    }
}


#pragma mark - UIButton (UIButtonImageWithLable) ==================================================


- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    BOOL isRightToLeftShow = NO;
    if (isRightToLeftShow) {
        [self.imageView setContentMode:UIViewContentModeCenter];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                                  5.0,
                                                  0.0,
                                                  0.0)];
        [self setImage:image forState:stateType];
        
        [self.titleLabel setContentMode:UIViewContentModeCenter];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                                  -5.0,
                                                  0.0,
                                                  0.0)];
        [self setTitle:title forState:stateType];
    } else {
        [self.imageView setContentMode:UIViewContentModeCenter];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                                  -5.0,
                                                  0.0,
                                                  0.0)];
        [self setImage:image forState:stateType];
        
        [self.titleLabel setContentMode:UIViewContentModeCenter];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                                  5.0,
                                                  0.0,
                                                  0.0)];
        [self setTitle:title forState:stateType];
    }
}

#pragma mark - ============ 布局标题和图片位置 ============

/** v4.8.0调整
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutStyle:(WXButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space {
    
    // 强制更新布局，以获得最新的 imageView 和 titleLabel 的 frame
    [self layoutIfNeeded];
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.intrinsicContentSize.width;
    CGFloat imageHeight = self.imageView.intrinsicContentSize.height;

    CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
    CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    BOOL isRightToLeftShow = NO;//阿语
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case WXButtonEdgeInsetsStyleTop: // image在上，label在下
        {
            if (isRightToLeftShow) {//阿语
                imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, -labelWidth, 0, 0);
                labelEdgeInsets = UIEdgeInsetsMake(0, 0, -imageHeight-space/2.0, -imageWith);
            } else {
                imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
            }
        }
            break;
        case WXButtonEdgeInsetsStyleLeft: // image在左，label在右
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
        case WXButtonEdgeInsetsStyleBottom: // image在下，label在上
        {
            if (isRightToLeftShow) {//阿语
                imageEdgeInsets = UIEdgeInsetsMake(0, -labelWidth, -labelHeight-space/2.0, 0);
                labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, 0, 0, -imageWith);
            } else  {
                imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
                labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
            }
        }
            break;
        case WXButtonEdgeInsetsStyleRight: // image在右，label在左
        {
            if (isRightToLeftShow) {//阿语
                imageEdgeInsets = UIEdgeInsetsMake(0, -labelWidth-space/2.0, 0, labelWidth+space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, imageWith+space/2.0, 0, -imageWith-space/2.0);
            } else {
                imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
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

#pragma mark - ============ 给按钮点击事件 ============

/**
 按钮点击以Block方式回调
 
 @param handler 点击事件的回调
 */
-(void)addTouchUpInsideHandler:(WXTouchedBlock)handler
{
    objc_setAssociatedObject(self, WXButtonBlockKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(ok_touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)ok_touchUpInside:(UIButton *)btn{
    WXTouchedBlock block = objc_getAssociatedObject(self, WXButtonBlockKey);
    if (block) {
        block(btn);
    }
}

#pragma mark - ============ 设置按钮不同状态的背景颜色 ============

/**
 *  设置按钮不同状态的背景颜色（代替图片）
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIImage wx_createImageWithColor:backgroundColor] forState:state];
}


@end
