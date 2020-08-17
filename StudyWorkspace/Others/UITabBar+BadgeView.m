//
//  UITabBar+BadgeView.m
//  CommonFrameWork
//
//  Created by mao wangxin on 2016/12/25.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "UITabBar+BadgeView.h"
#import <objc/runtime.h>

//小红点大小
#define kRoundBadgeViewSize         8.0

static char const * const kRoundBadgeIndexKey = "kRoundBadgeIndexKey";

@implementation UITabBar (BadgeView)

//显示小红点
- (void)showBadgeOnItemIndex:(int)index
{
    if (index > self.items.count) return;
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    objc_setAssociatedObject(self, kRoundBadgeIndexKey, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = kRoundBadgeViewSize/2;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    
    //设置小红点的位置
    CGRect tabFrame = self.frame;
    float percentX = (index +0.6) / MAX(self.items.count, 1);//TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, kRoundBadgeViewSize, kRoundBadgeViewSize);//圆形大小为10
    [self addSubview:badgeView];
}

/**
 * 移除小红点
 */
- (void)removeBadgeOnItemIndex:(int)index
{
    if (index > self.items.count) return;
   
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

/**
 * 刷新添加的小红点
 */
- (void)refreshTabBarRoundView
{
    NSNumber *oldIndexNum = objc_getAssociatedObject(self, kRoundBadgeIndexKey);
    
    if (oldIndexNum) {
        //重新添加之前的小红点
        [self showBadgeOnItemIndex:[oldIndexNum intValue]];
    }
}

@end
