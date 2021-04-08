//
//  UITabBarController+WXConvertSkin.m
//  OKCommonFrameWork
//
//  Created by mao wangxin on 2017/12/28.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "UITabBarController+WXConvertSkin.h"
#import "WXPublicHeader.h"
#import "WXTabBarInfoModel.h"
#import <objc/runtime.h>

#pragma mark =============================自定义UITabBar======================================

@interface WXAppSkinTabBar : UITabBar

/** 重复点击tabBar回调 */
@property (nonatomic, copy) void (^repeatTouchDownItemBlock)(UITabBarItem *item);
/** 更换TabBar图片 */
- (void)setTabBarItemImages:(NSArray <WXTabBarSkinModel *> *)skinModelArr;
@end

@implementation WXAppSkinTabBar

- (void)layoutSubviews
{
	[super layoutSubviews];

	NSInteger index = 0;
	for (UIControl *button in self.subviews) {
		if (![button isKindOfClass:[UIControl class]]) continue;
		button.tag = index;

		// 增加索引
		index++;
		//添加双击事件
		[button addTarget:self action:@selector(repeatClickButton:) forControlEvents:UIControlEventTouchDownRepeat];
	}

	//消除TabBar顶部细线
	[self hideTabBarTopLine];
}

/**
 * 消除TabBar顶部细线
 */
- (void)hideTabBarTopLine
{
	for (UIView *tempView in self.subviews) {
		if ([tempView isKindOfClass:[NSClassFromString(@"_UIBarBackground") class]]) {

			for (UIView *tempSubView in tempView.subviews) {
				if ([tempSubView isKindOfClass:[UIImageView class]]) {
					tempSubView.backgroundColor = [UIColor clearColor];
				}
			}
		}
	}
}

#pragma mark - 添加tabbar双击事件

/**
 * 双击tabbar按钮事件
 */
- (void)repeatClickButton:(UIControl *)button
{
	if (self.items.count>button.tag) {
		if (self.repeatTouchDownItemBlock) {
			UITabBarItem *touchItem = self.items[button.tag];
			self.repeatTouchDownItemBlock(touchItem);
		}
	}
}

#pragma mark - 设置tabbar图片

/**
 * 更换TabBar主题图片
 */
