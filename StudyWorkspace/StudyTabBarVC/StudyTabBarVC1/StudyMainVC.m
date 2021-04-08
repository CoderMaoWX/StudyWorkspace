//
//  ViewController.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "StudyMainVC.h"
#import "WXTableViewManager.h"

@interface StudyMainVC ()

@end

@implementation StudyMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // @{ 要测试的VC : 对应类的功能描述 }
    [self.tableDataArr addObjectsFromArray:@[
        @{@"StudyVC1.m"   :   @"一键切换启动闪屏图AppLaunchImage"},
        @{@"StudyVC2.m"   :   @"操作谓词NSPredicate"},
        @{@"StudyVC3.m"   :   @"操作UIStackView"},
        @{@"StudyVC4.m"   :   @"操作NSInvocation"},
        @{@"StudyVC5.m"   :   @"操作ObjcMessage"},
        @{@"StudyVC6.m"   :   @"操作WkWebview"},
        @{@"StudyVC7.m"   :   @"核心动画"},
        @{@"StudyVC8.m"   :   @"画圈"},
        @{@"StudyVC9.m"   :   @"Quartz2D绘图"},
        @{@"StudyVC10.m"  :   @"折线统计图"},
        @{@"StudyVC11.m"  :   @"百叶窗动画"},
        @{@"StudyVC12.m"  :   @"画笔涂鸦"},
        @{@"StudyVC13.m"  :   @"抖动弹性约束动画"},
     ]];
    [self.plainTableView reloadData];
}

- (void)didSelectedTableViewIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *celLDic = [self.tableDataArr objectAtIndex:indexPath.row];
    NSString *className = [celLDic.allKeys.firstObject stringByReplacingOccurrencesOfString:@".m" withString:@""];
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    if (![vc isKindOfClass:[UIViewController class]]) return;
    vc.title = className;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
