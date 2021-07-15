//
//  WXWebViewVC.h
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "WXStudyBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXWebViewVC : WXStudyBaseVC

/// 禁止监听H5的标题 (必填: 加载URL)
@property (nonatomic, copy) NSString *webURL;

/// 禁止监听H5的标题 (默认为: NO)
@property (nonatomic, assign) BOOL forbidObserverTitle;

/// 禁止侧滑手势返回 (默认为: NO)
@property (nonatomic, assign) BOOL forbidSlidePopBack;

/// 点击返回按钮退出web页面回调
@property (nonatomic, copy) void(^webviewBackBlock)(void);

@end

NS_ASSUME_NONNULL_END
