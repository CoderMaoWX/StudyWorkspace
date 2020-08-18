//
//  UIView+WXExtension.h
//  StudyWorkspace
//
//  Created by mao wangxin on 16/12/26.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WXExtension)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;

@property (nonatomic,assign) CGFloat bottom;  //底部
@property (nonatomic,assign) CGFloat top;     //顶部
@property (nonatomic,assign) CGFloat left;    //左边
@property (nonatomic,assign) CGFloat right;   //右边
@property (nonatomic,assign) CGFloat width;   //宽度
@property (nonatomic,assign) CGFloat height;  //高度

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end
