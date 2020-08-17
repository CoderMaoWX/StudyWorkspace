//
//  WXTabBarInfoModel.h
//  ThemeSkinDemo
//
//  Created by mao wangxin on 2017/1/18.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXTabBarInfoModel : NSObject


/** tabBar item标题 */
@property (nonatomic, copy) NSString *tabBarItemTitle;

/** tabBar背景图片 */
@property (nonatomic, strong) UIImage *tabBarBgImage;

/** tabBar普通状态图片 */
@property (nonatomic, strong) UIImage *tabBarNormolImage;

/** tabBar被选中状态图片 */
@property (nonatomic, strong) UIImage *tabBarSelectedImage;

/** tabBar普通状态标题文字颜色 */
@property (nonatomic, strong) UIColor *tabBarNormolTitleColor;

/** tabBar被选中状态标题文字颜色 */
@property (nonatomic, strong) UIColor *tabBarSelectedTitleColor;

/** tabBar标题文字上下偏移量 */
@property (nonatomic, assign) CGFloat tabBarTitleOffset;

/** tabBar标题图片上下偏移量 */
@property (nonatomic, assign) CGFloat tabBarImageOffset;

@end
