//
//  WXCFunctionTool.m
//  ZXOwner
//
//  Created by Luke on 2020/8/17.
//  Copyright © 2020 51zxwang. All rights reserved.
//

#import "WXCFunctionTool.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CommonCrypto/CommonDigest.h>
#import <objc/message.h>
#import "WXPublicHeader.h"

static NSString *kWXBundName = @"WXCFunctionTool";

static NSInteger kWXToastShowTime = 1.5;
static NSInteger kWXLoadingHUDTag = 7987;
static NSInteger kWXToastHUDTag   = 9748;


@implementation WXCFunctionTool

/** 获取Bundle */
NSBundle *WX_Bundle(void) {
    NSBundle *bundle = [NSBundle bundleForClass:[WXCFunctionTool class]];
    NSURL *bundleURL = [bundle URLForResource:kWXBundName withExtension:@"bundle"];
    if (!bundleURL) {
        bundleURL = [[NSBundle mainBundle] URLForResource:kWXBundName withExtension:@"bundle"];
    }
    return bundleURL ? [NSBundle bundleWithURL:bundleURL] : [NSBundle mainBundle];
}

/** 获取版本 */
NSString *WX_BundleVersion(void) {
    NSURL *url = [WX_Bundle() resourceURL];
    NSBundle *bundle = url ? [NSBundle bundleWithURL:url] : [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:kWXBundName ofType:@"plist"];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    return [infoDict objectForKey:@"CFBundleShortVersionString"];
}

/** 统一获取图片方法 */
UIImage *WX_ImageName(NSString *imageName) {
    NSURL *url = [WX_Bundle() resourceURL];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    if (!imageBundle) {
        imageBundle = [NSBundle mainBundle];
    }
    UIImage *image = [UIImage imageNamed:imageName
                                inBundle:imageBundle
           compatibleWithTraitCollection:nil];
    
    if ([UIView appearance].semanticContentAttribute == UISemanticContentAttributeForceRightToLeft) {
        image = [image imageFlippedForRightToLeftLayoutDirection];
    }
    return image;
}

