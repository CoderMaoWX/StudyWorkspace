//
//  StudyBaseVC.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "StudyBaseVC.h"
#import "WXStudyCell.h"
#import "WXCFuntionTool.h"

@implementation StudyBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self configSubViewsUI];
}

#pragma mark - <SubClass Implementation>

/// 子类实现添加子视图
- (void)configSubViewsUI {
    
}

#pragma mark - ========= 子类显示表格代理 =========

- (ConfigCellBlock)baseCellBlock {
    //__weak typeof(self) weakSelf = self;
    return ^ (UITableViewCell *c, id rowData, NSIndexPath *indexPath) {
        if (![rowData isKindOfClass:[NSDictionary class]]) return ;
        NSDictionary *celLDic = rowData;
        NSString *name = celLDic.allKeys[0];
        WXStudyCell *cell = (WXStudyCell *)c;
        cell.titleLabel.text = name;
        cell.subTitleLabel.text = celLDic[name];
    };
}

- (WXTableViewManager *)tableViewManager {
    if(!_tableViewManager){
        _tableViewManager = [WXTableViewManager createWithCellClass:[WXStudyCell class]];
        
        _tableViewManager.cellForRowBlock = self.configCellBlock ?: self.baseCellBlock;
        
        __weak typeof(self) weakSelf = self;
        [_tableViewManager setPlainTabDataArrBlcok:^NSArray * {
            return weakSelf.tableDataArr;
        }];
        
        [_tableViewManager setDidSelectRowBlcok:^(NSDictionary *rowDataDic, NSIndexPath *indexPath) {
            [weakSelf didSelectedTableViewIndexPath:indexPath];
        }];
    }
    return _tableViewManager;
}

- (void)didSelectedTableViewIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.plainTableView cellForRowAtIndexPath:indexPath];
    NSLog(@"didSelectedTableView: %@, %@", cell.textLabel.text, cell.detailTextLabel.text);
}

#pragma mark - ========= 初始化基类表格,子类显示 =========

- (UITableView *)plainTableView {
    if (!_plainTableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-(kStatusBarHeight+44));
        _plainTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _plainTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        //_plainTableView.rowHeight = 44;
        _plainTableView.backgroundColor = self.view.backgroundColor;
        _plainTableView.tableFooterView = [UIView new];
        _plainTableView.dataSource = self.tableViewManager;
        _plainTableView.delegate = self.tableViewManager;
        [self.view addSubview:_plainTableView];
    }
    return _plainTableView;
}

- (NSMutableArray *)tableDataArr{
    if (!_tableDataArr) {
        _tableDataArr = [NSMutableArray array];
    }
    return _tableDataArr;
}

#pragma mark - 管理子类请求对象

/**
 * 子类请求对象数组
 */
- (NSMutableArray *)requestTaskArr {
    if (!_requestTaskArr) {
        _requestTaskArr = [NSMutableArray array];
    }
    return _requestTaskArr;
}

@end

