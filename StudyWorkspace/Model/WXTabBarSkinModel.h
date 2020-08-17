//
//  OKTabBarSkinModel.h
//  OKCommonFrameWork
//
//  Created by mao wangxin on 2017/12/28.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXTabBarSkinModel : NSObject


/** tabBarItem的标题 */
@property (nonatomic, copy) NSString *tabBarItemTitle;

/** tabBarItem对应的navigationBar的背景图片 */
@property (nonatomic, strong) UIImage *navigationBarBackgroundImage;

/** tabBar的背景图片 */
@property (nonatomic, strong) UIImage *tabBarBackgroundImage;

/** tabBarItem的普通状态图片 */
@property (nonatomic, strong) UIImage *tabBarItemNormolImage;

/** tabBarItem状态选中的图片 */
@property (nonatomic, strong) UIImage *tabBarItemSelectedImage;

/** tabBarItem普通状态标题文字的颜色 */
@property (nonatomic, strong) UIColor *tabBarItemNormolTitleColor;

/** tabBarItem高亮状态标题文字的颜色 */
@property (nonatomic, strong) UIColor *tabBarItemSelectedTitleColor;

/** tabBarItem标题文字的上下偏移量 */
@property (nonatomic, assign) CGFloat tabBarItemTitleOffset;

/** tabBarItem标题图片的上下偏移量 */
@property (nonatomic, assign) CGFloat tabBarItemImageOffset;

@end
