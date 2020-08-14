//
//  GFZNetworkPlugin.m
//  GFZNetwork
//
//  Created by 610582 on 2019/9/3.
//  Copyright © 2019 GFZ. All rights reserved.
//

#import "GFZNetworkPlugin.h"
#import "GFZNetworkConfig.h"
#import "GFZNetworkRequest.h"
#import <YYModel/YYModel.h>
#import <CommonCrypto/CommonCrypto.h>

NSString *const KGFZUploadAppsFlyerStatisticsKey    = @"KGFZUploadAppsFlyerStatisticsKey";
NSString *const KGFZRequestAbsoluteDateFormatterKey = @"yyyy-MM-dd-HHmmssSSS";
NSString *const kGFZRequestDataFromCacheKey         = @"GFZNetwork_DataFromCacheKey";
NSString *const KGFZRequestFailueTipMessage         = @"Loading failed, please try again later.";
NSString *const kGFZNetworkResponseCacheKey         = @"kGFZNetworkResponseCacheKey";
NSString *const KGFZRequestRequestArrayAssert       = @"❌❌❌批量数组的请求对象必须为GFZNetworkRequest类型";
NSString *const KGFZRequestRequestArrayObjAssert    = @"❌❌❌批量请求requestArray必须为数组对象";
NSString *const KGFZNetworkRequestDeallocDesc       = @"GFZNetworkRequest dealloc";
NSString *const KGFZNetworkBatchRequestDeallocDesc  = @"GFZNetworkBatchRequest dealloc";


@implementation GFZNetworkPlugin

/**
 上传网络日志到服装日志系统入口
 
 @param responseModel 响应模型
 @param request 请求对象
 */
+ (void)uploadNetworkResponseJson:(GFZResponseModel *)responseModel
                          request:(GFZNetworkRequest *)request
{
    if (responseModel.isCacheData) return;
    if ([GFZNetworkConfig sharedInstance].isDistributionOnlineRelease) return;
    if (![GFZNetworkConfig sharedInstance].uploadResponseJsonToLogSystem) return;
    
    NSString *uploadLogUrl = [GFZNetworkConfig sharedInstance].uploadRequestLogToUrl;
    if (![uploadLogUrl isKindOfClass:[NSString class]] || ![uploadLogUrl hasPrefix:@"http"]) return;
    
    NSString *catchLogTag = [GFZNetworkConfig sharedInstance].uploadCatchLogTagStr;
    if (![catchLogTag isKindOfClass:[NSString class]] || catchLogTag.length==0) return;
    
    NSDictionary *requestJson = request.finalParameters;
    if (request.finalParameters[KGFZUploadAppsFlyerStatisticsKey]) {
        if ([GFZNetworkConfig sharedInstance].closeStatisticsPrintfLog) {
            return ;
        } else {
            NSMutableDictionary *appsFlyerDict = [NSMutableDictionary dictionary];
            [appsFlyerDict addEntriesFromDictionary:requestJson];
            [appsFlyerDict removeObjectForKey:KGFZUploadAppsFlyerStatisticsKey];
            requestJson = appsFlyerDict;
        }
    }
    
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *appName =  bundleInfo[(__bridge NSString *)kCFBundleExecutableKey] ?: bundleInfo[(__bridge NSString *)kCFBundleIdentifierKey];
    NSString *version = bundleInfo[@"CFBundleShortVersionString"] ?: bundleInfo[(__bridge NSString *)kCFBundleVersionKey];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:KGFZRequestAbsoluteDateFormatterKey];
    
    NSString *logHeader = [self appendingPrintfLogHeader:responseModel request:request];
    NSString *logFooter = responseModel.responseDict.yy_modelToJSONString;
    NSString *body = [NSString stringWithFormat:@"%@%@", logHeader, logFooter];
    body = [body stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    
    NSMutableDictionary *uploadInfo = [NSMutableDictionary dictionary];
    uploadInfo[@"level"]            = @"iOS";
    uploadInfo[@"appName"]          = appName;
    uploadInfo[@"version"]          = version;
    uploadInfo[@"body"]             = body;
    uploadInfo[@"platform"]         = [NSString stringWithFormat:@"%@-iOS-%@", appName, catchLogTag];
    uploadInfo[@"device"]           = [[UIDevice currentDevice] model];
    uploadInfo[@"feeTime"]          = @(responseModel.responseDuration);
    uploadInfo[@"timestamp"]        = [formatter stringFromDate:[NSDate date]];
    uploadInfo[@"url"]              = request.requestUrl;
    uploadInfo[@"request"]          = requestJson;
    uploadInfo[@"requestHeader"]    = request.requestDataTask.originalRequest.allHTTPHeaderFields;
    uploadInfo[@"response"]         = responseModel.responseDict;
    uploadInfo[@"responseHeader"]   = responseModel.urlResponse.allHeaderFields;
    
    GFZBaseRequest *baseRequest = [[GFZBaseRequest alloc] init];
    baseRequest.requestUrl = uploadLogUrl;
    baseRequest.parameters = uploadInfo;
    [baseRequest requestWithBlock:nil failureBlock:nil];
}

/**
 打印日志头部
 
 @param responseModel 响应模型
 @param request 请求对象
 @return 日志头部字符串
 */
