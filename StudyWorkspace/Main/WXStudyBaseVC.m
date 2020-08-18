//
//  WXStudyBaseVC.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "WXStudyBaseVC.h"
#import "WXStudyCell.h"
#import "WXPublicHeader.h"

@interface WXStudyBaseVC ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *backPan;
@end

@implementation WXStudyBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置布局起始位置
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //添加全屏右滑动返回
    [self addScreenEdgePanGesture];
    
    [self configSubViewsUI];
}

#pragma mark - 添加全屏右滑动返回

/** 添加全屏右滑动返回 */
- (void)addScreenEdgePanGesture {
    //用系统的方法,全屏滑动返回
    if (self.navigationController.viewControllers.count > 1) {
        id target = self.navigationController.interactivePopGestureRecognizer.delegate;
        //忽略警告
        WXUndeclaredSelectorLeakWarning(
          SEL selector = @selector(handleNavigationTransition:);
                                        
          if ([target respondsToSelector:selector]) { //需要滑动返回
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:selector];
            pan.delegate = self;
            [self.view addGestureRecognizer:pan];
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            self.backPan = pan;
           }
        );
    }
}

- (void)setShouldPanBack:(BOOL)shouldPanBack
{
    _shouldPanBack = shouldPanBack;
    self.backPan.enabled = shouldPanBack;
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

/** 初始化UIRefreshControl */
- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    }
    return _refreshControl;
}

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

/** 返回上一页面  */
- (void)backBtnClick:(UIButton *)backBtn {
    [self.view endEditing:YES];
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/** 父类释放时取消子类所有请求操作 */
- (void)cancelRequestSessionTask {
    if (_requestTaskArr.count==0) return;
    for (NSURLSessionDataTask *sessionTask in self.requestTaskArr) {
        if ([sessionTask isKindOfClass:[NSURLSessionDataTask class]]) {
            [sessionTask cancel];
        }
    }
    //清除所有请求对象
    [self.requestTaskArr removeAllObjects];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    //取消子类所有请求操作
    [self cancelRequestSessionTask];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

