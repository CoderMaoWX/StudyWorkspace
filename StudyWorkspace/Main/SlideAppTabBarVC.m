//
//  SlideAppTabBarVC.m
//  SlideApp
//
//  Created by mao wangxin on 2017/2/9.
//  Copyright © 2017年 Luke. All rights reserved.
//

#import "SlideAppTabBarVC.h"
#import "UIView+WXExtension.h"
#import "StudyMainVC.h"
#import "WXStudyBaseVC.h"
#import "WXTabBarSkinModel.h"
#import "WXPublicHeader.h"
#import "WXStudyTabBarVC2.h"
#import "WXStudyTabBarVC3.h"
#import "UITabBarController+WXConvertSkin.h"
#import "WXPublicHeader.h"

#define MaxOffsetX      (self.view.width-49)

@interface SlideAppTabBarVC ()<UIGestureRecognizerDelegate>
/** 单击右侧蒙板事件 */
@property (nonatomic, strong) UIControl *tapMaskControl;
/** TabBar起始Y */
@property (nonatomic, assign) CGFloat startTabBarY;
/** 左侧蒙版 */
@property (nonatomic, strong) UIView *leftMaskView;
/** 右侧蒙版 */
@property (nonatomic, strong) UIView *rightMaskView;
/** 夜间模式view */
@property (nonatomic, strong) UIView *nightsMaskView;
/** 是否已经打开侧滑 */
@property (nonatomic, assign) BOOL hasOpen;
@end

@implementation SlideAppTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化tabBar控制器
    [self initTabBarVCS];
    
    //添加边缘侧滑手势控制器
    [self addScreenPan];
}

#pragma mark - 初始化AppTabBar

- (void)initTabBarVCS {
    StudyMainVC *firstVC = [[StudyMainVC alloc] init];
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:firstVC];
    firstVC.tabBarItem = [self createTabBarItemWithTitle:@"Study1" imageName:@"icon_home1" selectedImage:@"icon_home2"];
    firstVC.title = @"Study1";
    firstVC.edgesForExtendedLayout = UIRectEdgeNone;
    
    firstVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开关" style:UIBarButtonItemStylePlain target:self action:@selector(converLeftViewAction:)];
    firstVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"夜间模式" style:UIBarButtonItemStylePlain target:self action:@selector(showAppMaskView:)];
    

    WXStudyTabBarVC2 *secondVc = [[WXStudyTabBarVC2 alloc] initWithNibName:@"WXStudyTabBarVC2" bundle:nil];
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:secondVc];
    secondVc.tabBarItem = [self createTabBarItemWithTitle:@"Study2" imageName:@"tabbar_shop_nor" selectedImage:@"tabbar_shop_ser"];
    secondVc.title = @"Study2";
    secondVc.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    WXStudyBaseVC *mineVC = [[WXStudyBaseVC alloc] init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineVC.tabBarItem = [self createTabBarItemWithTitle:@"Study3" imageName:@"tabbar_cashier_nor" selectedImage:@"tabbar_cashier_ser"];
    mineVC.title = @"Study3";
    mineVC.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    WXStudyBaseVC *tabBar3VC = [[WXStudyTabBarVC3 alloc] init];
    UINavigationController *tabBar3Nav = [[UINavigationController alloc] initWithRootViewController:tabBar3VC];
    tabBar3Nav.tabBarItem = [self createTabBarItemWithTitle:@"Study3" imageName:@"tabbar_cashier_nor" selectedImage:@"tabbar_cashier_ser"];
    tabBar3Nav.title = @"Study3";
    tabBar3Nav.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setViewControllers:@[firstNav, secondNav, mineNav, tabBar3Nav] animated:NO];
}

/**
 * 创建UITabBarItem
 */
- (UITabBarItem *)createTabBarItemWithTitle:(NSString *)title
                                  imageName:(NSString *)imageName
                              selectedImage:(NSString *)selectedImageName
{
    UIImage *norImage = [UIImage imageNamed:imageName];
    UIImage *serImage = [UIImage imageNamed:selectedImageName];
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:norImage selectedImage:serImage];
    return item;
}

