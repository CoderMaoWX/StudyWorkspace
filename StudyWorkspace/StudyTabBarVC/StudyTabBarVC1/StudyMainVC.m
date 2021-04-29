//
//  ViewController.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "StudyMainVC.h"
#import "WXStudyCell.h"

@implementation StudyMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.plainTableView.rowHeight = 60;
    
    // @{ 要测试的VC : 对应类的功能描述 }
    [self.listDataArray addObjectsFromArray:@[
        @{@"StudyVC15.m"    :   @"URLComponents"},
        @{@"StudyVC14.m"    :   @"长按模糊图片显示清晰背景"},
        @{@"StudyVC1.m"     :   @"一键切换启动闪屏图AppLaunchImage"},
        @{@"StudyVC2.m"     :   @"操作谓词NSPredicate"},
        @{@"StudyVC3.m"     :   @"操作UIStackView"},
        @{@"StudyVC4.m"     :   @"操作NSInvocation"},
        @{@"StudyVC5.m"     :   @"操作ObjcMessage"},
        @{@"StudyVC6.m"     :   @"操作WkWebview"},
        @{@"StudyVC7.m"     :   @"核心动画"},
        @{@"StudyVC8.m"     :   @"画圈"},
        @{@"StudyVC9.m"     :   @"Quartz2D绘图"},
        @{@"StudyVC10.m"    :   @"折线统计图"},
        @{@"StudyVC11.m"    :   @"百叶窗动画"},
        @{@"StudyVC12.m"    :   @"画笔涂鸦"},
        @{@"StudyVC13.m"    :   @"抖动弹性约束动画"},
     ]];
    [self.plainTableView reloadData];
}

#pragma mark -============== <UITableView> 配置父类表格数据和代理 ==============

///由子类覆盖: 表格需要注册的Cell <UITableViewCell.type>
- (NSArray<Class> *)registerTableViewCell {
    return @[ [WXStudyCell class] ];
}

///由子类覆盖: 配置表格数据方法
- (ZXTableViewConfigBlock)cellForRowBlock {
    return ^ (UITableViewCell *c, NSDictionary *rowData, NSIndexPath *indexPath) {
        if (![rowData isKindOfClass:[NSDictionary class]]) return ;
        NSString *name = rowData.allKeys.firstObject;
        WXStudyCell *cell = (WXStudyCell *)c;
        cell.titleLabel.text = name;
        cell.subTitleLabel.text = rowData[name];
    };
}

///由子类覆盖: 配置表格数据方法
- (ZXTableViewMutableCellBlock)mutableCellForRowBlock {
    return ^UITableViewCell* (UITableView *tableView, NSDictionary *rowData, NSIndexPath *indexPath) {
        UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WXStudyCell class]) forIndexPath:indexPath];
        if (![rowData isKindOfClass:[NSDictionary class]]) return c;
        NSString *name = rowData.allKeys.firstObject;
        WXStudyCell *cell = (WXStudyCell *)c;
        cell.titleLabel.text = name;
        cell.subTitleLabel.text = rowData[name];
        return c;
    };
}


///由子类覆盖: 点击表格代理方法
- (ZXTableViewConfigBlock)didSelectRowBlcok {
    return ^ (UITableViewCell *cell, NSDictionary *celLDic, NSIndexPath *indexPath) {
        NSString *className = [celLDic.allKeys.firstObject stringByReplacingOccurrencesOfString:@".m" withString:@""];
        UIViewController *vc = [[NSClassFromString(className) alloc] init];
        if (![vc isKindOfClass:[UIViewController class]]) return;
        vc.title = className;
        vc.hidesBottomBarWhenPushed = YES;
        [vc setValue:celLDic.allValues.firstObject forKey:@"subTitle"];
        [self.navigationController pushViewController:vc animated:YES];
    };
}

@end
