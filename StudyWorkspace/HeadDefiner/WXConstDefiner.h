//
//  WXConstDefiner.h
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#ifndef WXConstDefiner_h
#define WXConstDefiner_h


#pragma mark -======== App信息相关 ========
static NSString * const kAppDispalyName                 = @"";
static NSString * const kAppBundleID                    = @"";
static NSString * const kAppURLSchemes                  = @"taobao";
static NSString * const kAppStoreAppId                  = @"";//警告:上线后修改成真正的AppStore中的Appid
#define kAppStoreDownloadURL                            [NSString stringWithFormat:@"https://itunes.apple.com/us/app/%@/id%@?l=zh&ls=1&mt=8",kAppURLSchemes ,kAppStoreAppId] //AppStore下载地址


#pragma mark -======== 接口请求相关key ========
static NSString * const kRspStatusKey                   = @"code";
static NSString * const kRspStatusCode                  = @"200";
static NSString * const kRspMessageKey                  = @"msg";
static NSString * const kRspDataKey                     = @"data";
static NSString * const kRspListKey                     = @"list";
static NSString * const kRspFailDefaultMessage          = @"请求失败,请稍后重试";


#pragma mark -================ 设置页标题 ================
/** tabBar item标题key */
static NSString * const WXTabBarItemTitleKey            = @"WXTabBarItemTitleKey";
/** tabBar背景图片名字key */
static NSString * const WXTabBarBgImageKey              = @"WXTabBarBgImageKey";
/** tabBar普通状态图片名字key */
static NSString * const WXTabBarNormolImageKey          = @"WXTabBarNormolImageKey";
/** tabBar被选中状态图片名字key */
static NSString * const WXTabBarSelectedImageKey        = @"WXTabBarSelectedImageKey";
/** tabbar图片文件夹的目录 */
static NSString * const kWXabBarImagePathKey            = @"kWXabBarImagePathKey";

static NSString * const kLoadingView                    = @"kLoadingView";

static NSString * const kSavedLaunchImgKey              = @"kSavedLaunchImgKey";


#pragma mark -======== 公共通知相关 ========
/** 接口错误20003跳至登录页 */
static NSString *const kNeedLoginNotification           = @"kNeedLoginNotification";



#endif /* WXConstDefiner_h */
