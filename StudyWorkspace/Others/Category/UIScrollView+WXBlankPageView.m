//
//  UIScrollView+WXBlankPageView.m
//  CommonFrameWork
//
//  Created by mao wangxin on 2017/4/17.
//  Copyright © 2017年 MaoWX. All rights reserved.
//

#import "UIScrollView+WXBlankPageView.h"
#import "AFNetworkReachabilityManager.h"
#import "WXBlankTipView.h"
#import "Masonry.h"

/** 网络连接失败 */
static NSString *const kNetworkDefaultFailTips  = @"网络连接失败,请检查网络";
/** 刷新按钮文案 */
static NSString *const kAgainRequestDefaultTips = @"刷新";
/** 失败提示文案 */
static NSString *const kReqFailDefaultTipText   = @"加载失败,请稍后再试";
/** 空数据提示文案 */
static NSString *const kEmptyDataDefaultTipText = @"暂无可用数据";


@implementation UIScrollView (WXBlankPageView)

// ==================== 是否自动显示请求提示view ====================

- (void)setAutomaticShowBlankView:(BOOL)automaticShowBlankView {
    objc_setAssociatedObject(self, @selector(automaticShowBlankView), @(automaticShowBlankView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)automaticShowBlankView {
    id value = objc_getAssociatedObject(self, @selector(automaticShowBlankView));
    return [value boolValue];
}

// ==================== 请求空数据标题 ====================

- (void)setEmptyDataTitle:(NSString *)emptyDataTitle {
    objc_setAssociatedObject(self, @selector(emptyDataTitle), emptyDataTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emptyDataTitle {
    NSString *emptyTip = objc_getAssociatedObject(self, @selector(emptyDataTitle));
    return emptyTip ? : kEmptyDataDefaultTipText;
}

// ==================== 请求空数据副标题 ====================

- (void)setEmptyDataSubTitle:(NSString *)emptyDataSubTitle {
    objc_setAssociatedObject(self, @selector(emptyDataSubTitle), emptyDataSubTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emptyDataSubTitle {
    NSString *emptyTip = objc_getAssociatedObject(self, @selector(emptyDataSubTitle));
    return emptyTip;
}

// ==================== 请求空数据图片 ====================

- (void)setEmptyDataImage:(UIImage *)emptyDataImage {
    objc_setAssociatedObject(self, @selector(emptyDataImage), emptyDataImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)emptyDataImage {
    UIImage *image = objc_getAssociatedObject(self, @selector(emptyDataImage));
    if (!image) {
        image = [UIImage imageNamed:@"search_no_data"];//空数据默认图片
    }
    return image;
}

// ==================== 空数按钮点标题 ====================

- (void)setEmptyDataBtnTitle:(NSString *)emptyDataBtnTitle {
    objc_setAssociatedObject(self, @selector(emptyDataBtnTitle), emptyDataBtnTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emptyDataBtnTitle {
    NSString *emptyBtnTitle = objc_getAssociatedObject(self, @selector(emptyDataBtnTitle));
    return emptyBtnTitle;
}

// ==================== 请求失败提示 ====================

- (void)setRequestFailTitle:(NSString *)requestFailTitle {
    objc_setAssociatedObject(self, @selector(requestFailTitle), requestFailTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)requestFailTitle {
    NSString *tipStr = objc_getAssociatedObject(self, @selector(requestFailTitle));
    return tipStr ? : kReqFailDefaultTipText;//失败默认提示文案
}

// ==================== 请求失败图片 ====================

- (void)setRequestFailImage:(UIImage *)requestFailImage {
    objc_setAssociatedObject(self, @selector(requestFailImage), requestFailImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)requestFailImage {
    UIImage *image = objc_getAssociatedObject(self, @selector(requestFailImage));
    if (!image) {
        image = [UIImage imageNamed:@"blankPage_networkError"];
    }
    return image;
}

// ==================== 请求失败按钮点标题 ====================

- (void)setRequestFailBtnTitle:(NSString *)requestFailBtnTitle {
    objc_setAssociatedObject(self, @selector(requestFailBtnTitle), requestFailBtnTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)requestFailBtnTitle {
    NSString *failBtnTitle = objc_getAssociatedObject(self, @selector(requestFailBtnTitle));
    return failBtnTitle ? : kAgainRequestDefaultTips;//失败默认按钮文案
}

// ==================== 网络错误提示 ====================

- (void)setNetworkErrorTitle:(NSString *)networkErrorTitle {
    objc_setAssociatedObject(self, @selector(networkErrorTitle), networkErrorTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)networkErrorTitle {
    NSString *tipStr = objc_getAssociatedObject(self, @selector(networkErrorTitle));
    return tipStr ? : kNetworkDefaultFailTips;//失败默认提示文案
}

// ==================== 网络错误图片 ====================

- (void)setNetworkErrorImage:(UIImage *)networkErrorImage {
    objc_setAssociatedObject(self, @selector(networkErrorImage), networkErrorImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)networkErrorImage {
    UIImage *image = objc_getAssociatedObject(self, @selector(networkErrorImage));
    if (!image) {
        image = [UIImage imageNamed:@"blankPage_networkError"];
    }
    return image;
}

// ==================== 网络失败按钮点标题 ====================

- (void)setNetworkErrorBtnTitle:(NSString *)networkErrorBtnTitle {
    objc_setAssociatedObject(self, @selector(networkErrorBtnTitle), networkErrorBtnTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)networkErrorBtnTitle {
    NSString *networkFailBtnTitle = objc_getAssociatedObject(self, @selector(networkErrorBtnTitle));
    return networkFailBtnTitle ? : kAgainRequestDefaultTips;//无网络默认按钮文案
}

// ==================== 网络连接按钮点击事件回调 ====================

- (void)setBlankTipViewActionBlcok:(void (^)(WXBlankTipViewStatus))blankTipViewActionBlcok {
    objc_setAssociatedObject(self, @selector(blankTipViewActionBlcok), blankTipViewActionBlcok, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(WXBlankTipViewStatus))blankTipViewActionBlcok {
    return objc_getAssociatedObject(self, @selector(blankTipViewActionBlcok));
}

// ==================== 外部可控制整体View的中心点上下偏移位置 ====================

- (void)setBlankViewOffsetPoint:(CGPoint)blankViewOffsetPoint {
    NSString *centerObj = NSStringFromCGPoint(blankViewOffsetPoint);
    objc_setAssociatedObject(self, @selector(blankViewOffsetPoint), centerObj, OBJC_ASSOCIATION_COPY_NONATOMIC);

    //控制居中位置, {0, 0}:表示上下居中显示, 默认居中显示
    WXBlankTipView *tipView = [self viewWithTag:kBlankTipViewTag];
    if ([tipView isKindOfClass:[WXBlankTipView class]]) {
        tipView.contenViewOffsetPoint = blankViewOffsetPoint;
    }
}

- (CGPoint)blankViewOffsetPoint {
    NSString *centerObj = objc_getAssociatedObject(self, @selector(blankViewOffsetPoint));
    return CGPointFromString(centerObj);
}

/**
 * 开始监听网络
 */
+ (void)load {
    //AFN需要提前监听网络
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - 给表格添加上下拉刷新事件

/**
 初始化表格的上下拉刷新控件

 @param headerBlock 下拉刷新需要调用的函数
 @param footerBlock 上拉刷新需要调用的函数
 @param startRefreshing 是否需要立即刷新
 */
- (void)addHeaderRefreshBlock:(WXRefreshingBlock)headerBlock
           footerRefreshBlock:(WXRefreshingBlock)footerBlock
              startRefreshing:(BOOL)startRefreshing {
    if (headerBlock) {
        typeof(self) __weak weakSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            typeof(weakSelf) __strong strongSelf = weakSelf;
            
            //1.先移除页面上已有的提示视图
            [strongSelf removeBlankView];
            
            //2.每次下拉刷新时先结束上啦
            [strongSelf.mj_footer endRefreshing];
            
            headerBlock();
        }];
        self.mj_header = header;
        
        //是否需要立即刷新
        if (startRefreshing) {
            [self.mj_header beginRefreshing];
        }
    }

    if (footerBlock) {
        MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            footerBlock();
        }];
        footer.automaticallyRefresh = YES;//设置自动加载
        footer.triggerAutomaticallyRefreshPercent = -([UIScreen mainScreen].bounds.size.height) / 50.0;//预加载下一页数据
        footer.hidden = YES;//这里需要先隐藏,否则已进入页面没有数据也会显示上拉View
        self.mj_footer = footer;
    }
}

/**
 * 开始加载头部数据
 
 @param animation 加载时是否需要动画
 */
- (void)headerRefreshingByAnimation:(BOOL)animation {
    if (!self.mj_header) return;
    if (animation) {
        [self.mj_header beginRefreshing];
    } else {
        if ([self.mj_header respondsToSelector:@selector(executeRefreshingCallback)]) {
            [self.mj_header executeRefreshingCallback];
        }
    }
}

/**
 * 配置下拉列表分页标识
 * 当前类配合调用 -judgeBlankView: 方法来决定是否能显示下一页控件
 */
NSDictionary* WXManageMorePageInfo(NSDictionary *dataDict) {
    if (![dataDict isKindOfClass:[NSDictionary class]]) return nil;
    return @{
        kBlankViewTotalPageKey   : @([dataDict[@"maxPage"] integerValue]),
        kBlankViewCurrentPageKey : @([dataDict[@"currPage"] integerValue]),
    };
}

#pragma mark - 给表格添加上请求失败提示事件
/**
 * 处理空白页
 */
- (void)judgeBlankViewCurrentPage:(NSNumber *)currentPage totalPage:(NSNumber *)totalPage {
    NSMutableDictionary *pageDataDic = [NSMutableDictionary dictionary];
    if (currentPage) {
        pageDataDic[kBlankViewCurrentPageKey] = currentPage;
    }
    if (totalPage) {
        pageDataDic[kBlankViewTotalPageKey] = totalPage;
    }
    if (currentPage && totalPage) {
        [self judgeBlankView:pageDataDic];
    } else {
        [self judgeBlankView:nil];
    }
}

/**
 此方法作用: 会自动收起表格上下拉刷新控件, 判断分页逻辑, 添加数据空白页等操作
 调用条件：  必须要在UITableView/UICollectionView 实例的reloadData方法执行后调用才能生效
 
 @param totalCurrentPageInfo 页面上表格分页数据 "pageCount"数 与 "curPage"数 包装的字典, 注意key不要写错
 */
- (void)judgeBlankView:(NSDictionary *)totalCurrentPageInfo {
    if (self.mj_header) {
        [self.mj_header endRefreshing];
    }
    
    if (self.mj_footer) {
        [self.mj_footer endRefreshing];
    }
    
    //判断请求状态: totalCurrentPageInfo为字典就是请求成功, 否则为请求失败
    BOOL requestSuccess = [totalCurrentPageInfo isKindOfClass:[NSDictionary class]];
    
    if ([self contentViewIsEmptyData]) {//页面没有数据
        //根据状态,显示背景提示Viwe
        WXBlankTipViewStatus status = WXBlankTipViewStatus_Fail;
        
        if (![AFNetworkReachabilityManager sharedManager].reachable) {
            status = WXBlankTipViewStatus_NoNetWork;//显示没有网络提示
            
        } else if (requestSuccess) {//成功:显示空数据提示
            status = WXBlankTipViewStatus_EmptyData;
        }
        [self showTipWithStatus:status];
        
    } else { //页面有数据
        //移除页面上已有的提示视图
        [self removeBlankView];

        if (requestSuccess && self.mj_footer) {
            //控制刷新控件显示的分页逻辑
            [self setPageRefreshStatus:totalCurrentPageInfo];
        }
    }
}

#pragma mark - 如果请求失败,无网络则展示空白提示view

/**
 * 设置提示图片和文字
 */
- (void)showTipWithStatus:(WXBlankTipViewStatus)state {
    //先移除页面上已有的提示视图
    [self removeBlankView];
    
    typeof(self) __weak weakSelf = self;
    void (^removeTipViewAndRefreshHeadBlock)(void) = ^(){
        typeof(weakSelf) __strong strongSelf = weakSelf;
        
        if (strongSelf.mj_header && strongSelf.mj_header.state == MJRefreshStateIdle) {
            //1.先移除页面上已有的提示视图
            [strongSelf removeBlankView];
            //2.开始走下拉请求
            [strongSelf.mj_header beginRefreshing];
        }
    };
    
    void (^blankPageViewBtnActionBlcok)(void) = ^(){
        typeof(weakSelf) __strong strongSelf = weakSelf;
        
        //如果额外设置了按钮事件
        if (strongSelf.blankTipViewActionBlcok) {
            //1. 先移除页面上已有的提示视图
            if (state != WXBlankTipViewStatus_EmptyData) {
                [strongSelf removeBlankView];
            }
            //2. 回调按钮点击事件
            strongSelf.blankTipViewActionBlcok(state);
        }
    };

    NSString *tipString = nil;
    NSString *subTipString = nil;
    UIImage *tipImage = nil;
    NSString *actionBtnTitle = nil;
    void (^actionBtnBlock)(void) = nil;

    if (state == WXBlankTipViewStatus_NoNetWork) {//没有网络

        tipString = self.networkErrorTitle;
        tipImage = self.networkErrorImage;
        actionBtnTitle = self.networkErrorBtnTitle;
        if (self.blankTipViewActionBlcok) {
            actionBtnBlock = blankPageViewBtnActionBlcok;
            
        } else if (self.mj_header) {
            actionBtnBlock = removeTipViewAndRefreshHeadBlock;
        } else {
            actionBtnTitle = nil;
        }
    } else if (state == WXBlankTipViewStatus_EmptyData) {//空数据提示

        tipString = self.emptyDataTitle;
        tipImage = self.emptyDataImage;
        subTipString = self.emptyDataSubTitle;
        actionBtnTitle = self.emptyDataBtnTitle;
        if (self.blankTipViewActionBlcok) {
            actionBtnBlock = blankPageViewBtnActionBlcok;
        } else {
            actionBtnTitle = nil;
        }
    } else if (state == WXBlankTipViewStatus_Fail) { //请求失败提示

        tipString = self.requestFailTitle;
        tipImage = self.requestFailImage;
        actionBtnTitle = self.requestFailBtnTitle;
        if (self.blankTipViewActionBlcok) {
            actionBtnBlock = blankPageViewBtnActionBlcok;
            
        } else if (self.mj_header) {
            actionBtnBlock = removeTipViewAndRefreshHeadBlock;
        } else {
            actionBtnTitle = nil;
        }
    } else {
        return;
    }
    
    //防止添加空提示view
    if (!tipString && !tipImage && !subTipString && !actionBtnTitle) {
        return;
    }
    //防止重复添加
    [self removeBlankView];

    //需要显示的自定义提示view
    WXBlankTipView *tipBgView = [[WXBlankTipView alloc] initWithFrame:CGRectZero];
    tipBgView.iconImage = tipImage;
    tipBgView.title = tipString;
    tipBgView.subTitle = subTipString;
    tipBgView.buttonTitle = actionBtnTitle;
    tipBgView.actionBtnBlcok = actionBtnBlock;
    tipBgView.tag = kBlankTipViewTag;
    [self addSubview:tipBgView];
    
    //控制居中位置, {0, 0}:表示上下居中显示, 默认居中显示
    if (!CGPointEqualToPoint(self.blankViewOffsetPoint, CGPointZero)) {
        tipBgView.contenViewOffsetPoint = self.blankViewOffsetPoint;
    }
    
    [tipBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self);
        make.height.mas_equalTo(self.mas_height);
        make.width.mas_equalTo(self.mas_width).offset(-(self.contentInset.left + self.contentInset.right));
    }];
    if (self.backgroundColor) {
        tipBgView.backgroundColor = self.backgroundColor;
    }
}

/**
 * 控制刷新控件显示的分页逻辑
 */
- (void)setPageRefreshStatus:(NSDictionary *)responseData {
    id totalPage = responseData[kBlankViewTotalPageKey];
    id currentPage = responseData[kBlankViewCurrentPageKey];
    NSArray *dataArr = responseData[kBlankViewListKey];

    if (totalPage && currentPage) {

        if ([totalPage integerValue] > [currentPage integerValue]) {
            self.mj_footer.hidden = NO;

        } else {
            [self.mj_footer endRefreshingWithNoMoreData];
            self.mj_footer.hidden = YES;
        }
    } else if([dataArr isKindOfClass:[NSArray class]]) {
        if (dataArr.count>0) {
            self.mj_footer.hidden = NO;

        } else {
            [self.mj_footer endRefreshingWithNoMoreData];
            self.mj_footer.hidden = YES;
        }
    } else {
        [self.mj_footer endRefreshingWithNoMoreData];
        self.mj_footer.hidden = NO;
    }
}

/**
 先移除页面上已有的提示视图
 */
- (void)removeBlankView {
    for (UIView *tempView in self.subviews) {
        if ([tempView isKindOfClass:[WXBlankTipView class]] &&
            tempView.tag == kBlankTipViewTag) {
            [tempView removeFromSuperview];
            break;
        }
    }
}

/**
 * 判断ScrollView页面上是否有数据
 */
- (BOOL)contentViewIsEmptyData {
    BOOL isEmptyCell = YES;
    NSInteger sections = 1;//默认系统都1个sections

    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        if (tableView.tableHeaderView.bounds.size.height > 10 ||
            tableView.tableFooterView.bounds.size.height > 10) {
            return NO;
        }
        
        id<UITableViewDataSource> dataSource = tableView.dataSource;
        if ([dataSource respondsToSelector: @selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        
        for (int i = 0; i < sections; ++i) {
            NSInteger rows = [dataSource tableView:tableView numberOfRowsInSection:i];
            if (rows) {
                isEmptyCell = NO;
                break;
            }
        }
        
        // 如果每个Cell没有数据源, 则还需要判断Header和Footer高度是否为0
        if (isEmptyCell) {
            id<UITableViewDelegate> delegate = tableView.delegate;
            BOOL isEmptyHeader = YES;
            
            if ([delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
                for (int h = 0; h < sections; ++h) {
                    CGFloat headerHeight = [delegate tableView:tableView heightForHeaderInSection:h];
                    if (headerHeight > 1.0) {
                        isEmptyHeader = NO;
                        isEmptyCell = NO;
                        break;
                    }
                }
            }
            
            // 如果Header没有高度还要判断Footer是否有高度
            if (isEmptyHeader) {
                if ([delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
                    for (int k = 0; k < sections; ++k) {
                        CGFloat footerHeight = [delegate tableView:tableView heightForFooterInSection:k];
                        if (footerHeight > 1.0) {
                            isEmptyCell = NO;
                            break;
                        }
                    }
                }
            }
        }
        
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        id<UICollectionViewDataSource> dataSource = collectionView.dataSource;
        if ([dataSource respondsToSelector: @selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        for (int i = 0; i < sections; ++i) {
            NSInteger rows = [dataSource collectionView:collectionView numberOfItemsInSection:i];
            if (rows) {
                isEmptyCell = NO;
            }
        }
        
        // 如果每个ItemCell没有数据源, 则还需要判断Header和Footer高度是否为0
        if (isEmptyCell) {
            BOOL isEmptyHeader = YES;
            id delegateFlowLayout = collectionView.delegate;///<UICollectionViewDelegateFlowLayout>
            
            if ([delegateFlowLayout respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
                for (int h = 0; h < sections; ++h) {
                    CGSize size = [delegateFlowLayout collectionView:collectionView layout:collectionView.collectionViewLayout referenceSizeForHeaderInSection:h];
                    if (size.height > 1.0) {
                        isEmptyHeader = NO;
                        isEmptyCell = NO;
                        break;
                    }
                }
            }
            
            // 如果Header没有高度还要判断Footer是否有高度
            if (isEmptyHeader) {
                if ([delegateFlowLayout respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
                    
                    for (int k = 0; k < sections; ++k) {
                        CGSize size = [delegateFlowLayout collectionView:collectionView layout:collectionView.collectionViewLayout referenceSizeForFooterInSection:k];
                        if (size.height > 1.0) {
                            isEmptyCell = NO;
                            break;
                        }
                    }
                }
            }
        }
        
    } else {
        if (self.hidden || self.alpha == 0) {
            isEmptyCell = NO;
        } else {
            isEmptyCell = YES;
        }
    }
    return isEmptyCell;
}

#pragma mark -=========== 自动添加提示View入口 ===========

/**
 *  处理自动根据表格数据来显示提示view
 */
- (void)convertShowTipView {
    //需要显示提示view
    if (self.automaticShowBlankView) {
        /** 给表格添加请求失败提示事件
         * <警告：这里如果有MJRefresh下拉刷新控件, 一定要延迟，因为MJRefresh库也替换了reloadData方法，否则不能收起刷新控件>
         */
        CGFloat delay = 0.0;
        if (self.mj_header || self.mj_footer) {
            delay = 0.5;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self judgeBlankView:[NSDictionary new]];
        });
    }
}

@end


@implementation NSObject (WXScrollViewSwizze)

+ (void)wx_exchangeInstanceMethod:(SEL)originSelector otherSelector:(SEL)otherSelector {
    method_exchangeImplementations(class_getInstanceMethod(self, originSelector), class_getInstanceMethod(self, otherSelector));
}
@end

#pragma mark -===========监听UITableView刷新方法===========

@implementation UITableView (ZFBlankPageView)

/**
 * 监听表格所有的刷新方法
 */
+ (void)load {
    //交换刷新表格方法
    [self wx_exchangeInstanceMethod:@selector(reloadData)
                      otherSelector:@selector(wx_reloadData)];
    //交换删除表格方法
    [self wx_exchangeInstanceMethod:@selector(deleteRowsAtIndexPaths:withRowAnimation:)
                      otherSelector:@selector(wx_deleteRowsAtIndexPaths:withRowAnimation:)];
    //交换刷新表格Sections方法
    [self wx_exchangeInstanceMethod:@selector(reloadSections:withRowAnimation:)
                      otherSelector:@selector(wx_reloadSections:withRowAnimation:)];
}

- (void)wx_reloadData {
    [self wx_reloadData];
    [self convertShowTipView];
}

- (void)wx_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                 withRowAnimation:(UITableViewRowAnimation)animation {
    [self wx_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self convertShowTipView];
}

- (void)wx_reloadSections:(NSIndexSet *)sections
         withRowAnimation:(UITableViewRowAnimation)animation {
    [self wx_reloadSections:sections withRowAnimation:animation];
    [self convertShowTipView];
}
@end

#pragma mark -===========监听UICollectionView刷新方法===========

@implementation UICollectionView (ZFBlankPageView)

/**
 * 监听CollectionView所有的刷新方法
 */
+ (void)load {
    [self wx_exchangeInstanceMethod:@selector(reloadData)
                      otherSelector:@selector(wx_reloadData)];

    [self wx_exchangeInstanceMethod:@selector(deleteSections:)
                      otherSelector:@selector(wx_deleteSections:)];

    [self wx_exchangeInstanceMethod:@selector(reloadSections:)
                      otherSelector:@selector(wx_reloadSections:)];

    [self wx_exchangeInstanceMethod:@selector(deleteItemsAtIndexPaths:)
                      otherSelector:@selector(wx_deleteItemsAtIndexPaths:)];

    [self wx_exchangeInstanceMethod:@selector(reloadItemsAtIndexPaths:)
                      otherSelector:@selector(wx_reloadItemsAtIndexPaths:)];
}

- (void)wx_reloadData {
    [self wx_reloadData];
    [self convertShowTipView];
}

- (void)wx_deleteSections:(NSIndexSet *)sections {
    [self wx_deleteSections:sections];
    [self convertShowTipView];
}

- (void)wx_reloadSections:(NSIndexSet *)sections {
    [self wx_reloadSections:sections];
    [self convertShowTipView];
}

- (void)wx_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self wx_deleteItemsAtIndexPaths:indexPaths];
    [self convertShowTipView];
}

- (void)wx_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self wx_reloadItemsAtIndexPaths:indexPaths];
    [self convertShowTipView];
}
@end