#pragma mark - 添加App侧滑事件

- (UIView *)leftMaskView {
    if (!_leftMaskView) {
        _leftMaskView = [[UIView alloc] init];
        _leftMaskView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _leftMaskView.backgroundColor = [UIColor blackColor];
        _leftMaskView.alpha = 0.5;
        [self.parentViewController.view insertSubview:_leftMaskView atIndex:1];
    }
    return _leftMaskView;
}

- (UIView *)rightMaskView {
    if (!_rightMaskView) {
        _rightMaskView = [[UIView alloc] init];
        _rightMaskView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _rightMaskView.backgroundColor = [UIColor blackColor];
        _rightMaskView.alpha = 0.0;
        [self.view addSubview:_rightMaskView];
//        [self.view bringSubviewToFront:_rightMaskView];
    }
    return _rightMaskView;
}

/**
 * 是否打开左侧视图
 */
- (void)converLeftViewAction:(UIButton *)button {
    [self showLeftView:(self.view.x != MaxOffsetX)];
}

/**
 * 是否关闭左侧视图
 */
- (void)showLeftView:(BOOL)open {
    [UIView animateWithDuration:0.3 animations:^{
        if (open) { //打开侧滑
            self.view.x = MaxOffsetX;
            self.leftMaskView.alpha = 0.0;
            self.rightMaskView.alpha = 0.3;
            
            [self addTapAction:YES];
            
        } else { //关闭侧滑
            self.view.x = 0;
            self.leftMaskView.alpha = 0.5;
            self.rightMaskView.alpha = 0.0;
            
            [self addTapAction:NO];
        }
    } completion:^(BOOL finished) {
        self.hasOpen = open;
    }];
}

/**
 * 打开侧滑之后添加单击手势
 */
- (void)addTapAction:(BOOL)addTapGes {
    if (addTapGes) {
        //点击打开的右侧蒙板
        UIControl *control = [[UIControl alloc] initWithFrame:self.rightMaskView.frame];
        [control addTarget:self action:@selector(handeTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightMaskView addSubview:control];
        self.tapMaskControl = control;
        
    } else {
        [self.tapMaskControl removeTarget:self action:@selector(handeTap:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 单击手势
- (void)handeTap:(id)sender {
    if ((self.view.x == MaxOffsetX)) {
        //点击关闭侧滑
        [self showLeftView:NO];
    }
}

/**
 * 添加边缘侧滑手势控制器
 */
- (void)addScreenPan {
    //UIScreenEdgePanGestureRecognizer , UIPanGestureRecognizer
    //右侧边缘滑动手势
    UIScreenEdgePanGestureRecognizer *leftScreenPan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(mainSlideHandlePan:)];
    leftScreenPan.edges = UIRectEdgeLeft;
    leftScreenPan.delegate = self;
    [leftScreenPan setCancelsTouchesInView:YES];
    [self.view addGestureRecognizer:leftScreenPan];
    
    //右侧蒙版全屏滑动手势
    UIPanGestureRecognizer *rightMaskPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mainSlideHandlePan:)];
    rightMaskPan.delegate = self;
    [rightMaskPan setCancelsTouchesInView:YES];
    [self.rightMaskView addGestureRecognizer:rightMaskPan];
    
    //添加右侧边缘投影效果，有蒙版可不加投影
    [self.view.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.view.layer setShadowRadius:5];
    [self.view.layer setShadowOpacity:1];
    [self.view.layer setShadowColor:[UIColor colorWithWhite:0 alpha:0.48].CGColor];
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1, kScreenHeight)].CGPath;
}

#pragma mark - 滑动手势

