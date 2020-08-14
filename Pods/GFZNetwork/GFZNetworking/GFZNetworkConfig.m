//
//  GFZNetworkConfig.m
//  GFZNetwork
//
//  Created by 610582 on 2019/8/27.
//  Copyright © 2019 GFZ. All rights reserved.
//

#import "GFZNetworkConfig.h"
#import <YYCache/YYCache.h>
#import "GFZNetworkPlugin.h"
#import "GFZNetworkRequest.h"

static GFZNetworkConfig *_instance;

@interface GFZNetworkConfig ()
/** 取请求缓存时的YYChache对象, 因为在保存时采用异步保存m,因此需要用单例保存当前对象 */
@property (nonatomic, strong, readwrite) YYDiskCache *networkDiskCache;
@end

@implementation GFZNetworkConfig

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.closeUrlResponsePrintfLog = YES;
        _instance.closeStatisticsPrintfLog = YES;
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

#pragma mark -===========请求库配置类设置默认值===========

/**
 * 设置默认的请求成功状态标识key
 */
- (NSString *)statusKey {
    if (!_statusKey) {
        _statusKey = @"status";
    }
    return _statusKey;
}

/**
 * 设置默认的请求成功状态码
 */
- (NSString *)statusCode {
    if (!_statusCode) {
        _statusCode = @"200";
    }
    return _statusCode;
}

/**
 * 需要单独解析Model时的key,(可选)
 */
- (NSString *)resultKey {
//    if (!_resultKey) {
//        _resultKey = @"result";
//    }
    return _resultKey;
}

/**
 * 设置默认的请求提示标识key
 */
- (NSString *)messageKey {
    if (!_messageKey) {
        _messageKey = @"msg";
    }
    return _messageKey;
}

- (YYDiskCache *)networkDiskCache {
    if (!_networkDiskCache) {
        NSString *userDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *directryPath = [userDocument stringByAppendingPathComponent:kGFZNetworkResponseCacheKey];
        _networkDiskCache = [[YYDiskCache alloc] initWithPath:directryPath];
    }
    return _networkDiskCache;
}

- (void)clearGFZNetworkAllRequestCache {
    [[YYCache cacheWithName:kGFZNetworkResponseCacheKey] removeAllObjects];
}

- (void)clearGFZNetworkCacheOfRequest:(GFZNetworkRequest *)serverApi {
    [self.networkDiskCache removeObjectForKey:serverApi.cacheKey];
}

@end
