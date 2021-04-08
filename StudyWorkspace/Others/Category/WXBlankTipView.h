//
//  WXBlankTipView.h
//  CommonFrameWork
//
//  Created by mao wangxin on 2016/11/24.
//  Copyright © 2016年 okdeer. All rights reserved.
//

#import <UIKit/UIKit.h>

//当前提示view在父视图上的tag
static NSInteger kBlankTipViewTag = 1990;

@interface WXBlankTipView : UIView

@property (nonatomic, strong) UIImage       *iconImage;     //图片名字
@property (nonatomic, strong) id            title;          //提示标题: NSString/NSAttributedString
@property (nonatomic, strong) id            subTitle;       //提示副标题: NSString/NSAttributedString
@property (nonatomic, strong) id            buttonTitle;    //按钮标题: NSString/NSAttributedString
@property (nonatomic, copy) void (^actionBtnBlcok)(void);   //点击按钮回调Block

/** 外部可控制整体View的中心点上下偏移位置 {0, 0}:表示上下居中显示, 默认居中显示 */
@property(nonatomic, assign) CGPoint contenViewOffsetPoint;

@property (nonatomic, strong, readonly) UIButton *actionBtn;

@end

