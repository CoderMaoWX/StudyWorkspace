//
//  ChartLineInfoView.h
//  YDGJ
//
//  Created by mao wangxin on 16/9/20.
//  Copyright © 2016年 Galaxy360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartLineInfoView : UIView

/**
 *  根据数据绘图
 *
 *  @param frame               页面尺寸
 *  @param lineColor           线条颜色
 *  @param leftScaleValueArr   左边y轴刻度
 *  @param bottomScaleValueArr 部刻x轴刻度
 *  @param lineDataArr         统计数值
 *
 *  @return 统计图View
 */
- (instancetype)initWithFrame:(CGRect)frame lineColor:(UIColor *)lineColor leftScaleValueArr:(NSArray *)leftScaleValueArr bottomScaleValueArr:(NSArray *)bottomScaleValueArr lineDataArr:(NSArray *)lineDataArr;

@end
