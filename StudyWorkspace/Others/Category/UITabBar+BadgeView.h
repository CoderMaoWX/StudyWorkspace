//
//  UITabBar+BadgeView.h
//  CommonFrameWork
//
//  Created by mao wangxin on 2016/12/25.
//  Copyright © 2016年 Demo. All rights reserved.
//  给系统的UITabBarItem添加小红点

#import <UIKit/UIKit.h>

@interface UITabBar (BadgeView)

//显示小红点
- (void)showBadgeOnItemIndex:(int)index;

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index;

/** 刷新添加的小红点 */
- (void)refreshTabBarRoundView;

@end
