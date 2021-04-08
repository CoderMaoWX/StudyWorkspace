//
//  WXStudyBaseVC.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "WXStudyBaseVC.h"
#import "UIScrollView+WXBlankPageView.h"
#import "NSString+Extension.h"

@interface WXStudyBaseVC ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) ZXTableViewManager        *tableViewManager;
@property (nonatomic, strong) ZXCollectionViewManager   *collectionViewManager;
@property (nonatomic, strong) UIPanGestureRecognizer    *backPan;
@property (nonatomic, strong) UILabel                   *tipTextLabel;
@end

///忽略两个可选实现的方法警告: 1. -heightForRowBlcok, 2.-sizeForItemBlcok
///https://www.cnblogs.com/yfming/p/5936173.html
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation WXStudyBaseVC
#pragma clang diagnostic pop

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置布局起始位置
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //添加全屏右滑动返回
    [self addScreenEdgePanGesture];
    
    [self wx_InitView];
    [self wx_AutoLayoutView];
    [self addSubVCTipUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view.window endEditing:YES];
}

#pragma mark - 添加全屏右滑动返回

/** 添加全屏右滑动返回 */
- (void)addScreenEdgePanGesture {
    //用系统的方法,全屏滑动返回
    if (self.navigationController.viewControllers.count > 1) {
        id target = self.navigationController.interactivePopGestureRecognizer.delegate;
        //忽略警告
        WX_UndeclaredSelectorLeakWarning(
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

- (void)setShouldPanBack:(BOOL)shouldPanBack {
    _shouldPanBack = shouldPanBack;
    self.backPan.enabled = shouldPanBack;
}

#pragma mark -============== <UITableView> 配置父类表格数据和代理 ==============

- (NSMutableArray *)listDataArray {
    if (!_listDataArray) {
        _listDataArray = [NSMutableArray array];
    }
    return _listDataArray;
}

- (UITableView *)plainTableView {
    if (!_plainTableView) {
        CGFloat bottomH = (self.navigationController.viewControllers.count == 1) ? kTabBarHeight : 0;
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - (kStatusAddNavBarHeight + bottomH));
        _plainTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _plainTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _plainTableView.backgroundColor = self.view.backgroundColor;
        _plainTableView.showsVerticalScrollIndicator = NO;
        _plainTableView.tableFooterView = [UIView new];
        _plainTableView.dataSource = self.tableViewManager;
        _plainTableView.delegate = self.tableViewManager;
        _plainTableView.emptyDataImage = WX_ImageName(@"empty_collection");
        _plainTableView.emptyDataTitle = @"暂无数据";
        [self.view addSubview:_plainTableView];
        if (@available(iOS 11.0, *)) {
            _plainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _plainTableView;
}

///表格代理方法管理类
- (ZXTableViewManager *)tableViewManager {
    if(!_tableViewManager){
        _tableViewManager = [ZXTableViewManager createWithCellClass:self.registerTableViewCell];
        _tableViewManager.plainTabDataArr = self.listDataArray;
        _tableViewManager.cellForRowBlock = self.cellForRowBlock;
        _tableViewManager.didSelectRowBlcok = self.didSelectRowBlcok;
        if ([self respondsToSelector:@selector(didScrollBlock)]) {
            _tableViewManager.didScrollBlock = self.didScrollBlock;
        }
        if ([self respondsToSelector:@selector(heightForRowBlcok)]) {
            _tableViewManager.heightForRowBlcok = self.heightForRowBlcok;
        }
    }
    return _tableViewManager;
}

///由子类覆盖: 表格需要注册的Cell
- (Class)registerTableViewCell {
    return [UITableViewCell class];
}

/////由子类覆盖: 配置表格Cell高度 (警告: 父类不能复写次方法, 只能留给之类复写次方法)
//- (ZXTableViewRowHeightBlock)heightForRowBlcok {
//    return ^ CGFloat (id rowData, NSIndexPath *indexPath) {
//        return kDefaultCellHeight;
//    };
//}

///由子类覆盖: 配置表格数据方法
- (ZXTableViewConfigBlock)cellForRowBlock {
    return ^ (UITableViewCell *cell, id rowData, NSIndexPath *indexPath) {
        WX_Log(@"cellForRowAtIndexPath: %@", cell)
        
        SEL sel = NSSelectorFromString(@"setDataModel:");
        if ([cell respondsToSelector:sel]) {
            WX_PerformSelectorLeakWarning(
              [cell performSelector:sel withObject:rowData];
            );
        }
    };
}

///由子类覆盖: 点击表格代理方法
- (ZXTableViewConfigBlock)didSelectRowBlcok {
    return ^ (UITableViewCell *cell, id rowData, NSIndexPath *indexPath) {
        WX_Log(@"didSelectRowBlcok: %@", rowData)
    };
}

///滚动列表回调
//- (void(^)(CGPoint contentOffset))didScrollBlock {
//    return ^(CGPoint contentOffset) {
//
//    };
//}

#pragma mark -============== <UICollectionView> 配置父类表格数据和代理 ==============

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
        flowLayout.minimumLineSpacing = 12;
        flowLayout.minimumInteritemSpacing = 12;
        if ([self respondsToSelector:@selector(configFlowLayout:)]) {
            [self configFlowLayout:flowLayout];
        }
        
        CGFloat bottomH = (self.navigationController.viewControllers.count == 1 ) ? kBottomSafeAreaHeight : 0;
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - (kStatusAddNavBarHeight + bottomH));
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self.collectionViewManager;
        _collectionView.dataSource = self.collectionViewManager;
        _collectionView.emptyDataImage = WX_ImageName(@"empty_collection");
        _collectionView.emptyDataTitle = @"暂无数据";
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

///表格代理方法管理类
- (ZXCollectionViewManager *)collectionViewManager {
    if(!_collectionViewManager){
        _collectionViewManager = [ZXCollectionViewManager createWithCellClass:self.registerCollectionViewCell];
        _collectionViewManager.listDataArray = self.listDataArray;
        _collectionViewManager.cellForItemBlock = self.cellForItemBlock;
        _collectionViewManager.didSelectItemBlcok = self.didSelectItemBlcok;
        if ([self respondsToSelector:@selector(didScrollBlock)]) {
            _collectionViewManager.didScrollBlock = self.didScrollBlock;
        }
        if ([self respondsToSelector:@selector(sizeForItemBlcok)]) {
            _collectionViewManager.sizeForItemBlcok = self.sizeForItemBlcok;
        }
    }
    return _collectionViewManager;
}

///由子类覆盖: 表格需要注册的Cell
- (Class)registerCollectionViewCell {
    return [UICollectionViewCell class];
}

///由子类覆盖: 配置表格布局样式
- (void)configFlowLayout:(UICollectionViewFlowLayout *)flowLayout {
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, (isPhoneXSeries ? 34 : 12), 0);
    flowLayout.estimatedItemSize = CGSizeMake(94, 28);
}

/////由子类覆盖: 配置表格Cell高度 (警告: 父类不能复写次方法, 只能留给之类复写次方法)
//- (ZXCollectionViewItemSizeBlock)sizeForItemBlcok {
//    return ^ CGSize (id itemData, NSIndexPath *indexPath) {
//        return CGSizeMake(50.0, 50.0);
//    };
//}

///由子类覆盖: 配置表格数据方法
- (ZXCollectionViewConfigBlock)cellForItemBlock {
    return ^ (UICollectionViewCell *cell, id itemData, NSIndexPath *indexPath) {
        WX_Log(@"cellForItemAtIndexPath: %@", cell)
        
        SEL sel = NSSelectorFromString(@"setDataModel:");
        if ([cell respondsToSelector:sel]) {
            WX_PerformSelectorLeakWarning(
              [cell performSelector:sel withObject:itemData];
            );
        }
    };
}

///由子类覆盖: 点击表格代理方法
- (ZXCollectionViewConfigBlock)didSelectItemBlcok {
    return ^ (UICollectionViewCell *cell, id itemData, NSIndexPath *indexPath) {
        WX_Log(@"didSelectItemBlcok: %@", itemData)
    };
}



#pragma mark - <SubClass Implementation> 布局页面子视图

/// 子类实现:添加子视图
- (void)wx_InitView {
    WX_Log(@"子类实现(%@):添加子视图", NSStringFromClass([self class]));
}

/// 子类实现: 布局视图
- (void)wx_AutoLayoutView {
    WX_Log(@"子类实现(%@):布局子视图", NSStringFromClass([self class]));
}

///提示UI
- (void)addSubVCTipUI {
    if (self.subTitle) {
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.font = [UIFont systemFontOfSize:12];
        subTitleLabel.textColor = WX_ColorHex(0xC0C0C0);
        subTitleLabel.numberOfLines = 0;
        self.navigationItem.titleView = subTitleLabel;
        
        NSArray *textArr = @[WX_FormatString(@"%@\n", self.title), WX_ToString(self.subTitle)];
        NSArray *fontArr = @[WX_FontSystem(16), WX_FontSystem(13)];
        NSArray *colorArr = @[WX_ColorBlackTextColor(), WX_ColorRGB(64,128,214, 1)];
        
        subTitleLabel.attributedText = [NSString getAttriStrByTextArray:textArr
                                                                fontArr:fontArr
                                                               colorArr:colorArr
                                                            lineSpacing:2
                                                              alignment:1];
    }
    
    if (!WX_IsEmptyString(self.tipText)) {
        self.tipTextLabel.text = self.tipText;
        [self.view addSubview:self.tipTextLabel];
        [self.view insertSubview:self.tipTextLabel atIndex:0];
        [self.tipTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
    }
}

- (UILabel *)tipTextLabel {
    if (!_tipTextLabel) {
        _tipTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipTextLabel.backgroundColor = [UIColor clearColor];
        _tipTextLabel.font = WX_FontSystem(16);
        _tipTextLabel.textColor = WX_ColorHex(0xC0C0C0);
    }
    return _tipTextLabel;
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

