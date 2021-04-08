//
//  ZXCFunctionTool.h
//  ZXOwner
//
//  Created by Luke on 2020/8/17.
//  Copyright © 2020 51zxwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ZXCFunctionTool : NSObject

/** 获取直播SDK版本 */
NSString* ZXBundleVersion(void);

/** 统一获取图片方法 */
UIImage* ZXImageName(NSString *imageName);

/** 给图片设置颜色 */
UIImage* ZXConvertImageColor(UIImage *image, UIColor *color);

/// 高斯模糊图片
UIImage* ZXImageBlurry(UIImage *originImage, CGFloat blurLevel);

/** 根据颜色绘制图片 */
UIImage * ZXCreateImageWithColor(UIColor *color);


#pragma mark -==================================多语言====================================

/** 获取多语言 */
NSString* WXLanguage(NSString *languageKey);

/** 获取指定国家的多语言 */
NSString* WXLanguageCountry(NSString *languageKey, NSString *countryCode);


#pragma mark -==================================颜色====================================

/** 获取白颜色 */
UIColor* ZXColorWhite(void);

/** 线条颜色 */
UIColor* ZXColorLineColor(void);

/** 黑色字体颜色:4A4A4A */
UIColor* ZXColorBlackTextColor(void);

/** App主黄色: F29448 */
UIColor* ZXColorMainColor(void);

/** 获取RGB颜色 */
UIColor* ZXColorRGB(NSInteger R, NSInteger G, NSInteger B, CGFloat a);

/** 获取十六进制颜色 */
UIColor* ZXColorHex(NSInteger hexValue);

/** 获取十六进制颜色, a:透明度 */
UIColor* ZXColorHex_a(NSInteger hexValue, CGFloat a);

/** 获取随机颜色 (调试时用到) */
UIColor* ZXColorRandom(void);

/** 十六进制的颜色（以#/0X开头）转换为UIColor */
UIColor* colorWithHexString(NSString *colorString);



#pragma mark -==================================字体操作====================================

/** 获取系统粗体字 */
UIFont* ZXFontSystem(CGFloat size);

/** 获取系统粗体字 */
UIFont* ZXFontBold(CGFloat size);

/** 获取系统自定义字体 */
UIFont* ZXFontCustom(NSString *fontName, CGFloat size);

/** 数字等宽字体 (eg: 倒计时数字不抖动) */
UIFont* ZXFontMonospacedDigit(CGFloat size);


#pragma mark -==================================HUD====================================

/** 显示loading框现在window上禁止交互 */
void ZXShowLoadingToView(id parmaters);

/** 隐藏window上的loading框 */
void ZXHideLoadingFromView(id parmaters);

/** 显示纯文本Toast展示 */
void ZXShowToastWithText(id parmaters, NSString *message);

/** 系统菊花转圈 */
UIActivityIndicatorView * ZXFetchIndicatorView(UIActivityIndicatorViewStyle style, UIColor *color);


#pragma mark -==================================字符串、对象====================================

/**  判断是否为NSDictionary */
BOOL ZXJudgeNSDictionary(id obj);

/** 判断是否为NSArray */
BOOL ZXJudgeNSArray(id obj);

/** 判断字符串是否为空 */
BOOL ZXIsEmptyString(id obj);

/** 判断是否为NSString */
BOOL ZXJudgeNSString(id obj);

/** 转化为NSString来返回，如果为数组或字典转为Json String返回, 其他对象则返回@"" */
NSString* ZXToString(id obj);

/// 格式化字符串
NSString* ZXFormatString(NSString *format, ...);

///转换为字典
NSDictionary* ZXToDictiontry(id objc);

///词典转换为字符串
NSString* ZXDictionaryToJson(NSDictionary *dic);

/// 转成MD5字符串
NSString* ZXToMD5String(NSString *originStr);


///时间戳变为格式时间
NSString *ZXConvertTimeStamp(NSTimeInterval timeStamp, NSString *dateFormat);


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

    
#pragma mark -==================================系统弹框操作====================================
/** 跳转到系统授权设置页面 */
void jumpApplicationOpenSetting(void);

/** 跳转到系统设置授权弹框 */
void openSystemPreferencesSetting(NSString *alerTitle);

/** 系统弹框 */
void showAlertController(NSString *title, NSString *message,
                         NSString *otherTitle, void(^otherBtnBlock)(void),
                         NSString *cancelTitle, void(^cancelBtnBlock)(void));

/**
 *  字符串编码
 *  @param originStr 源字符串
 *  @param reservedSymbol 是否保留特殊字符不编码
 */
NSString *ZXCodingString(NSString *originStr, BOOL reservedSymbol);

/**
 *  字符串解码
 */
NSString *ZXDecodeString(NSString *originStr);


#pragma mark -==================================播放系统声音====================================

/**
 * 播放系统声音: http://iphonedevwiki.net/index.php/AudioServices
 */
- (void)playSystemSound:(UInt32)soundID;


/** 修复一个奇葩的bug: (方法2)
*  场景: 偶现的发现在修改完storyboard中的启动图logo后, 可能会在不同机型上出现启动图logo黑屏的问题,
*  在网上找了很多方法后尝试无果, 后面尝试删除沙盒目录下的启动图的截屏文件夹能解决此问题.
*  备注: 经过测试,在删除后 启动时系统都会去检查沙盒目录下是否有此文件夹,没有则再次生成
*/
BOOL replaceCacheLibraryLaunchImage(UIImage *newImage);

/**
 * 获取沙盒的启动图
 * iOS13以下系统启动图截屏文件保存目录: ~/Library/Caches/Snapshots/com.xxx.xxx/xxxx@2x.ktx
 * iOS13及以上系统启动图截屏文件保存目录: ~/Library/SplashBoard/Snapshots/com.xxx.xxx - {DEFAULT GROUP}/xxxx@3x.ktx
 * */
UIImage *fetchLaunchImage(void);

@end
