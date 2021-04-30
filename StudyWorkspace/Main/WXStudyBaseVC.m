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
    
    [self wx_InitView];
    [self wx_AutoLayoutView];
    [self addSubVCTipUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view.window endEditing:YES];
}

#pragma mark - 添加全屏右滑动返回

/** 用系统的方法添加全屏右滑动返回 */
- (void)addScreenEdgePanGesture {
    if (self.navigationController.viewControllers.count <= 1) return;
    
    WX_UndeclaredSelectorLeakWarning( //忽略警告
      id target = self.navigationController.interactivePopGestureRecognizer.delegate;
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
        _plainTableView.automaticShowBlankView = YES;
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
        _tableViewManager = [[ZXTableViewManager alloc] init];
        _tableViewManager.cellClases = self.registerTableViewCell;
        _tableViewManager.heightForRowBlcok = self.heightForRowBlcok;
        _tableViewManager.cellForRowBlock = self.cellForRowBlock;//二选一
        _tableViewManager.mutableCellForRowBlock = self.mutableCellForRowBlock;//二选一
        _tableViewManager.didSelectRowBlcok = self.didSelectRowBlcok;
        _tableViewManager.didScrollBlock = self.didScrollBlock;
        @weakify(self)
        _tableViewManager.dataOfSections = ^NSArray *(NSInteger section) {
            @strongify(self)
            ///当前示例为只配置一组数据源, 外部可重写当前dataOfSections的Block来配置多组不同的数据源
            return self.listDataArray;
        };
    }
    return _tableViewManager;
}

///由子类覆盖: 表格需要注册的Cell <UITableViewCell.type>
- (NSArray<Class> *)registerTableViewCell {
#ifdef DEBUG
    return @[ /* [需要注册的Cell class] */ ];
#else
    return @[ [UITableViewCell class] ];
#endif
}

#pragma mark -============== <UICollectionView> 配置父类表格数据和代理 ==============

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [self configFlowLayout:flowLayout];
        
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
        _collectionView.automaticShowBlankView = YES;
        [self.view addSubview:_collectionView];
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
        _collectionViewManager.sizeForItemBlcok = self.sizeForItemBlcok;
        _collectionViewManager.cellForItemBlock = self.cellForItemBlock;
        _collectionViewManager.didSelectItemBlcok = self.didSelectItemBlcok;
        _collectionViewManager.didScrollBlock = self.didScrollBlock;
    }
    return _collectionViewManager;
}

///必须由子类覆盖: 表格需要注册的Cell
- (Class)registerCollectionViewCell {
    return [UICollectionViewCell class];
}

///可由子类覆盖: 配置表格布局样式
- (void)configFlowLayout:(UICollectionViewFlowLayout *)flowLayout {
    BOOL isTopNav = (self.navigationController.viewControllers.count == 1);
    CGFloat bottomH = isTopNav ? kTabBarHeight : (isPhoneXSeries ? 34 : 12);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, bottomH, 0);
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
        subTitleLabel.attributedText = [NSString getAttriStrByTextArray:textArr fontArr:fontArr colorArr:colorArr lineSpacing:2 alignment:1];
    }
    if (!WX_IsEmptyString(self.tipText)) {
        self.tipTextLabel.text = self.tipText;
        [self.view insertSubview:self.tipTextLabel atIndex:0];
        [self.tipTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.size.mas_lessThanOrEqualTo(self.view);
        }];
    }
}

- (UILabel *)tipTextLabel {
    if (!_tipTextLabel) {
        _tipTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipTextLabel.preferredMaxLayoutWidth = self.view.bounds.size.width;
        _tipTextLabel.backgroundColor = [UIColor clearColor];
        _tipTextLabel.textColor = WX_ColorHex(0xC0C0C0);
        _tipTextLabel.font = WX_FontSystem(16);
        _tipTextLabel.numberOfLines = 0;
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

