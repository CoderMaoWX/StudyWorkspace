//
//  WXNavigationVC.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "WXNavigationVC.h"
#import "WXPublicHeader.h"
#import "WXStudyBaseVC.h"

@interface WXNavigationVC ()
@property (nonatomic, assign) BOOL prohibitPush;
@property (nonatomic, assign) BOOL prohibitPop;
@end

@implementation WXNavigationVC

+ (void)initialize {
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor whiteColor]];
    [navBar setTintColor:WX_ColorWhite()];
    [navBar setTitleTextAttributes:@{
        NSFontAttributeName: WX_FontBold(18),
        NSForegroundColorAttributeName:WX_ColorBlackTextColor()
    }];
    
    UIImage *backImage = [UIImage imageNamed:@"arrow_nav_left"];
    [navBar setBackIndicatorImage:backImage];
    [navBar setBackIndicatorTransitionMaskImage:backImage];

    //去导航线条
    [navBar setShadowImage:[UIImage new]];
    navBar.translucent = NO;
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
        barApp.backgroundColor = [UIColor whiteColor];
        barApp.shadowColor = [UIColor whiteColor];
        navBar.scrollEdgeAppearance = barApp;
        navBar.standardAppearance = barApp;
    }
    
    [WXNavigationVC setupViewAppearance];
}

+ (void)setupViewAppearance {
    
    // 将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin)
                                                         forBarMetrics:UIBarMetricsDefault];
    //全局禁止视图多指点击
    [[UIView appearance] setExclusiveTouch:YES];
    
    [UIView appearance].tintColor = WX_ColorMainColor();
    
    [UITextField appearance].tintColor = WX_ColorMainColor();

    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, kScreenWidth, kDefaultCellHeight);
    bgView.backgroundColor = WX_ColorBackgroundColor();
    [UITableViewCell appearance].selectedBackgroundView = bgView;
    
    //ScrollView偏移量
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.navigationBar.translucent = NO;
}

/**
 *  重写这个方法,能拦截所有的push操作
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.prohibitPush) {
        self.prohibitPush = NO;
        return;
    }
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    self.prohibitPush = animated;
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    if (animated) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            self.prohibitPush = NO;
        });
    }
    
    if (self.viewControllers.count > 1) {
        viewController.navigationItem.hidesBackButton = YES;
        id target = nil;
        if ([viewController isKindOfClass:[WXStudyBaseVC class]]) {
            target = viewController;
        }else{
            target = self;
        }
        UIImage *image = [[UIImage imageNamed:@"arrow_nav_left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:@selector(goBackAction)];
        leftBarItem.imageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        viewController.navigationItem.leftBarButtonItem = leftBarItem;
    }
}

- (void)goBackAction {
    [self popViewControllerAnimated:YES];
}

/** 拦截所有的pop操作 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.prohibitPop) {
        self.prohibitPop = NO;
        return nil;
    }
    self.prohibitPop = animated;
    
    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    if (animated) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            self.prohibitPop = NO;
        });
    }

    //父类从导航堆栈弹出时清楚必要的数据
    if ([vc isKindOfClass:[WXStudyBaseVC class]]) {
        [(WXStudyBaseVC *)vc clearBaseVCData];
    }
    return vc;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
