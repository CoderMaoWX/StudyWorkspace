//
//  WXDeeplinkManager.h
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import <Foundation/Foundation.h>

//跳转页面类型 (deeplink文档: https://docs.qq.com/sheet/DUmJJa2tGaExaSEls?tab=BB08J2)
typedef NS_ENUM(NSInteger, WXJumpActionType) {
    DeeplinkAction_Home                 =  1,   // 打开首页
    DeeplinkAction_Detail               =  2,   // 打开详情页
};

@interface WXDeeplinkModel : NSObject
@property (nonatomic, assign) WXJumpActionType action; // 跳转类型
@property (nonatomic, copy) NSString *url;  // 很多东西。(HTML5页面URL 或 频道id goodsId + wid,（不只是一个简单类型）
@property (nonatomic, copy) NSString *name; // 跳转后的标题
@end



@interface WXDeeplinkManager : NSObject

/**
 * 跳转Deeplink例子：taobao://open?params={"m_param" : {}, "source":"","url" : "100004293741","action" : "1","name":""}
 * 1.如果是taobao开头: 就用deeplink打开,
 * 2.http/https开头 :则打开webVC
*/
void WXOpenDeeplink(NSString *url, NSString *title);


@end

