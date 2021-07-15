//
//  WXDeeplinkManager.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "WXDeeplinkManager.h"
#import "WXPublicHeader.h"
#import "UIViewController+WXExtension.h"
#import "WXWebViewVC.h"
#import "YYModel.h"

@implementation WXDeeplinkModel
@end

@implementation WXDeeplinkManager

/**
 * 跳转Deeplink例子：taobao://open?params={"m_param" : {}, "source":"","url" : "100004293741","action" : "1","name":""}
 * 1.如果是taobao开头: 就用deeplink打开,
 * 2.http/https开头 :则打开webVC
*/
void WXOpenDeeplink(NSString *url, NSString *title) {
    if (WX_isEmptyString(url)) return ;

    NSString *prefix = [NSString stringWithFormat:@"%@:", kAppURLSchemes];
    if ([url hasPrefix:prefix]) {
        if (![url containsString:@"params="])return;
        // 去除首尾空格和换行
        url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *paramsJson = [url componentsSeparatedByString:@"params="].lastObject;
        paramsJson = WX_DecodeString(paramsJson);
        WXDeeplinkModel *model = [WXDeeplinkModel yy_modelWithJSON:paramsJson];
        [WXDeeplinkManager doJumpWithDeeplinkModel:model];

    } else if ([url hasPrefix:@"http"]) {
        WXWebViewVC *webVC = [[WXWebViewVC alloc] init];
        webVC.webURL = WX_ToString(url);
        webVC.title = WX_ToString(title);
        UIViewController *currentVC = [UIViewController currentTopViewController];
        
        if (currentVC.navigationController) {
            [currentVC.navigationController pushViewController:webVC animated:YES];
            
        } else if (currentVC.presentingViewController) {
            currentVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentVC presentViewController:webVC animated:YES completion:NULL];
        }
    }
}

//跳转页面类型 (deeplink文档: https://docs.qq.com/sheet/DUmJJa2tGaExaSEls?tab=BB08J2)
+ (void)doJumpWithDeeplinkModel:(WXDeeplinkModel *)jumpModel {
    WXJumpActionType actionType    = jumpModel.action;
    NSString *url                = jumpModel.url;
    NSString *name               = jumpModel.name;
    
    UIViewController *currentVC = [UIViewController currentTopViewController];
    WX_Log(@"deeplink跳转类型: action=%ld, url=%@, name=%@", (long)actionType, url, name);
    
    switch (actionType) {
        case DeeplinkAction_Home:               // 1:打开首页
        {
            [currentVC.navigationController popToRootViewControllerAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                ((UITabBarController *)currentVC.view.window.rootViewController).selectedIndex = 0;
            });
        }
            break;
        case DeeplinkAction_Detail:            // 2:打开详情页
        {
        }
            break;
        default:
            break;
    }
}

@end