/** 根据颜色绘制图片 */
UIImage *WX_CreateImageWithColor(UIColor *color) {
    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 2.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,  [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/** 给图片设置颜色 */
UIImage *WX_ConvertImageColor(UIImage *image, UIColor *color) {
    if (![color isKindOfClass:[UIColor class]]) {
        return image;
    }
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/// 高斯模糊图片
UIImage *WX_ImageBlurry(UIImage *originImage, CGFloat blurLevel) {
    if (![originImage isKindOfClass:[UIImage class]]) return nil;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:originImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@(blurLevel) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:ciImage.extent];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

#pragma mark -==================================多语言====================================

/** 获取多语言 */
NSString *WX_Language(NSString *languageKey) {
    NSBundle *bundle = WX_Bundle() ?: [NSBundle mainBundle];
    NSString *appLanguage = @"en";//[GlobalConfig sharedInstance].appLanguage;
    if (WX_isEmptyString(appLanguage)) {
        appLanguage = @"en";
    }
    NSBundle *languageBundle = [NSBundle bundleWithPath:[bundle pathForResource:appLanguage ofType:@"lproj"]];
    NSString *language = [languageBundle localizedStringForKey:WX_ToString(languageKey) value:nil table:nil];
    return [NSString stringWithFormat:@"%@",language];
}

/** 获取指定国家的多语言 */
NSString *WX_LanguageCountry(NSString *languageKey, NSString *countryCode) {
    if (WX_isEmptyString(countryCode)) {
        return WX_Language(languageKey);
    }
    NSBundle *bundle = WX_Bundle() ?: [NSBundle mainBundle];
    NSBundle *languageBundle = [NSBundle bundleWithPath:[bundle pathForResource:countryCode ofType:@"lproj"]];
    NSString *language = [languageBundle localizedStringForKey:WX_ToString(languageKey) value:nil table:nil];
    return [NSString stringWithFormat:@"%@",language];
}

#pragma mark -==================================颜色====================================

/** 获取白颜色 */
UIColor *WX_ColorWhite(void) {
    return [UIColor whiteColor];
}

/** 线条颜色 */
UIColor *WX_ColorLineColor(void) {
    return WX_ColorHex(0xDDDDDD);
}

/** 黑色字体颜色 */
UIColor *WX_ColorBlackTextColor(void) {
    return WX_ColorHex(0x4A4A4A);
}

/** App主色: 黄色 */
UIColor *WX_ColorMainColor(void) {
    return WX_ColorHex(0xF29448);
}

/** 获取RGB颜色 */
UIColor *WX_ColorRGB(NSInteger R, NSInteger G, NSInteger B, CGFloat a) {
    return [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:a];
}

/** 获取十六进制颜色 */
UIColor *WX_ColorHex(NSInteger hexValue) {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1];
    
}
/** 获取十六进制颜色, a:透明度 */
UIColor *WX_ColorHex_a(NSInteger hexValue, CGFloat a) {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a];
}

/** 获取随机颜色 */
UIColor *WX_ColorRandom(void) {
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

/** 十六进制的颜色（以#/0X开头）转换为UIColor */
UIColor *WX_ColorWithHexString(NSString *colorString) {
    if (!WX_isNSString(colorString)) return nil;
    
    NSString *cString = [[colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }

    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];

    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;

    //R、G、B
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


#pragma mark -==================================字体操作===================================

/** 获取系统粗体字 */
UIFont *WX_FontSystem(CGFloat size) {
    return [UIFont systemFontOfSize:size];
}

/** 获取系统粗体字 */
UIFont *WX_FontBold(CGFloat size) {
    return [UIFont boldSystemFontOfSize:size];
}

/** 获取系统自定义字体 */
UIFont *WX_FontCustom(NSString *fontName, CGFloat size) {
    return [UIFont fontWithName:fontName size:size];
}

/** 数字等宽字体 (eg: 倒计时数字不抖动) */
UIFont *WX_FontMonospacedDigit(CGFloat size) {
    return [UIFont monospacedDigitSystemFontOfSize:size weight:UIFontWeightRegular];
}


#pragma mark -==================================HUD====================================

/** 获取弹框window */
UIWindow *WX_FetchHUDSuperView(id parmaters) {
    if (WX_isNSDictionary(parmaters)) {
        if ([parmaters[kLoadingView] isKindOfClass:[UIView class]]) {
            return parmaters[kLoadingView];
        }
    } else if ([parmaters isKindOfClass:[UIView class]]) {
        return parmaters;
    }
    UIWindow *window = nil;
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        window = delegate.window;
    } else {
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window makeKeyAndVisible];
    }
    return window;
}

/** 显示loading框现在window上禁止交互 */
void WX_ShowLoadingToView(id parmaters) {
    UIView *loadingSuperView = WX_FetchHUDSuperView(parmaters);
    if (![loadingSuperView isKindOfClass:[UIView class]]) return;

    WX_HideLoadingFromView(parmaters);
    
    UIView *oldToastView = [loadingSuperView viewWithTag:kWXToastHUDTag];
    if (oldToastView) {
        [oldToastView removeFromSuperview];
    }
    
    UIView *maskBgView = [[UIView alloc] initWithFrame:loadingSuperView.bounds];
    maskBgView.backgroundColor = [UIColor clearColor];
    maskBgView.tag = kWXLoadingHUDTag;
    [loadingSuperView addSubview:maskBgView];
    
    CGFloat HUDSize = 72;
    CGFloat x = (maskBgView.bounds.size.width - HUDSize) /2;
    CGFloat y = (maskBgView.bounds.size.height - HUDSize) /2;
    UIView *indicatorBg = [[UIView alloc] initWithFrame:CGRectMake(x, y, HUDSize, HUDSize)];
    indicatorBg.layer.masksToBounds = YES;
    indicatorBg.layer.cornerRadius = 12;
    indicatorBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [maskBgView addSubview:indicatorBg];
    
    UIActivityIndicatorView *loadingView = WX_FetchIndicatorView(UIActivityIndicatorViewStyleWhiteLarge, [UIColor grayColor]);
    loadingView.center = CGPointMake(HUDSize/2, HUDSize/2);
    [indicatorBg addSubview:loadingView];
}

/** 隐藏window上的loading框 */
void WX_HideLoadingFromView(id parmaters) {
    UIWindow *loadingSuperView = WX_FetchHUDSuperView(parmaters);
    if (![loadingSuperView isKindOfClass:[UIView class]]) return;
    for (UIView *tempLoadingView in loadingSuperView.subviews) {
        if (tempLoadingView.tag == kWXLoadingHUDTag) {
            [tempLoadingView removeFromSuperview];
        }
    }
}

/** 显示纯文本Toast展示 */
void WX_ShowToastWithText(id parmaters, NSString *message) {
    if (WX_isEmptyString(message)) return;
    
    UIWindow *loadingSuperView = WX_FetchHUDSuperView(parmaters);
    WX_HideLoadingFromView(parmaters);
    
    UIView *oldToastView = [loadingSuperView viewWithTag:kWXToastHUDTag];
    if (oldToastView) {
        [oldToastView removeFromSuperview];
    }
    
    //黑色半透明View
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectZero];
    blackView.tag = kWXToastHUDTag;
    blackView.backgroundColor = WX_ColorRGB(51, 51, 51, 0.9);
    blackView.layer.cornerRadius = 4;
    blackView.layer.masksToBounds = YES;
    [loadingSuperView addSubview:blackView];
    
    CGFloat horizontalMargin = 12;//水平方向间距
    CGFloat verticalMargin = 15;//垂直方向间距
    CGFloat maxTextWidth = kScreenWidth-horizontalMargin*4;
    
    //提示文案
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.frame = CGRectMake(0, 0, maxTextWidth, 0);
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = WX_FontSystem(14.0);
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.preferredMaxLayoutWidth = maxTextWidth;
    messageLabel.numberOfLines = 0;
    messageLabel.text = message;
    [messageLabel sizeToFit];
    messageLabel.frame = CGRectMake(0, 0, MIN(messageLabel.bounds.size.width, maxTextWidth), messageLabel.bounds.size.height);
    [blackView addSubview:messageLabel];
    
    CGFloat blackViewWidth = MIN(messageLabel.bounds.size.width + horizontalMargin*2, kScreenWidth-horizontalMargin*2);
    CGFloat blackViewHeight = messageLabel.bounds.size.height + verticalMargin*2;
    blackView.frame = CGRectMake(0, 0, blackViewWidth, blackViewHeight);
    blackView.center = CGPointMake(loadingSuperView.bounds.size.width/2, loadingSuperView.bounds.size.height / 2);
    messageLabel.center = CGPointMake(blackView.bounds.size.width/2, blackView.bounds.size.height/2);
    
    NSInteger messageLength = message.length;
    CGFloat time = messageLength / 6;
    if (time < kWXToastShowTime) {
        time = kWXToastShowTime;
    }
    if (time > 5) {
        time = 5;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (blackView) {
            [blackView removeFromSuperview];
        }
    });
}

