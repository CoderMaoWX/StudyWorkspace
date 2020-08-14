//
//  WXCFuntionTool.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "WXCFuntionTool.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <CommonCrypto/CommonDigest.h>
#import <objc/message.h>

static NSString *kWXBundName = @"StudyWorkspace";

static NSInteger kWXToastShowTime = 1.5;
static NSInteger kWXLoadingHUDTag = 1024;
static NSInteger kWXToastHUDTag   = 2048;


@implementation WXCFuntionTool

/** 获取直播SDK Bundle */
NSBundle* WXBundle(void) {
    NSBundle *bundle = [NSBundle bundleForClass:[WXCFuntionTool class]];
    NSURL *bundleURL = [bundle URLForResource:kWXBundName withExtension:@"bundle"];
    if (!bundleURL) {
        bundleURL = [[NSBundle mainBundle] URLForResource:kWXBundName withExtension:@"bundle"];
    }
    return bundleURL ? [NSBundle bundleWithURL:bundleURL] : [NSBundle mainBundle];
}

/** 获取直播SDK版本 */
NSString* WXBundleVersion(void) {
    NSURL *url = [WXBundle() resourceURL];
    NSBundle *bundle = url ? [NSBundle bundleWithURL:url] : [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:kWXBundName ofType:@"plist"];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    return [infoDict objectForKey:@"CFBundleShortVersionString"];
}

