//
//  SlideAppTabBarVC.h
//  SlideApp
//
//  Created by mao wangxin on 2017/2/9.
//  Copyright © 2017年 Luke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideAppTabBarVC : UITabBarController

/**
 * 设置默认tabBar主题图片
 */
- (void)setDefaultTabBarImages;

/**
 * 是否关闭左侧视图
 */
- (void)showLeftView:(BOOL)open;

/**
 * 更换主题
 */
- (void)changeTabBarTheme:(NSArray <UIImage *> *)downloadIconArr newTheme:(BOOL)isNewTheme;


@end