/** 系统菊花转圈 */
UIActivityIndicatorView *WX_FetchIndicatorView(UIActivityIndicatorViewStyle style, UIColor *color) {
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    indicatorView.color = WX_ColorWhite();
    indicatorView.hidesWhenStopped = YES;
    [indicatorView startAnimating];
    if ([color isKindOfClass:[UIColor class]]) {
        indicatorView.color = color;
    }
    return indicatorView;
}

#pragma mark -==================================字符串、对象====================================

/**
 * 判断是否为NSString
 */
BOOL WX_isNSString(id obj) {
    if ([obj isKindOfClass:[NSString class]]) {
        return YES;
    }
    return NO;
}

/**
 * 判断是否为NSDictionary
 */
BOOL WX_isNSDictionary(id obj) {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

/**
 * 判断是否为NSArray
 */
BOOL WX_isNSArray(id obj) {
    if ([obj isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

/**
 * 判断字符串是否为空
 */
BOOL WX_isEmptyString(id obj) {
    if (![obj isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (obj == nil || obj == NULL) {
        return YES;
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    NSString *emptyString = (NSString *)obj;
    if ([emptyString.lowercaseString isEqualToString:@"null"]) {
        return YES;
    }
    return NO;
}

/**
 *  转化为NSString来返回，如果为数组或字典转为String返回, 其他对象则返回@""
 *  适用于取一个值后赋值给文本显示时用
 */
NSString *WX_ToString(id obj) {
    if (!obj) return @"";
    
    if (WX_isNSString(obj)) {
        return obj;
    }
    if (WX_isNSDictionary(obj) || WX_isNSArray(obj)) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                           options:0
                                                             error:nil];
        if (jsonData) {
            return [[NSString alloc] initWithData:jsonData encoding:(NSUTF8StringEncoding)];
        }
    }
    if (![obj isKindOfClass:[NSNull class]] &&
        ![obj isEqual:nil] &&
        ![obj isEqual:[NSNull null]]) {
        NSString *result = [NSString stringWithFormat:@"%@",obj];
        if (result && result.length > 0) {
            return result;
        }
    }
    return @"";
}

/**
 *  格式化字符串
 */
NSString *WX_FormatString(NSString *format, ...) {
    if (![format isKindOfClass:[NSString class]]) return @"";
    
    va_list argList;
    va_start (argList, format);
    NSString *formatString = [[NSString alloc]initWithFormat:format arguments:argList];
    va_end (argList);
    return formatString;
}

///转换为字典
NSDictionary *WX_ToDictiontry(id objc) {
    NSData *data = objc;
    if (WX_isNSString(objc)) {
        data = [objc dataUsingEncoding:NSUTF8StringEncoding];
    }
    if (![data isKindOfClass:[NSData class]]) return nil;
    NSError *parseError = nil;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
    return parseError ? nil : responseDict;
    return nil;;
}

///字典转换为字符串
NSString *WX_DictionaryToJson(NSDictionary *dic) {
    if (!WX_isNSDictionary(dic)) return nil;
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    return parseError ? nil : [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/// 转成MD5字符串
NSString *WX_ToMD5String(NSString *string) {
    if (!string) return nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],  result[1],  result[2],  result[3],
            result[4],  result[5],  result[6],  result[7],
            result[8],  result[9],  result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

///时间戳变为格式时间
NSString *WX_ConvertTimeStamp(NSTimeInterval timeStamp, NSString *dateFormat) {
    if (timeStamp == 0) { //不存在用当前的时间戳
        NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
        timeStamp = [dat timeIntervalSince1970];
    }
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:WX_ToString(dateFormat)];
    NSString *currentDateStr = [formatter stringFromDate:date];
    return currentDateStr;
}

#pragma mark -==================================权限操作判断===================================


/** 相机是否可用 (1.没申请过权限 2.已申请且已关闭) */
BOOL WX_isCanUseCamera(void) {
    BOOL hasAuthorize = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) { //已授权
        hasAuthorize = YES;
    }
    return hasAuthorize;
}

/** 麦克风是否可用 (1.没申请过权限 2.已申请且已关闭) */
BOOL WX_isCanUseMicrophone (void) {
    BOOL hasAuthorize = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusAuthorized) { //已授权
        hasAuthorize = YES;
    }
    return hasAuthorize;
}

/** 主动申请相机权限 */
void WX_applyCameraPermission(void (^applyPermission)(BOOL)) {
    //如果是第一次申请,系统会弹框询问提示用户授权, 否则不会弹框
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (applyPermission) {
                applyPermission(granted);
            }
        });
    }];
}

