//
//  WXNetworkRequest.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "WX_NetworkRequest.h"
#import "WXPublicHeader.h"

@interface WX_NetworkRequest ()
///警告: 这个不能删除, 防止底层每次调用get方法生成的json都一样
@property (nonatomic, strong) NSDictionary *zxParameters;
@end


@implementation WX_NetworkRequest

@synthesize requestUrl          = _requestUrl;
@synthesize parameters          = _parameters;
@synthesize requestHeaderDict   = _requestHeaderDict;


///配置网络请求公共信息
+ (void)initialize {
    WXNetworkConfig *config = [WXNetworkConfig sharedInstance];
    config.statusKey                        = kRspStatusKey;
    config.statusCode                       = kRspStatusCode;
    config.messageKey                       = kRspMessageKey;
    config.customModelKey                   = kRspDataKey;
    config.requestFailDefaultMessage        = kRspFailDefaultMessage;//请求失败时的默认接口提示信息
    config.isDistributionOnlineRelease      = NO;
    config.networkHostTitle                 = YES ? @"线上环境" : @"测试环境";
    config.errorCodeNotifyDict              = @{ kNeedLoginNotification : @(20003)};
    config.closeUrlResponsePrintfLog        = NO;
    config.showRequestLaoding               = YES;
}

- (NSDictionary *)parameters {
    if (_forbidPublicArgument) {
        return _parameters;
    }
    if (!_zxParameters) {
        NSMutableDictionary *fullParmaters = [NSMutableDictionary dictionary];
        fullParmaters[@"user_id"]           = WX_ToString(@"USERID");
        fullParmaters[@"access_token"]      = WX_ToString(@"access_token");
        fullParmaters[@"version"]           = WX_ToString(@"ZXAppVersion");
        fullParmaters[@"app_type"]          = @"iOS";
        fullParmaters[@"city"]              = (WX_GetUserDefault(@"kUserSelectedCountryKey")) ?: @"shenzhen";
        // add more parameter...
        
        if (_parameters) {
            [fullParmaters addEntriesFromDictionary:_parameters];
        }
        _zxParameters = fullParmaters;
    }
    return _zxParameters;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderDict {
    if (!_requestHeaderDict) {
        NSString *token = [NSString stringWithFormat:@"%@asdfg12345", WX_ToString(self.parameters)];
        _requestHeaderDict = @{@"token" : WX_ToMD5String(token)};
    }
    return _requestHeaderDict;
}

@end
