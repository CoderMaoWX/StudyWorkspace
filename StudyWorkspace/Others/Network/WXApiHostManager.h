//
//  WXApiHostManager.h
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 一键切换App环境, (0️⃣:测试   1️⃣:线上)
 * 线上发版时直接改成1️⃣的Type, 切换到Release模式打包发布即可
 */
#define AppEnvironmentType                          1


@interface WXApiHostManager : NSObject

/**
 * 当前环境是否为线上环境
 */
+ (BOOL)isOnlineStatus;

/**
 * 当前环境是否为开发环境
 */
+ (BOOL)isDevelopStatus;


/**
 * App环境地址
 */
+ (NSString *)appBaseUR;

/**
 * 警告: 非线上发布环境开发时才可以切换环境
 */
+ (void)changeLocalHost;

@end