/** Live SDK统一获取图片方法 */
UIImage* WXImageName(NSString *imageName) {
    NSURL *url = [WXBundle() resourceURL];
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
UIImage * WXCreateImageWithColor(UIColor *color) {
    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 2.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,  [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark -==================================多语言====================================

/** 获取多语言 */
NSString* WXLanguage(NSString *languageKey) {
    NSBundle *bundle = WXBundle() ?: [NSBundle mainBundle];
    NSString *appLanguage = @"en";//[GlobalConfig sharedInstance].appLanguage;
    if (WXIsEmptyString(appLanguage)) {
        appLanguage = @"en";
    }
    NSBundle *languageBundle = [NSBundle bundleWithPath:[bundle pathForResource:appLanguage ofType:@"lproj"]];
    NSString *language = [languageBundle localizedStringForKey:WXToString(languageKey) value:nil table:nil];
    return [NSString stringWithFormat:@"%@",language];
}

/** 获取指定国家的多语言 */
NSString* WXLanguageCountry(NSString *languageKey, NSString *countryCode) {
    if (WXIsEmptyString(countryCode)) {
        return WXLanguage(languageKey);
    }
    NSBundle *bundle = WXBundle() ?: [NSBundle mainBundle];
    NSBundle *languageBundle = [NSBundle bundleWithPath:[bundle pathForResource:countryCode ofType:@"lproj"]];
    NSString *language = [languageBundle localizedStringForKey:WXToString(languageKey) value:nil table:nil];
    return [NSString stringWithFormat:@"%@",language];
}

/** 给图片设置颜色 */
UIImage* WXConvertImageColor(UIImage *image, UIColor *color) {
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
UIImage* WXImageBlurry(UIImage *originImage, CGFloat blurLevel) {
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


#pragma mark -==================================颜色====================================

/** 获取白颜色 */
UIColor* WXColorWhite(void) {
    return [UIColor whiteColor];
}

/** 获取RGB颜色 */
UIColor* WXColorRGB(NSInteger R, NSInteger G, NSInteger B, CGFloat a) {
    return [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:a];
}

/** 获取十六进制颜色 */
UIColor* WXColorHex(NSInteger hexValue, CGFloat a) {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a];
}

/** 获取随机颜色 */
UIColor* WXColorRandom(void) {
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

/** 十六进制的颜色（以#/0X开头）转换为UIColor */
UIColor* colorWithHexString(NSString *colorString) {
    if (!WXJudgeNSString(colorString)) return nil;
    
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
UIFont * WXFontBold(CGFloat size) {
    return [UIFont boldSystemFontOfSize:size];
}

/** 获取系统粗体字 */
UIFont * WXFontSystem(CGFloat size) {
    return [UIFont systemFontOfSize:size];
}

/** 获取系统自定义字体 */
UIFont * WXFontCustom(NSString *fontName, CGFloat size) {
    return [UIFont fontWithName:fontName size:size];
}



#pragma mark -==================================HUD====================================

/** 获取弹框window */
UIWindow * WXFetchHUDSuperView(void) {
    UIWindow *loadingSuperView = [UIApplication sharedApplication].delegate.window;
    if (![loadingSuperView isKindOfClass:[UIView class]]) return nil;
    return loadingSuperView;
}

/** 显示loading框现在window上禁止交互 */
void WXShowLoadingView(void) {
    UIWindow *loadingSuperView = WXFetchHUDSuperView();
    if (![loadingSuperView isKindOfClass:[UIView class]]) return;

    WXHideLoadingView();
    
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
    
    UIActivityIndicatorView *loadingView = WXFetchIndicatorView(UIActivityIndicatorViewStyleWhiteLarge, [UIColor grayColor]);
    loadingView.center = CGPointMake(HUDSize/2, HUDSize/2);
    [indicatorBg addSubview:loadingView];
}

/** 隐藏window上的loading框 */
void WXHideLoadingView(void) {
    UIWindow *loadingSuperView = WXFetchHUDSuperView();
    if (![loadingSuperView isKindOfClass:[UIView class]]) return;
    for (UIView *tempLoadingView in loadingSuperView.subviews) {
        if (tempLoadingView.tag == kWXLoadingHUDTag) {
            [tempLoadingView removeFromSuperview];
        }
    }
}

/** 显示纯文本Toast展示 */
void WXShowToastWithText(NSString *message) {
    if (WXIsEmptyString(message)) return;
    
    UIWindow *loadingSuperView = WXFetchHUDSuperView();
    WXHideLoadingView();
    
    UIView *oldToastView = [loadingSuperView viewWithTag:kWXToastHUDTag];
    if (oldToastView) {
        [oldToastView removeFromSuperview];
    }
    
    //黑色半透明View
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectZero];
    blackView.tag = kWXToastHUDTag;
    blackView.backgroundColor = WXColorRGB(51, 51, 51, 0.9);
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
    messageLabel.font = WXFontSystem(14.0);
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
    CGFloat time = messageLength / 15;
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
UIActivityIndicatorView * WXFetchIndicatorView(UIActivityIndicatorViewStyle style, UIColor *color) {
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
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
BOOL WXJudgeNSString(id obj) {
    if ([obj isKindOfClass:[NSString class]]) {
        return YES;
    }
    return NO;
}

/**
 * 判断是否为NSDictionary
 */
BOOL WXJudgeNSDictionary(id obj) {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

/**
 * 判断是否为NSArray
 */
BOOL WXJudgeNSArray(id obj) {
    if ([obj isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

/**
 * 判断字符串是否为空
 */
BOOL WXIsEmptyString(id obj) {
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
NSString * WXToString(id obj) {
    if (!obj) return @"";
    
    if (WXJudgeNSString(obj)) {
        return obj;
    }
    if (WXJudgeNSDictionary(obj) || WXJudgeNSArray(obj)) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                           options:NSJSONWritingPrettyPrinted
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

///转换为字典
NSDictionary * GliveToDictiontry(id objc) {
    NSData *data = objc;
    if (WXJudgeNSString(objc)) {
        data = [objc dataUsingEncoding:NSUTF8StringEncoding];
    }
    if (![data isKindOfClass:[NSData class]]) return nil;
    NSError *parseError = nil;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
    return parseError ? nil : responseDict;
    return nil;;
}

///词典转换为字符串
NSString * GliveDictionaryToJson(NSDictionary *dic) {
    if (!WXJudgeNSDictionary(dic)) return nil;
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return parseError ? nil : [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/// 转成MD5字符串
NSString * GliveToMD5String(NSString *string) {
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
    
//    if (!WXJudgeNSString(originStr)) return nil;
//    const char *cStr = [originStr UTF8String];
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest);
//    NSMutableString *md5Str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
//        [md5Str appendFormat:@"%02x", digest[i]];
//    }
//    return md5Str;
}

#pragma mark -==================================系统弹框操作====================================

/** 跳转到系统授权设置页面 */
void jumpApplicationOpenSetting(void) {
    NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (!success) {
            WXLog(@"打开设置页面失败,页面需要Toast提示");
        }
    }];
}

/** 跳转到系统设置授权 */
void openSystemPreferencesSetting(NSString *alerTitle) {
    UIAlertController *alertController = [UIAlertController
             alertControllerWithTitle:WXLanguage(alerTitle)
                              message:WXLanguage(@"跳转到系统设置授权")
                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:WXLanguage(@"去授权") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
        NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                WXLog(@"打开设置页面失败,页面需要Toast提示");
            }
        }];
    }];
    [alertController addAction:settingAction];
    UIWindow* window = WXFetchHUDSuperView();
    [window.rootViewController presentViewController:alertController animated:YES completion:nil];
}



/** 系统弹框 */
void showAlertController(NSString *title, NSString *message,
                         NSString *otherTitle, void(^otherBtnBlock)(void),
                         NSString *cancelTitle, void(^cancelBtnBlock)(void))
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                       preferredStyle:UIAlertControllerStyleAlert];

    NSString *colorKey = @"_titleTextColor";
    
    if ([cancelTitle isKindOfClass:[NSString class]]) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            if (cancelBtnBlock) {
                cancelBtnBlock();
            }
        }];
        if (checkObjectHasVarName([UIAlertAction class], colorKey)) {
            [cancelAction setValue:WXColorHex(0x2D2D2D, 1) forKey:colorKey];
        }
        [alertController addAction:cancelAction];
    }
    if ([otherTitle isKindOfClass:[NSString class]]) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            if (otherBtnBlock) {
                otherBtnBlock();
            }
        }];
        if (checkObjectHasVarName([UIAlertAction class], colorKey)) {
            [otherAction setValue:WXColorHex(0xFE5269, 1) forKey:colorKey];
        }
        [alertController addAction:otherAction];
    }
    UIWindow* window = WXFetchHUDSuperView();
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

#pragma mark -==================================权限操作判断===================================


/** 相机是否可用 (1.没申请过权限 2.已申请且已关闭) */
BOOL isCanUseCamera(void) {
    BOOL hasAuthorize = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) { //已授权
        hasAuthorize = YES;
    }
    return hasAuthorize;
}

/** 麦克风是否可用 (1.没申请过权限 2.已申请且已关闭) */
BOOL isCanUseMicrophone (void) {
    BOOL hasAuthorize = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusAuthorized) { //已授权
        hasAuthorize = YES;
    }
    return hasAuthorize;
}

/** 主动申请相机权限 */
void applyCameraPermission(void (^applyPermission)(BOOL)) {
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
void applyMicrophonePermission(void (^applyPermission)(BOOL)) {
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
BOOL hasApplyCameraPermission(void) {
    BOOL hasApply = YES;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) { //没有询问是否开启麦克风
        hasApply = NO;
    }
    return hasApply;
}

/** 是否已经申请过麦克风权限 */
BOOL hasApplyMicrophonePermission(void) {
    BOOL hasApply = YES;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined) { //没有询问是否开启麦克风
        hasApply = NO;
    }
    return hasApply;
}

@end
