//
//  WXNetworkRequest.h
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "WXNetworking.h"

@interface WX_NetworkRequest : WXNetworkRequest

/// 控制接口是否加公共参数
@property (nonatomic, assign) BOOL forbidPublicArgument;

@end