/** 主动申请麦克风权限 */
void WX_applyMicrophonePermission(void (^applyPermission)(BOOL)) {
    //如果是第一次申请,系统会弹框询问提示用户授权, 否则不会弹框
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (applyPermission) {
                applyPermission(granted);
            }
        });
    }];
}

/** 是否已经申请过相机权限 */
BOOL WX_hasApplyCameraPermission(void) {
    BOOL hasApply = YES;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) { //没有询问是否开启麦克风
        hasApply = NO;
    }
    return hasApply;
}

/** 是否已经申请过麦克风权限 */
BOOL WX_hasApplyMicrophonePermission(void) {
    BOOL hasApply = YES;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined) { //没有询问是否开启麦克风
        hasApply = NO;
    }
    return hasApply;
}


#pragma mark -==================================系统弹框操作====================================

/** 跳转到系统授权设置页面 */
void WX_jumpApplicationOpenSetting(void) {
    NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                WX_Log(@"打开设置页面失败,页面需要Toast提示");
            }
        }];
    } else {
        [[UIApplication sharedApplication] openURL:URL];
    }
}

/** 跳转到系统设置授权 */
void WX_openSystemPreferencesSetting(NSString *alerTitle) {
    UIAlertController *alertController = [UIAlertController
             alertControllerWithTitle:WX_ToString(alerTitle)
                              message:WX_ToString(@"跳转到系统设置授权")
                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:WX_ToString(@"去授权") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
        NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    WX_Log(@"打开设置页面失败,页面需要Toast提示");
                }
            }];
        } else {
            [[UIApplication sharedApplication] openURL:URL];
        }
    }];
    [alertController addAction:settingAction];
    UIWindow* window = WX_FetchHUDSuperView(nil);
    [window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

/** 系统弹框 (最多两个个按钮) */
void WX_showAlertController(NSString *title, NSString *message,
                         NSString *otherTitle, void(^otherBtnBlock)(void),
                         NSString *cancelTitle, void(^cancelBtnBlock)(void))
{
    NSArray *array = otherTitle ? @[otherTitle] : nil;
    WX_showAlertMultiple(title, message, array, ^(NSInteger buttonIndex, id buttonTitle) {
        if (otherBtnBlock) {
            otherBtnBlock();
        }
    }, cancelTitle, cancelBtnBlock);
}

/** 系统弹框 (可显示多个按钮) */
void WX_showAlertMultiple(NSString *title, NSString *message,
                         NSArray *otherButtonTitles, void(^otherBtnBlock)(NSInteger buttonIndex, id buttonTitle),
                         NSString *cancelTitle, void(^cancelBtnBlock)(void))
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    NSString *colorKey = @"_titleTextColor";
    //普通按钮
    for (int i = 0; i<otherButtonTitles.count; i++) {
        NSString *btnTitle = otherButtonTitles[i];
        if (![btnTitle isKindOfClass:[NSString class]]) continue;
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action) {
            if (otherBtnBlock) {
                otherBtnBlock(i, btnTitle);
            }
        }];
        if (checkObjectHasVarName([UIAlertAction class], colorKey)) {
            [otherAction setValue:WX_ColorMainColor() forKey:colorKey];
        }
        [alertController addAction:otherAction];
    }
    //取消按钮
    if ([cancelTitle isKindOfClass:[NSString class]]) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            if (cancelBtnBlock) {
                cancelBtnBlock();
            }
        }];
        if (checkObjectHasVarName([UIAlertAction class], colorKey)) {
            [cancelAction setValue:WX_ColorHex(0x2D2D2D) forKey:colorKey];
        }
        [alertController addAction:cancelAction];
    }
    UIWindow *window = WX_FetchHUDSuperView(nil);
    [window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

/** 检查类的实例是否有该属性 */
BOOL checkObjectHasVarName(id verifyObject, NSString *varName) {
    unsigned int outCount;
    BOOL hasProperty = NO;
    Ivar *ivars = class_copyIvarList([verifyObject class], &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        
        NSString *absoluteName = [NSString stringWithString:varName];
        absoluteName = [absoluteName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if ([keyName isEqualToString:absoluteName]) {
            hasProperty = YES;
            break;
        }
    }
    free(ivars);
    return hasProperty;
}

/**
 *  字符串编码
 *  @param originStr 源字符串
 *  @param reservedSymbol 是否保留特殊字符不编码
 */
NSString *WX_CodingString(NSString *originStr, BOOL reservedSymbol) {
    NSMutableCharacterSet *cs = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    NSString * const kReservedChars = @":/?[]@!$&'()*+,;=";
    if (reservedSymbol) {
        [cs addCharactersInString:kReservedChars];//不会对上述字符串进行编码: 上述以外的特殊字符(如空格,百分号%)串会编码成%22 %25 等等字符串
    } else {
        [cs removeCharactersInString:kReservedChars];//会对上述字符串进行编码, 编码后也是变成 %22 等等字符串
    }
    NSString *resultStr = [originStr stringByAddingPercentEncodingWithAllowedCharacters:cs];
    return resultStr;
}

/**
 *  字符串解码
 */
NSString *WX_DecodeString(NSString *originStr) {
    return [originStr stringByRemovingPercentEncoding];
}

#pragma mark -==================================播放系统声音====================================

/**
 * http://iphonedevwiki.net/index.php/AudioServices
 * 震动反馈1: (3DTouch中的peek)
 * (1521: peek震动, 1520:pop震动, 1521:三连震) 系统声音: 1057
 * 优点:能满足大部分震动场景, (使用时倒入头文件: #import <AudioToolbox/AudioToolbox.h> )
 * 缺点:无法精准控制震动力度
 */
- (void)WX_playSystemSound:(SystemSoundID)soundID {
    WX_Log(@"系统声音编号: %ld", (long)soundID);
    AudioServicesPlaySystemSound(soundID);
    
    // NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
    // AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
}

/** 动态更换App的启动图 (闪屏图:LaunchScreenImage)
 *  重现场景: 偶现的发现在修改完storyboard中的启动图logo后, 可能会在不同机型上出现启动图logo黑屏的问题,
 *  解决办法: 找到沙盒目录中存在的启动图截屏文件目录位置, 自己绘制想要显示的启动图后替换原有的文件
 *  备注: 经过测试, 在不同系统版本的沙盒中, 启动图文件的目录位置不同,由于目前考虑到老版本系统上没有出现过黑屏logo问题, 暂时老系统版本不做处理
 *  iOS13以下系统启动图截屏文件保存目录: ~/Library/Caches/Snapshots/com.xxx.xxx/xxxx@2x.ktx
 *  iOS13及以上系统启动图截屏文件保存目录: ~/Library/SplashBoard/Snapshots/com.xxx.xxx - {DEFAULT GROUP}/xxxx@3x.ktx
 *  替换后的变化: 原图大小约8K左右, 替换后大小约28K左右
 */
BOOL WX_replaceCacheLibraryLaunchImage (UIImage *newImage) {
    if (![newImage isKindOfClass:[UIImage class]]) return NO;
    
    NSString *Library = @"Library";
    NSString *SplashBoard = @"SplashBoard";
    NSString *Snapshots = @"Snapshots";//防止在App审核时会机器扫描到截屏目录被拒审, 因此目录临时拼接
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@/%@", Library, SplashBoard, Snapshots];
    NSString *shotsPath = [NSHomeDirectory() stringByAppendingPathComponent:imagePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:shotsPath]) return NO;
    
    NSString *bundleID = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *shotsDirName = [bundleID stringByAppendingString:@" - {DEFAULT GROUP}"];
    shotsPath = [shotsPath stringByAppendingPathComponent:shotsDirName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:shotsPath]) return NO;
    
    NSError *readError = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:shotsPath error:&readError];
    if (readError) return NO;
    
    // 遍历该目录下截图文件
    for (NSString *fileName in files) {
        NSString *replacePath = [shotsPath stringByAppendingPathComponent:fileName];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:replacePath options:NSDataReadingMappedIfSafe error:&error];
        if (!error && [data length]) {
            
            UIImage *oldImage = [UIImage imageWithData:data];
            if (![oldImage isKindOfClass:[UIImage class]]) return NO;
            
            if (![newImage isKindOfClass:[UIImage class]])  {
                newImage = [UIImage imageNamed:@"launch_image"];//sex_swimwear
            }
            if (![newImage isKindOfClass:[UIImage class]]) return NO;
            
            CGFloat scale           = [UIScreen mainScreen].scale;
            CGRect screenBounds     = [UIScreen mainScreen].bounds;
            CGFloat oldImageWidth   = screenBounds.size.width * scale;
            CGFloat oldImageHeight  = screenBounds.size.height * scale;
            //CGFloat newImageWidth   = newImage.size.width * scale;
            //CGFloat newImageHeight  = newImage.size.height * scale;

            // 设置图片尺寸为旧图尺寸
            CGRect rect = CGRectMake(0, 0, oldImageWidth, oldImageHeight);
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 1);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextFillRect(context, rect);
            [newImage drawInRect:rect];//全屏绘制
            UIImage *replaceImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSLog(@"设置图片尺寸为旧图尺寸: %@, %@, %@", oldImage, replaceImage, fileName);
            
            // 写入目录，替换旧图
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                NSData *launchData = UIImageJPEGRepresentation(replaceImage, 0.0);
                if ([[NSFileManager defaultManager] fileExistsAtPath:replacePath]) {
                    
                    NSError *deleteErrors;
                    BOOL deleteSuccess = [[NSFileManager defaultManager] removeItemAtPath:replacePath error:&deleteErrors];
                    if (deleteSuccess || !deleteErrors) {
                        BOOL success = [launchData writeToFile:replacePath atomically:YES];
                        NSLog(@"沙盒目录启动图截屏文件状态:%d, %@", success, replacePath);
                    }
                }
            });
        }
    }
    return YES;
}

