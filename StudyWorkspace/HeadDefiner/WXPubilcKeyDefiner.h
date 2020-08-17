//
//  WXPubilcKeyDefiner.h
//  StudyWorkspace
//
//  Created by mao wangxin on 2017/1/18.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#ifndef WXPubilcKeyDefiner_h
#define WXPubilcKeyDefiner_h

//-------------------------------------------- 公共通用宏 --------------------------------------------

/** 登录后保存的用户ID, 保存的value为 NSString 类型*/
#define UserIDUserDefaultsKey               @"userId"

/** 数据库名称 */
#define kAppFMDBName                         @"WXDB.sqlite"

/** 钱币符号 */
#define kMoneySymbol                        @"￥"

/* 获取App版本号 */
#define XcodeAppVersion                     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/*  弱引用 */
#define WEAKSELF                            typeof(self) __weak weakSelf = self;
/*  强引用 */
#define STRONGSELF                          typeof(weakSelf) __strong strongSelf = weakSelf;

//定义UIImage对象，图片多次被使用到
#define ImageNamed(name)                    [UIImage imageNamed:name]

// 是否支持手势右滑返回
#define PopGestureRecognizerenabled(ret)    (self.navigationController.interactivePopGestureRecognizer.enabled = ret)

//获取 appdelegate
#define APPDELEGATE                         (AppDelegate *)[[UIApplication sharedApplication] delegate]

//默认数据加载失败
#define DefaultRequestError                 [NSError errorWithDomain:@"数据加载失败" code:502 userInfo:nil]


/*-------------------------------------------- 打印日志 --------------------------------------------*/

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

/*-------------------------------------------- 版本，屏幕，机型 --------------------------------------------*/

/** 判断是否 Retina屏 */
#define isRetina                            ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/** 获取iOS系统版本 */
#define kSystemVersion                      [[[UIDevice currentDevice] systemVersion] floatValue]

/** 判断版本是否大于等于变量 */
#define iOS7UP                              (kSystemVersion >= 7.0)
#define iOS8UP                              (kSystemVersion >= 8.0)
#define iOS9UP                              (kSystemVersion >= 9.0)
#define iOS10UP                             (kSystemVersion >= 10.0)
#define iOS11UP                             (kSystemVersion >= 11.0)

/*** 适配屏幕，判断机器型号 */
#define isiPhone4                           (([UIScreen mainScreen].bounds.size.height == 480.0)?YES:NO)
#define isiPhone5                           (([UIScreen mainScreen].bounds.size.height == 568.0)?YES:NO)
#define isiPhone6                           (([UIScreen mainScreen].bounds.size.height == 667.0)?YES:NO)
#define isiPhone6P                          (([UIScreen mainScreen].bounds.size.height == 736.0)?YES:NO)
#define isiPhoneX                           (([UIScreen mainScreen].bounds.size.height == 812.0)?YES:NO)


/*-------------------------------------------- 设置App字体 --------------------------------------------*/
//设置自定义细体字
#define FontCustomThinSize(fontSize)               [UIFont fontWithName:@"Heiti SC" size:fontSize]

//设置系统默认字体的大小
#define FontSystemSize(fontSize)                   [UIFont systemFontOfSize:fontSize]

//设置系统粗体字体
#define FontBoldSize(fontSize)                     [UIFont boldSystemFontOfSize:fontSize]

//自定义字体大小
#undef  FontCustomSize
#define FontCustomSize(fontName,fontSize)          ([UIFont fontWithName:fontName size:fontSize])


/*-------------------------------------------- 保存偏好设置 --------------------------------------------*/

//判空对象
#define isNull(obj)     (((NSNull *)obj == [NSNull null])?YES:NO)

/** 保存数据到偏好设置 */
#define SaveUserDefault(key,Obj) \
({  if (!isNull(key) && !isNull(Obj) && key != nil  && Obj != nil) { \
[[NSUserDefaults standardUserDefaults] setObject:Obj forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; } \
})

/** 获取偏好设置数据 */
#define GetUserDefault(key)  key!=nil ? [[NSUserDefaults standardUserDefaults] objectForKey:key] : nil


/*-------------------------------------------- 忽略警告的宏 --------------------------------------------*/
/**
 * 忽略警告的宏
 * 忽略警告的类型: [obj performSelector: withObject:]
 * 使用方式:
 WXPerformSelectorLeakWarning(
 [popTargetVC performSelector:selector withObject:nil];
 );
 */
#define WXPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#define WXUndeclaredSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


/*-------------------------------------------- 自定义对象实现NSCopy协议 --------------------------------------------*/

/**
 * 拷贝自定义对象,NSCopy协议的具体实现
 */
#define WXCopyImplementation \
- (id)copyWithZone:(NSZone *)zone \
{ \
Class clazz = [self class]; \
id model = [[clazz allocWithZone:zone] init]; \
[clazz mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {\
id obj = [self valueForKey:property.name];\
[model setValue:obj forKey:property.name];\
}];\
return model;\
}

//一个宏实现自定义对象的NSCopy协议
#define WXExtensionCopyImplementation  WXCopyImplementation



#endif /* WXPubilcKeyDefiner_h */
