//
//  WXStudyTabBarVC2.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/17.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "WXStudyTabBarVC2.h"
#import "UITabBarController+WXConvertSkin.h"
#import "UIView+WXExtension.h"
#import "SlideAppTabBarVC.h"
#import "UITabBar+BadgeView.h"
#import "WXFileManager.h"

@interface WXStudyTabBarVC2 ()<UIGestureRecognizerDelegate>
/** tabBar图标缓存 */
@property (nonatomic, strong) NSArray *tabBarCacheIconImageArr;
@end

@implementation WXStudyTabBarVC2

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 * 监听重复点击tabBar按钮事件
 */
- (void)repeatTouchTabBarToViewController:(UIViewController *)touchVC {
    NSLog(@"FirstViewController监听到重复点击tabBatItem事件===%@===%@===%@",touchVC,self,self.tabBarController);
    //设置小红点
    [self.tabBarController.tabBar showBadgeOnItemIndex:0];
}

/**
 * 切换图标主题
 */
- (IBAction)reduceTabbarItem:(UIButton *)button {
    button.selected = !button.selected;

    if (button.selected) {
        [button setTitle:@"切换默认主题" forState:UIControlStateSelected];

        if (self.tabBarCacheIconImageArr.count > 0) {
            NSLog(@"更换新主题===%@",self.tabBarCacheIconImageArr);
            [(SlideAppTabBarVC *)self.tabBarController changeTabBarTheme:self.tabBarCacheIconImageArr newTheme:YES];
        } else {
            [self requestIconIconUrlData];
        }
    } else {
        [button setTitle:@"切换新主题" forState:UIControlStateSelected];

        NSArray *imageArr = @[WX_ImageName(@"tabbar_home_n"),WX_ImageName(@"tabbar_property_n"),WX_ImageName(@"tabbar_my_n")];
        NSLog(@"更换默认主题===%@",imageArr);
        [(SlideAppTabBarVC *)self.tabBarController changeTabBarTheme:imageArr newTheme:NO];
    }

    //切换侧边栏主题
    if ([self.parentViewController respondsToSelector:@selector(convertLeftViewTheme:)]) {
        [self.parentViewController performSelector:@selector(convertLeftViewTheme:) withObject:@(button.selected)];
    }
}

/**
 *    请求icon数据
 */
- (void)requestIconIconUrlData
{
    NSArray *defaultNormolImageArr = @[@"tabbar_home_n",@"tabbar_property_n",@"tabbar_my_n",@"tabbar_property_n"];

    ///免费图标: https://icons8.cn/icons
    NSArray *iconUrlArr = [NSArray arrayWithObjects:
                           @"https://img.icons8.com/doodle/2x/home.png",
                           @"https://img.icons8.com/cute-clipart/2x/shop.png",
                           @"https://img.icons8.com/color/2x/giraffe.png",
                           @"https://img.icons8.com/color/2x/animation.png",nil];

    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *downloadIconArr = [NSMutableArray array];
    
    for (int i=0; i<iconUrlArr.count; i++) {

        NSString *saveImagePath = [NSString stringWithFormat:@"%@/%@@2x.png",[WXFileManager getTabBarDirectory],defaultNormolImageArr[i]];

        if ([[NSFileManager defaultManager] fileExistsAtPath:saveImagePath]) {
            UIImage *image = [UIImage imageNamed:saveImagePath];
            [downloadIconArr addObject:image];

            if (downloadIconArr.count == defaultNormolImageArr.count) {
                self.tabBarCacheIconImageArr = downloadIconArr;
                [(SlideAppTabBarVC *)self.tabBarController changeTabBarTheme:downloadIconArr newTheme:NO];
            }

        } else {

            NSString *iconUrlStr = iconUrlArr[i];
            dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrlStr]]];
                if ([image isKindOfClass:[UIImage class]]) {
                    [downloadIconArr addObject:image];
                    
                    //设置尺寸
                    UIImage *convertImage = [self.class scaleToSize:image size:CGSizeMake(31*2, 31*2)];
                    [UIImagePNGRepresentation(convertImage) writeToFile:saveImagePath atomically:NO];
                }
            });
        }
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"下载完成===%@",downloadIconArr);
        self.tabBarCacheIconImageArr = downloadIconArr;
        [(SlideAppTabBarVC *)self.tabBarController changeTabBarTheme:self.tabBarCacheIconImageArr newTheme:YES];
    });
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


/**
 * 增加tabbar
 */
- (IBAction)addTabbarAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setTitle:@"减少TabBarItem" forState:UIControlStateSelected];
    } else {
        [sender setTitle:@"增加TabBarItem" forState:0];
    }

    UITabBarController *tabbarContr = self.tabBarController;
    NSMutableArray *newItemArr = [NSMutableArray arrayWithArray:tabbarContr.viewControllers];

    if (!sender.selected) {
        [newItemArr removeObjectAtIndex:(newItemArr.count-1)];
        tabbarContr.viewControllers = newItemArr;

        //刷新添加的小红点
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tabbarContr.tabBar refreshTabBarRoundView];
        });
        return;
    }

    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    vc.title = @"UIViewController";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

    vc.tabBarItem.image = [[UIImage imageNamed:@"tabbar_property_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_property_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.title = @"双十一";

    if (self.tabBarItem.imageInsets.bottom == 20) {
        vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -10);
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(-20, 0, 20, 0);
    }

    [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromHex(0x282828), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromHex(0xfe9b00), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [newItemArr addObject:nav];
    tabbarContr.viewControllers = newItemArr;

    //刷新添加的小红点
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabbarContr.tabBar refreshTabBarRoundView];
    });
}

@end
