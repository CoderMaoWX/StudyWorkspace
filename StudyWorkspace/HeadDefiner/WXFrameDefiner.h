//
//  WXFrameDefiner.h
//  StudyWorkspace
//
//  Created by mao wangxin on 2017/1/18.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#ifndef WXFrameDefiner_h
#define WXFrameDefiner_h

//----------------------公共尺寸类宏---------------------------

//系统UIableBar高度
//#define kTabbarHeight            49
//
////所有表格顶部空出10的间隙
//#define kTableViewTopSpace       10
//
////所有控件离屏幕边缘间距,(上下左右)
//#define KViewLineSpacing         15
//
////默认cell高度
//#define kDefaultCellHeight       44
//
////默认控件圆角度
//#define kDefaultCornerRadius     5
//
////系统导航高度(没有包含电池栏)
//#define kNavigationBarHeight     44
//
///** 全局分割线高度*/
//#define WXLineHeight            (0.5)
//
//#define isPhoneX                (([UIScreen mainScreen].bounds.size.height == 812.0)?YES:NO)
///** 判断iphoneX 底部间距*/
//#define kiphoneXHomeBarHeight   (isPhoneX ? 34 : 0)
//
///** 图片压缩率*/
//#define WXMaxPixelSize           (1/[UIScreen mainScreen].scale)
//
////获取屏幕宽度
//#define kScreenWidth             ([UIScreen  mainScreen].bounds.size.width)
//
////获取屏幕高度
//#define kScreenHeight            ([UIScreen mainScreen].bounds.size.height - kiphoneXHomeBarHeight)
//
////状态栏高度 (电池栏)
//#define kStatusBarHeight         ([UIApplication sharedApplication].statusBarFrame.size.height)
//
//// 除了状态栏的高度
//#define kExceptStatusBarHeight   (kScreenWidth - kStatusBarHeight)
//
///**< 导航栏和状态栏的高度*/
//#define kStatusBarAndNavigationBarHeight  (kNavigationBarHeight + kStatusBarHeight)




//----------------------公共尺寸类宏---------------------------

/** 所有控件离屏幕边缘间距 */
#define KMargin12                12

/** 默认控件圆角度 */
#define kCornerRadius8           8

/** 默认cell高度 */
#define kDefaultCellHeight       44

/** 全局分割线高度*/
#define kLineHeight              (1.0 / [UIScreen mainScreen].scale)

/** 图片压缩率*/
#define kMaxPixelSize            (1/[UIScreen mainScreen].scale)

/** 屏幕宽度 */
#define kScreenWidth             [UIScreen mainScreen].bounds.size.width

/** 屏幕高度 */
#define kScreenHeight            [UIScreen mainScreen].bounds.size.height

/** 是否为刘海 系列屏幕 */
#define isPhoneXSeries           (kScreenHeight >= 812.0f)

/** 刘海屏 底部安全间距 */
#define kBottomSafeAreaHeight    (isPhoneXSeries ? 34 : 0)

/** 刘海屏 顶部安全间距 */
#define kTopSafeAreaHeight       (isPhoneXSeries ? 44.0f : 20.0f)

/** 系统TabBar栏高度 */
#define kTabBarHeight            self.tabBarController.tabBar.bounds.size.height

/** 系统导航高度(不包含电池栏) */
#define kNavigationBarHeight     self.navigationController.navigationBar.frame.size.height

/** 状态栏高度 (电池栏) */
#define kStatusBarHeight         [UIApplication sharedApplication].statusBarFrame.size.height

/** 导航栏和状态栏的高度 */
#define kStatusAddNavBarHeight   (kNavigationBarHeight + kStatusBarHeight)

/** 除取状态栏剩余的屏幕总高度 */
#define kExceptStatusBarHeight   (kScreenWidth - kStatusBarHeight)

#endif /* WXFrameDefiner_h */