/**
 * 获取沙盒的启动图
 * iOS13以下系统启动图截屏文件保存目录: ~/Library/Caches/Snapshots/com.xxx.xxx/xxxx@2x.ktx
 * iOS13及以上系统启动图截屏文件保存目录: ~/Library/SplashBoard/Snapshots/com.xxx.xxx - {DEFAULT GROUP}/xxxx@3x.ktx
 * */
 UIImage *WX_fetchLaunchImage(void) {
    NSString *bundleID = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *launchImagePath = @"Library/SplashBoard/Snapshots";
    NSString *shotsDirName = nil;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 13.0) {
        launchImagePath = @"Library/Caches/Snapshots";
    } else {
        shotsDirName = [bundleID stringByAppendingString:@" - {DEFAULT GROUP}"];
    }
    NSString *shotsPath = [NSHomeDirectory() stringByAppendingPathComponent:launchImagePath];
    if (shotsDirName) {
        shotsPath = [shotsPath stringByAppendingPathComponent:shotsDirName];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:shotsPath]) return nil;

    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:shotsPath error:nil];
    for (NSString *fileName in files) {
        if ([fileName hasSuffix:@".ktx"]) {
            NSString *replacePath = [shotsPath stringByAppendingPathComponent:fileName];
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfFile:replacePath options:NSDataReadingMappedIfSafe error:&error];
            if (!error && [data length]) {
                UIImage *launchImage = [UIImage imageWithData:data];
                if ([launchImage isKindOfClass:[UIImage class]]) return launchImage;
            }
            break;
        }
    }
    return nil;
}

@end
