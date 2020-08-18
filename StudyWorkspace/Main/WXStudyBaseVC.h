//
//  WXStudyBaseVC.h
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXTableViewManager.h"

typedef void (^ConfigCellBlock)(UITableViewCell * cell, id rowData, NSIndexPath *indexPath);

@interface WXStudyBaseVC : UIViewController

/** 是否使用全屏返回手势 */
@property (nonatomic, assign) BOOL shouldPanBack;

/** 系统下拉刷新控件 */
@property (nonatomic, strong) UIRefreshControl *refreshControl;

/** 子类请求对象数组 */
@property (nonatomic, strong) NSMutableArray *requestTaskArr;

@property (nonatomic, strong) WXTableViewManager *tableViewManager;

@property (nonatomic, strong) UITableView *plainTableView;

@property (nonatomic, strong) NSMutableArray *tableDataArr;

@property (nonatomic, copy) ConfigCellBlock configCellBlock;

- (void)didSelectedTableViewIndexPath:(NSIndexPath *)indexPath;

/// 子类实现添加子视图
- (void)configSubViewsUI;

/** 返回上一页面  */
- (void)backBtnClick:(UIButton *)backBtn;

/** 父类释放时取消子类所有请求操作 */
- (void)cancelRequestSessionTask;

@end
