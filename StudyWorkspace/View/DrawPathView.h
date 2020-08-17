//
//  DrawPathView.h
//  DrawDemo
//
//  Created by mao wangxin on 2017/6/4.
//  Copyright © 2017年 Luke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawPathView : UIView

/**
 *  开始绘制
 */
- (void)startDrawPath;


/**
 *  重新绘制
 */
- (void)afreshDrawPath;

/**
 *  轨迹运动
 */
- (void)moveLayerFromPath;

@end