- (void)setTabBarItemImages:(NSArray <WXTabBarSkinModel *> *)skinModelArr
{
	if (skinModelArr.count < self.items.count) return;

	for (int i=0; i<skinModelArr.count; i++) {

		WXTabBarSkinModel *skinModel = skinModelArr[i];
		if (![skinModel isKindOfClass:[WXTabBarSkinModel class]]) continue;

		if (i > (self.items.count-1)) break;
		UITabBarItem *item = self.items[i];

		//背景图片
		UIImage *bgImage = skinModel.tabBarBackgroundImage;
		if ([bgImage isKindOfClass:[UIImage class]]) {
			self.backgroundImage = [bgImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		} else {
			self.backgroundImage = nil;
		}

		//Item标题
		NSString *itemTitle = skinModel.tabBarItemTitle;
		if ([itemTitle isKindOfClass:[NSString class]]) {
			item.title = itemTitle;
		}

		//普通状态图片
		UIImage *normolImage = skinModel.tabBarItemNormolImage;
		if ([normolImage isKindOfClass:[UIImage class]]) {
			item.image = [normolImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		}

		//选中状态图片
		UIImage *selectedImage = skinModel.tabBarItemSelectedImage;
		if ([selectedImage isKindOfClass:[UIImage class]]) {
			item.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		}

		//普通状态标题文字颜色
		UIColor *normolTitleColor = skinModel.tabBarItemNormolTitleColor;
		if ([normolTitleColor isKindOfClass:[UIColor class]]) {
			[item setTitleTextAttributes:@{NSForegroundColorAttributeName:normolTitleColor} forState:UIControlStateNormal];
		}

		//选中状态标题文字颜色
		UIColor *selectedTitleColor = skinModel.tabBarItemSelectedTitleColor;
		if ([selectedTitleColor isKindOfClass:[UIColor class]]) {
			[item setTitleTextAttributes:@{NSForegroundColorAttributeName:selectedTitleColor} forState:UIControlStateSelected];
		}

		/** 设置标题和图片偏移量 */
		item.titlePositionAdjustment = UIOffsetMake(0, skinModel.tabBarItemTitleOffset);
		item.imageInsets = UIEdgeInsetsMake(skinModel.tabBarItemImageOffset, 0, -skinModel.tabBarItemImageOffset, 0);
	}
}

@end

#pragma mark =========================================切换主题===========================================

@interface UITabBarController ()
@property (nonatomic, strong) WXAppSkinTabBar *appTabBar;
@end

@implementation UITabBarController (WXConvertSkin)

/**
 * 初始化TabBar
 */
- (void)setupOkTabBarSkin
{
	if (!self.appTabBar) {
		self.appTabBar = [[WXAppSkinTabBar alloc] initWithFrame:self.tabBar.bounds];
        @weakify(self)//监听重复点击tabBar回调
        [self.appTabBar setRepeatTouchDownItemBlock:^(UITabBarItem *item) {
            @strongify(self)
			[self didRepeatTouchDownTabBarItem:item];
		}];

		[self setValue:self.appTabBar forKeyPath:@"tabBar"];
	}
}

#pragma mark - 监听tabBar双击事件

/**
 * 监听重复点击tabBar按钮事件
 */
- (void)didRepeatTouchDownTabBarItem:(UITabBarItem *)item
{
	NSLog(@"重复点击tabBar按钮事件, 页面上可监听 repeatTouchTabBarToViewController:方法处理相应逻辑");
	NSInteger touchIndex = [self.tabBar.items indexOfObject:item];
	if (self.viewControllers.count > touchIndex) {
		UIViewController *touchItemVC = self.viewControllers[touchIndex];

		if ([touchItemVC isKindOfClass:[UINavigationController class]]) {
			touchItemVC = [((UINavigationController *)touchItemVC).viewControllers firstObject];
		}
		//忽略警告
		WX_UndeclaredSelectorLeakWarning(
			if ([touchItemVC respondsToSelector:@selector(repeatTouchTabBarToViewController:)]) {
				[touchItemVC performSelector:@selector(repeatTouchTabBarToViewController:) withObject:touchItemVC];
			}
		);
	}
}

#pragma mark - ========== 自定义TabBar ==========

- (void)setAppTabBar:(WXAppSkinTabBar *)appTabBar
{
	objc_setAssociatedObject(self, "WXAppSkinTabBar", appTabBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WXAppSkinTabBar *)appTabBar
{
	return objc_getAssociatedObject(self, "WXAppSkinTabBar");
}

/**
 * 换肤UITabBar 和 UINavgationBar
 */
- (void)convertTabBarWithSkinModel:(NSArray <WXTabBarSkinModel *> *)skinModelArr
{
	//防止首次调用为空对象,则初始化TabBar
	[self setupOkTabBarSkin];

	//更换TabBar主题图片
	[self.appTabBar setTabBarItemImages:skinModelArr];

	//更换UINavgationBar主题图片
	[self setupNavgatioBarTheme:skinModelArr];
}

/**
 * 更换UINavgationBar主题图片
 */
- (void)setupNavgatioBarTheme:(NSArray <WXTabBarSkinModel *> *)skinModelArr
{
	for (int i=0; i<skinModelArr.count; i++) {
		WXTabBarSkinModel *model = skinModelArr[i];

		if (i > (self.viewControllers.count-1)) break;
		UIViewController *touchItemVC = self.viewControllers[i];

		UIImage *navBgImae = model.navigationBarBackgroundImage;
		if ( navBgImae && ![navBgImae isKindOfClass:[UIImage class]] ) break;

		if ([touchItemVC isKindOfClass:[UINavigationController class]]) {

			UINavigationBar *navBar = ((UINavigationController *)touchItemVC).navigationBar;

			[navBar setBackgroundImage:navBgImae forBarMetrics:UIBarMetricsDefault];

		} else if ([touchItemVC isKindOfClass:[UIViewController class]]) {
			NSLog(@"此控制器没有导航栏,不必设置导航背景图");
		}
	}
}

#pragma mark =============================添加UITabBarController子控制器======================================

/**
 * 添加UITabBarController子控制器
 */
- (void)setupTabBarVCAndItemInfo:(NSArray <NSDictionary *>*)vcAndItemInfoArr
{
	for (NSDictionary *infoDic in vcAndItemInfoArr) {

		// 设置控制器起始位置和标题
		NSString *vcName = infoDic[kTabBarVCNameKey];
		UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
		if (![vc isKindOfClass:[UIViewController class]]) continue;

		UINavigationController *nav = [[NSClassFromString(@"OKBaseNavigationVC") alloc] initWithRootViewController:vc];
		if (![nav isKindOfClass:[UINavigationController class]]) {
			nav = [[UINavigationController alloc] initWithRootViewController:vc];
		}

		//设置控制器标题
		NSString *vcTitle = infoDic[kTabBarVCTitleKey];
		if ([vcTitle isKindOfClass:[NSString class]]) {
			vc.navigationItem.title = vcTitle;
		}

		//设置item标题,图片
		UIImage *itemNormolImage = infoDic[kTabBarItemNormolImageKey];
		UIImage *itemSelectedImage = infoDic[kTabBarItemSelectedImageKey];
		if ([itemNormolImage isKindOfClass:[UIImage class]] &&
			[itemSelectedImage isKindOfClass:[UIImage class]]) {
			vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:vcTitle
														  image:itemNormolImage
												  selectedImage:itemSelectedImage];
		}

		//普通状态标题文字颜色
		UIColor *normolTitleColor = infoDic[kTabBarItemNormolColorKey];
		if ([normolTitleColor isKindOfClass:[UIColor class]]) {
			[vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:normolTitleColor} forState:UIControlStateNormal];
		}

		// 设置控制器起始位置
		vc.edgesForExtendedLayout = UIRectEdgeNone;
		[self addChildViewController:nav];

		//选中状态标题文字颜色
		UIColor *selectedTitleColor = infoDic[kTabBarItemSelectedColorKey];
		if ([selectedTitleColor isKindOfClass:[UIColor class]]) {
			[vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:selectedTitleColor} forState:UIControlStateSelected];
		} else {
			if (selectedTitleColor) {
				self.tabBar.tintColor = selectedTitleColor;
			}
		}
	}
}


@end