+ (NSString *)appendingPrintfLogHeader:(GFZResponseModel *)responseModel
                               request:(GFZNetworkRequest *)request
{
    BOOL isSuccess          = responseModel.isSuccess;
    BOOL isCacheData        = responseModel.isCacheData;
    NSString *requestJson   = [request valueForKey:@"parmatersJsonString"];
    NSString *hostTitle     = [GFZNetworkConfig sharedInstance].networkHostTitle ? : @"";
    NSDictionary *requestHeadersInfo = request.requestDataTask.originalRequest.allHTTPHeaderFields;
    NSString *successFlag   = isCacheData ? @"❤️❤️❤️" : (isSuccess ? @"✅✅✅" : @"❌❌❌");
    NSString *statusString  = isCacheData ? @"缓存数据成功" : (isSuccess ? @"网络数据成功" : @"网络数据失败");
    NSString *logBody = [NSString stringWithFormat:@"\n%@请求接口地址 %@= %@\n请求参数json=\n%@\n请求头信息: %@\n\n%@返回=\n",
                         successFlag, hostTitle, request.requestUrl,
                         requestJson, requestHeadersInfo, statusString];
    return logBody;
}

/**
 打印日志尾部
 
 @param responseModel 响应模型
 @return 日志头部字符串
 */
+ (NSString *)appendingPrintfLogFooter:(GFZResponseModel *)responseModel
{
    NSString *responseJson  = [responseModel.responseDict description];
    if ([responseModel.responseDict isKindOfClass:[NSDictionary class]]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseModel.responseDict options:NSJSONWritingPrettyPrinted error:nil];
        if (jsonData) {
            responseJson = [[NSString alloc] initWithData:jsonData encoding:(NSUTF8StringEncoding)];
        }
    }
    return responseJson;
}


#pragma mark - <ImageType>
/**
 * 上传时获取图片类型
 
 @param imageData 图片Data
 @return 图片类型描述数组
 */
+ (NSArray *)typeForImageData:(NSData *)imageData {
    uint8_t c;
    [imageData getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @[@"image/jpeg",@"jpg"];
        case 0x89:
            return @[@"image/png",@"png"];
        case 0x47:
            return @[@"image/gif",@"gif"];
        case 0x49:
        case 0x4D:
            return @[@"image/tiff",@"tiff"];
    }
    return nil;
}

/**
 MD5加密字符串

 @param string 需要MD5的字符串
 @return MD5后的字符串
 */
+ (NSString *)GFZMD5String:(NSString *)string {
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

@end

#pragma mark -===========请求转圈弹框===========
#define STATUSHEIGHT        [UIApplication sharedApplication].statusBarFrame.size.height
#define kHUDLoadingViewTag  1234

@implementation GFZNetworkHUD

/**
 * 请求时显示转圈
 */
+ (void)hideLoadingFromView:(UIView *)loadingSuperView {
    if (![loadingSuperView isKindOfClass:[UIView class]]) return;
    for (UIView *tempLoadingView in loadingSuperView.subviews) {
        if (tempLoadingView.tag == kHUDLoadingViewTag) {
            [tempLoadingView removeFromSuperview];
        }
    }
}

/**
 * 在指定的VIew上显示转圈请求
 */
+ (void)showLoadingToView:(UIView *)loadingSuperView {
    if (![loadingSuperView isKindOfClass:[UIView class]]) return;
    
    CGRect rect = loadingSuperView.bounds;
    CGFloat statusBarAndNavBarHeight = STATUSHEIGHT+44;
    CGFloat offsetHeight = statusBarAndNavBarHeight/2;
    
    UIWindow *window = nil;
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        window = delegate.window;
    } else {
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window makeKeyAndVisible];
    }
    CGFloat windowHeight = window.bounds.size.height;
    
    if ([loadingSuperView isEqual:window]) {
        rect = CGRectMake(0, statusBarAndNavBarHeight, rect.size.width, windowHeight-statusBarAndNavBarHeight);
        offsetHeight -= statusBarAndNavBarHeight/2;
    }
    //转圈时如果有Loading显示则先移除
    [GFZNetworkHUD hideLoadingFromView:loadingSuperView];
    
    //转圈背景蒙层
    UIView *maskBgView = [[UIView alloc] initWithFrame:rect];
    maskBgView.backgroundColor = [UIColor clearColor];
    maskBgView.tag = kHUDLoadingViewTag;
    [loadingSuperView addSubview:maskBgView];
    
    //自定义类动画View
    CGFloat customWidth = 72;
    Class loadingClass = [GFZNetworkConfig sharedInstance].requestLaodingCalss;
    
    if (loadingClass && [loadingClass isSubclassOfClass:[UIView class]] &&
        ![loadingClass isSubclassOfClass:[UIActivityIndicatorView class]]) {
        
        UIView *loadingView = [[loadingClass alloc] initWithFrame:CGRectMake(0, 0, customWidth, customWidth)];
        loadingView.center = CGPointMake(maskBgView.frame.size.width/2, maskBgView.frame.size.height/2 + offsetHeight);
        [maskBgView addSubview:loadingView];
        
    } else {
        //转圈蒙层
        CGFloat x = (maskBgView.bounds.size.width - customWidth) /2;
        CGFloat y = (maskBgView.bounds.size.height - customWidth) /2;
        if (windowHeight == loadingSuperView.bounds.size.height) {
            y -= offsetHeight;
        }
        UIView *indicatorBg = [[UIView alloc] initWithFrame:CGRectMake(x, y, customWidth, customWidth)];
        indicatorBg.layer.masksToBounds = YES;
        indicatorBg.layer.cornerRadius = 12;
        indicatorBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [maskBgView addSubview:indicatorBg];
        
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loadingView startAnimating];
        loadingView.center = CGPointMake(customWidth/2, customWidth/2);
        [indicatorBg addSubview:loadingView];
    }
}
@end