//滑动手势
- (void)mainSlideHandlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture translationInView:self.view];
    
    if (self.hasOpen) {
        CGFloat percent = -point.x/(MaxOffsetX);
        self.view.x = MAX(MaxOffsetX + point.x, 0);
        
        self.leftMaskView.alpha = percent * 0.5;
        self.rightMaskView.alpha = 0.3 * (1-percent);
        
        //手势结束后修正位置,超过约一半时向多出的一半偏移
        if (gesture.state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:0.3 animations:^{
                [self showLeftView:(self.view.x > MaxOffsetX*0.85)];
            }];
        }
    } else {
        //屏幕宽度一半的百分比
        CGFloat percent = point.x/(self.view.width/2);
        self.view.x = MIN((MAX(point.x, 0)), MaxOffsetX);;
        
        self.leftMaskView.alpha = 0.5 * (1-percent);
        self.rightMaskView.alpha = 0.3 * (percent-1);
        
        //手势结束后修正位置,超过约一半时向多出的一半偏移
        if (gesture.state == UIGestureRecognizerStateEnded) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self showLeftView:(self.view.x > self.view.width/4)];
            }];
        }
    }
}

/** 夜间模式 */
- (void)showAppMaskView:(id)sender {
    self.nightsMaskView.hidden = !self.nightsMaskView.hidden;
}

- (UIView *)nightsMaskView {
    if (!_nightsMaskView) {
        _nightsMaskView = [[UIView alloc] init];
        _nightsMaskView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _nightsMaskView.backgroundColor = [UIColor blackColor];
        _nightsMaskView.alpha = 0.5;
        _nightsMaskView.hidden = YES;
        _nightsMaskView.userInteractionEnabled = NO;
        [self.view.window addSubview:_nightsMaskView];
        [self.view.window bringSubviewToFront:_nightsMaskView];
    }
    return _nightsMaskView;
}

/**
 * 设置tabBar默认主题图片
 */
- (void)setDefaultTabBarImages {
    NSArray *defaultImageArr = @[ZXImageName(@"tabbar_home_n"),ZXImageName(@"tabbar_property_n"),ZXImageName(@"tabbar_my_n")];
    NSLog(@"设置tabBar默认主题图片===%@",defaultImageArr);
    [self changeTabBarTheme:defaultImageArr newTheme:NO];
}

/** 更换主题 */
- (void)changeTabBarTheme:(NSArray <UIImage *> *)downloadIconArr newTheme:(BOOL)isNewTheme {
    NSArray *defaultTitleArray = @[@"首页",@"发现",@"我的",@"商品"];
    NSMutableArray *tabBarSkinModelArr = [NSMutableArray array];

    for (int i=0; i<downloadIconArr.count; i++) {
        if (i > (defaultTitleArray.count-1)) break;

        UIImage *iconImage = downloadIconArr[i];
        if (![iconImage isKindOfClass:[UIImage class]]) continue;

        WXTabBarSkinModel *infoModel = [[WXTabBarSkinModel alloc] init];

        infoModel.navigationBarBackgroundImage = isNewTheme ? [UIImage imageNamed:@"header_bg_ios7"] : nil;
        infoModel.tabBarBackgroundImage = isNewTheme ? [UIImage imageNamed:@"tabbar_bg_ios7"] : nil;
        infoModel.tabBarItemTitle = defaultTitleArray[i];
        infoModel.tabBarItemNormolImage = iconImage;
        infoModel.tabBarItemSelectedImage = iconImage;
        infoModel.tabBarItemNormolTitleColor = isNewTheme ? UIColorFromHex(0x282828) : [UIColor blackColor];;
        infoModel.tabBarItemSelectedTitleColor = isNewTheme ? UIColorFromHex(0xfe9b00) : UIColorFromHex(0x8CC63F);
        infoModel.tabBarItemTitleOffset = isNewTheme ? -10 : 0;
        infoModel.tabBarItemImageOffset = isNewTheme ? -20 : 0;

        [tabBarSkinModelArr addObject:infoModel];
    }
    [self convertTabBarWithSkinModel:tabBarSkinModelArr];
}

@end
