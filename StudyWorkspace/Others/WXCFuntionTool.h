//
//  WXCFuntionTool.h
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kScreenHeight                   [UIScreen mainScreen].bounds.size.height
#define kScreenWidth                    [UIScreen mainScreen].bounds.size.width
#define kIsBangsScreen                  (KScreenHeight >= 812.0f)///是否为刘海屏幕
#define kStatusBarHeight                [UIApplication sharedApplication].statusBarFrame.size.height
#define kBottomSafeAreaHeight           (kIsBangsScreen ? 34 : 0)
#define kTopSafeAreaHeight              (kIsBangsScreen ? 44.0f : 20.0f)
#define kDefaultCellHeight              (44)

//#define NAVBARHEIGHT                    self.navigationController.navigationBar.frame.size.height
//#define kTabBarHeight                   self.tabBarController.tabBar.bounds.size.height


#pragma mark -==================================弱引用宏====================================
#define Weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")


#define Strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop") \
if (!self) {return;}


//-忽略警告的宏- eg: [obj respondsToSelector:@(xxx)]
#define WXUndeclaredSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//-忽略警告的宏-
#define WXPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#pragma mark -==================================打印日志====================================

#ifdef DEBUG
    #if TARGET_OS_IPHONE // 判断是真机还是模拟器
        #define WXLog(fmt, ...) fprintf(stderr,"%s: [Line %d] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);

    #elif TARGET_IPHONE_SIMULATOR //iPhone Simulator
        #define WXLog(arg,...) //NSLog(@"%s " arg ,__PRETTY_FUNCTION__, ##__VA_ARGS__)
    #endif
#else
    #define WXLog(...)
    #define NSLog(format,...)
#endif


@interface WXCFuntionTool : NSObject

/** 获取直播SDK Bundle */
NSBundle* WXBundle(void);

/** 获取直播SDK版本 */
NSString* WXBundleVersion(void);

/** Live SDK统一获取图片方法 */
UIImage* WXImageName(NSString *imageName);

/** 给图片设置颜色 */
UIImage* WXConvertImageColor(UIImage *image, UIColor *color);

/// 高斯模糊图片
UIImage* WXImageBlurry(UIImage *originImage, CGFloat blurLevel);

/** 根据颜色绘制图片 */
UIImage * WXCreateImageWithColor(UIColor *color);


#pragma mark -==================================多语言====================================

/** 获取多语言 */
NSString* WXLanguage(NSString *languageKey);

/** 获取指定国家的多语言 */
NSString* WXLanguageCountry(NSString *languageKey, NSString *countryCode);


#pragma mark -==================================颜色====================================

/** 获取白颜色 */
UIColor* WXColorWhite(void);

/** 获取RGB颜色 */
UIColor* WXColorRGB(NSInteger R, NSInteger G, NSInteger B, CGFloat a);

/** 获取十六进制颜色 */
UIColor* WXColorHex(NSInteger hexValue, CGFloat a);

/** 获取随机颜色 (调试时用到) */
UIColor* WXColorRandom(void);

/** 十六进制的颜色（以#/0X开头）转换为UIColor */
UIColor* colorWithHexString(NSString *colorString);



#pragma mark -==================================字体操作====================================

/** 获取系统粗体字 */
UIFont * WXFontBold(CGFloat size);

/** 获取系统粗体字 */
UIFont * WXFontSystem(CGFloat size);

/** 获取系统自定义字体 */
UIFont * WXFontCustom(NSString *fontName, CGFloat size);



#pragma mark -==================================HUD====================================

/** 获取弹框window */
UIWindow * WXFetchHUDSuperView(void);

/** 显示loading框现在window上禁止交互 */
void WXShowLoadingView(void);

/** 隐藏window上的loading框 */
void WXHideLoadingView(void);

/** 显示纯文本Toast展示 */
void WXShowToastWithText(NSString *message);

/** 系统菊花转圈 */
UIActivityIndicatorView * WXFetchIndicatorView(UIActivityIndicatorViewStyle style, UIColor *color);


#pragma mark -==================================字符串、对象====================================

/**  判断是否为NSDictionary */
BOOL WXJudgeNSDictionary(id obj);

/** 判断是否为NSArray */
BOOL WXJudgeNSArray(id obj);

/** 判断字符串是否为空 */
BOOL WXIsEmptyString(id obj);

/** 判断是否为NSString */
BOOL WXJudgeNSString(id obj);

/** 转化为NSString来返回，如果为数组或字典转为Json String返回, 其他对象则返回@"" */
NSString* WXToString(id obj);

///转换为字典
NSDictionary * WXToDictiontry(id objc);

///词典转换为字符串
NSString * WXDictionaryToJson(NSDictionary *dic);

/// 转成MD5字符串
NSString * WXToMD5String(NSString *originStr);



#pragma mark -==================================系统弹框操作====================================
/** 跳转到系统授权设置页面 */
void jumpApplicationOpenSetting(void);

/** 跳转到系统设置授权弹框 */
void openSystemPreferencesSetting(NSString *alerTitle);

/** 系统弹框 */
void showAlertController(NSString *title, NSString *message,
                         NSString *otherTitle, void(^otherBtnBlock)(void),
                         NSString *cancelTitle, void(^cancelBtnBlock)(void));


#pragma mark -==================================权限操作判断====================================

/** 相机是否可用 (1.没申请过权限 2.已申请且已关闭) */
BOOL isCanUseCamera(void);

/** 是否已经申请过相机权限 */
BOOL hasApplyCameraPermission(void);

/** 主动申请相机权限 */
void applyCameraPermission(void (^applyPermission)(BOOL));



/** 麦克风是否可用 (1.没申请过权限 2.已申请且已关闭) */
BOOL isCanUseMicrophone (void);

/** 是否已经申请过麦克风权限 */
BOOL hasApplyMicrophonePermission(void);

/** 主动申请麦克风权限 */
void applyMicrophonePermission(void (^applyPermission)(BOOL));






@end
