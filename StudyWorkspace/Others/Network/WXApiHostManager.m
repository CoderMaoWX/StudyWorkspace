//
//  WXApiHostManager.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "WXApiHostManager.h"
#import "WXPublicHeader.h"
#import "AppDelegate.h"
#import "WX_NetworkRequest.h"

static NSString *kCheckAppDevHostKey = @"kCheckAppDevHostKey";

@implementation WXApiHostManager

+ (void)initialize {
    if (AppEnvironmentType == 0) {
        NSNumber *number = WX_GetUserDefault(kCheckAppDevHostKey);
        if (number) {
            WX_SaveUserDefault(kCheckAppDevHostKey, number);
        }
    }
}

/**
 * 当前环境是否为开发环境
 */
+ (BOOL)isDevelopStatus {
    BOOL isDevHost = (AppEnvironmentType == 0);
    if (isDevHost) {
        isDevHost = [WX_GetUserDefault(kCheckAppDevHostKey) boolValue];
    }
    return isDevHost;
}

/**
 * 当前环境是否为线上环境
 */
+ (BOOL)isOnlineStatus {
    return [WXApiHostManager isDevelopStatus] ? NO : YES;
}

/**
 * App环境地址
 */
+ (NSString *)appBaseUR {
    if ([WXApiHostManager isDevelopStatus]) { //测试域名
        return @"http://app.ops.51zxwang.com/";
    } else { //线上域名
        return @"https://app.51zxwang.com/";
    }
}

/**
 * 警告: 非线上发布环境开发时才可以切换环境
 */
+ (void)changeLocalHost {
    NSMutableArray *btnTitles = [NSMutableArray array];
    NSString *devHost       = [self.class addTitle:@"测试环境" toArray:btnTitles];
    NSString *onLineHost    = [self.class addTitle:@"正式环境" toArray:btnTitles];
    NSString *downloadApp   = [self.class addTitle:@"下载App" toArray:btnTitles];
    
    WX_showAlertMultiple(@"切换环境", nil, btnTitles, ^(NSInteger buttonIndex, id buttonTitle) {
        if ([buttonTitle isKindOfClass:[NSAttributedString class]]) {
            buttonTitle = ((NSAttributedString *)buttonTitle).string;
        }
        
        if ([buttonTitle isEqualToString:devHost]) {
            WX_SaveUserDefault(kCheckAppDevHostKey, @(YES));
            WX_ShowToastWithText(nil, @"测试环境切换成功");
            [self showConvertHostAnimation];
            
        } else if ([buttonTitle isEqualToString:onLineHost]) {
            WX_SaveUserDefault(kCheckAppDevHostKey, @(NO));
            WX_ShowToastWithText(nil, @"正式环境切换成功");
            [self showConvertHostAnimation];
            
        } else if ([buttonTitle isEqualToString:downloadApp]) {
            [WXApiHostManager downloadTestApp];
        }
    }, @"取消", nil);
}

+ (id)addTitle:(id)title toArray:(NSMutableArray *)array {
    if ([title isKindOfClass:[NSString class]] && ((NSString *)title).length > 20) {
        title = [NSString stringWithFormat:@"%@...", [((NSString *)title) substringToIndex:20]];
    }
    if (([title isKindOfClass:[NSString class]] || [title isKindOfClass:[NSAttributedString class]])
        && [array isKindOfClass:[NSMutableArray class]]) {
        [array addObject:title];
        return title;
    }
    return nil;
}

/// 切换环境时添加一个翻转的转场动画
+ (void)showConvertHostAnimation {
    WXNetworkConfig *config = [WXNetworkConfig sharedInstance];
    config.isDistributionOnlineRelease      = [WXApiHostManager isOnlineStatus];
    config.networkHostTitle                 = [WXApiHostManager isOnlineStatus] ? @"线上环境" : @"测试环境";
    
    UIWindow *window = nil;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        window = delegate.window;
    } else {
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window makeKeyAndVisible];
    }
    
    BOOL oldState = [UIView areAnimationsEnabled];
    [UIView transitionWithView:window duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
        [UIView setAnimationsEnabled:NO];
        //[ZXAccountManager logoutClearData];
        
        //[delegate initAppRootVC];
        [UIView setAnimationsEnabled:oldState];
        
    } completion:^(BOOL finished) {
    }];
}

///下载测试包
+ (void)downloadTestApp {
    NSString *domain = @"pgyer";//为什么这么写,你懂的
    NSString *formater = [NSString stringWithFormat:@"https://www.%@.com/wyzx-owner", domain];
    NSURL *url = [NSURL URLWithString:formater];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        WX_Log(@"打开%@, 状态:%d", url, success);
    }];
}

@end
