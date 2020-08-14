//
//  GFZNetworkPlugin.h
//  GFZNetwork
//
//  Created by 610582 on 2019/9/3.
//  Copyright © 2019 GFZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class GFZResponseModel, GFZNetworkRequest;

FOUNDATION_EXPORT NSString *const KGFZUploadAppsFlyerStatisticsKey;
FOUNDATION_EXPORT NSString *const KGFZRequestAbsoluteDateFormatterKey;
FOUNDATION_EXPORT NSString *const kGFZRequestDataFromCacheKey;
FOUNDATION_EXPORT NSString *const kGFZNetworkResponseCacheKey;
FOUNDATION_EXPORT NSString *const KGFZRequestFailueTipMessage;
FOUNDATION_EXPORT NSString *const KGFZRequestRequestArrayAssert;
FOUNDATION_EXPORT NSString *const KGFZRequestRequestArrayObjAssert;
FOUNDATION_EXPORT NSString *const KGFZNetworkRequestDeallocDesc;
FOUNDATION_EXPORT NSString *const KGFZNetworkBatchRequestDeallocDesc;


#ifdef DEBUG
#define GFZNetworkLog( s, ... ) printf("%s\n",[[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String])
#else
#define GFZNetworkLog( s, ... )
#endif

@interface GFZNetworkPlugin : NSObject

/**
 上传网络日志到服装日志系统入口

 @param responseModel 响应模型
 @param request 请求对象
 */
+ (void)uploadNetworkResponseJson:(GFZResponseModel *)responseModel
                          request:(GFZNetworkRequest *)request;


/**
 打印日志头部

 @param responseModel 响应模型
 @param request 请求对象
 @return 日志头部字符串
 */
+ (NSString *)appendingPrintfLogHeader:(GFZResponseModel *)responseModel
                               request:(GFZNetworkRequest *)request;

/**
 打印日志尾部
 
 @param responseModel 响应模型
 @return 日志头部字符串
 */
+ (NSString *)appendingPrintfLogFooter:(GFZResponseModel *)responseModel;


/**
 * 上传时获取图片类型

 @param imageData 图片Data
 @return 图片类型描述数组
 */
+ (NSArray *)typeForImageData:(NSData *)imageData;

/**
 MD5加密字符串
 
 @param string 需要MD5的字符串
 @return MD5后的字符串
 */
+ (NSString *)GFZMD5String:(NSString *)string;

@end

#pragma mark -===========请求转圈弹框===========

@interface GFZNetworkHUD : UIView

/**
* 移除指定参数传进来的View
*/
+ (void)hideLoadingFromView:(UIView *)view;

/**
 * 请求时显示转圈
 */
+ (void)showLoadingToView:(UIView *)view;

@end
