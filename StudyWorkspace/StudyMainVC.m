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
    
    // --- 要添加测试的VC，在此处把类名加上即可
    [self.tableDataArr addObjectsFromArray:@[
        @{@"StudyVC1":@"一键切换启动闪屏图AppLaunchImage"},
        @{@"StudyVC2":@"操作谓词NSPredicate"},
        @{@"StudyVC3":@"操作UIStackView"},
        @{@"StudyVC4":@"操作NSInvocation"},
        @{@"StudyVC5":@"操作ObjcMessage"},
        @{@"StudyVC6":@"操作WkWebview"},
        @{@"StudyVC7":@"核心动画"},
        @{@"StudyVC8":@"画圈"},
        @{@"StudyVC9":@"Quartz2D绘图"},
        @{@"StudyVC10":@"折线统计图"},
        @{@"StudyVC11":@"百叶窗动画"},
        @{@"StudyVC12":@"画笔涂鸦"},
     ]];
    [self.plainTableView reloadData];
}

- (void)didSelectedTableViewIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *celLDic = [self.tableDataArr objectAtIndex:indexPath.row];
    NSString *className = celLDic.allKeys[0];
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    if (!vc) return;
    vc.title = className;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
