//
//  UITabBarController+WXConvertSkin.h
//  OKCommonFrameWork
//
//  Created by mao wangxin on 2017/12/28.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXTabBarInfoModel.h"
#import "WXTabBarSkinModel.h"

#define kTabBarVCNameKey                  	@"kTabBarVCNameKey"
#define kTabBarVCTitleKey                 	@"kTabBarVCTitleKey"
#define kTabBarItemNormolImageKey           @"kTabBarItemNormolImageKey"
#define kTabBarItemSelectedImageKey         @"kTabBarItemSelectedImageKey"
#define	kTabBarItemNormolColorKey			@"kTabBarItemNormolColorKey"
#define	kTabBarItemSelectedColorKey			@"kTabBarItemSelectedColorKey"

@interface UITabBarController (OKConvertSkin)

#pragma mark =========================================切换主题===========================================

/**
 * 初始化TabBar
 */
- (void)setupOkTabBarSkin;

/**
 * 换肤
 */
- (void)convertTabBarWithSkinModel:(NSArray <WXTabBarSkinModel *> *)skinModelArr;

#pragma mark =============================添加UITabBarController子控制器======================================

/**
 * 添加UITabBarController子控制器
 */
- (void)setupTabBarVCAndItemInfo:(NSArray <NSDictionary *>*)vcAndItemInfoArr;

@end
