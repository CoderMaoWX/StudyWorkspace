//
//  WXMacroDefiner.h
//  ZXOwner
//Macro
//  Created by Luke on 2020/8/17.
//  Copyright © 2020 51zxwang. All rights reserved.
//

#ifndef WXMacroDefiner_h
#define WXMacroDefiner_h

#pragma mark -===========================系统版本号=============================
//系统版本号
#define kiOSSystemVersion               [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS67UP                         (kiOSSystemVersion >= 6.0)     // 大于等于IOS7的系统
#define IOS7UP                          (kiOSSystemVersion >= 7.0)     // 大于等于IOS7的系统
#define IOS8UP                          (kiOSSystemVersion >= 8.0)     // 大于等于IOS8的系统
#define IOS9UP                          (kiOSSystemVersion >= 9.0)     // 大于等于IOS9的系统
#define IOS103UP                        (kiOSSystemVersion >= 10.3)    // 大于等于IOS10.3的系统
#define IOS11UP                         (kiOSSystemVersion >= 11.0)    // 大于等于IOS11的系统
#define IOS13UP                         (kiOSSystemVersion >= 13.0)    // 大于等于IOS13的系统

#pragma mark -===========================其他相关宏=============================
// 版本号
#define ZXAppVersion                    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//获取 appdelegate
#define APPDELEGATE                     (AppDelegate *)[[UIApplication sharedApplication] delegate]


#pragma mark -==================================自定义Log====================================
#ifdef DEBUG
    // 判断是真机还是模拟器
    #if TARGET_OS_IPHONE
        //#define WXLog(fmt, ...) fprintf(stderr,"%s: %s [Line %d]\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);
        #define WXLog(fmt, ...) fprintf(stderr,"%s: [Line %d] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);

    #elif TARGET_IPHONE_SIMULATOR
        #define ZXLog(arg,...) //NSLog(@"%s " arg ,__PRETTY_FUNCTION__, ##__VA_ARGS__)
    #endif
#else
    #define WXLog(...)
    #define NSLog(format,...)
#endif


#pragma mark -==================================弱引用宏====================================
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


#pragma mark -==================================忽略警告====================================
//-忽略警告的宏-
#define ZXPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    _Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)


//-忽略警告的宏- eg: [obj respondsToSelector:@(xxx)]
#define ZXUndeclaredSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)


#pragma mark -=========================== 偏好设置快捷操作宏 =============================
//判空对象
#define isNull(obj)         (((NSNull *)obj == [NSNull null])?YES:NO)

/** 保存数据到偏好设置 */
#define ZXSaveUserDefault(key,Obj) \
({  if (!isNull(key) && key != nil) { \
    [[NSUserDefaults standardUserDefaults] setObject:Obj forKey:key]; \
    [[NSUserDefaults standardUserDefaults] synchronize]; } \
})
/** 获取偏好设置数据 */
#define ZXGetUserDefault(key)  key!=nil ? [[NSUserDefaults standardUserDefaults] objectForKey:key] : nil



#pragma mark -==================================通知相关====================================
//注册通知
#define ZXObserveNotification(notifyObserver, notifySelector, notifyName, notifyObject) \
[[NSNotificationCenter defaultCenter] addObserver:notifyObserver selector:notifySelector name:notifyName object:notifyObject]

/** 移除通知 */
#define ZXRemoveNotification(notifyObserver, notifyName, notifyObject) \
[[NSNotificationCenter defaultCenter] removeObserver:notifyObserver name:notifyName object:notifyObject]

/** 移除通知 */
#define ZXRemoveAllNotification(observer) \
[[NSNotificationCenter defaultCenter] removeObserver:observer]

/** 发送通知 */
#define ZXPostNotification(name, postObject) \
[[NSNotificationCenter defaultCenter] postNotificationName:name object:postObject]


#endif /* WXMacroDefiner_h */
