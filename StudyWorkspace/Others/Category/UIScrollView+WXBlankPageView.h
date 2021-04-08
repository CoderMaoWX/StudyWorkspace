//
//  UIScrollView+WXBlankPageView.h
//  CommonFrameWork
//
//  Created by mao wangxin on 2017/4/17.
//  Copyright © 2017年 MaoWX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

//判断表格数据空白页和分页的字段key
static NSString *const kBlankViewTotalPageKey    = @"pageCount";
static NSString *const kBlankViewCurrentPageKey  = @"curPage";
static NSString *const kBlankViewListKey         = @"list";


/** 进入刷新状态的回调 */
typedef void (^WXRefreshingBlock)(void);

typedef enum : NSUInteger {
    WXBlankTipViewStatus_Normal,        //0 正常状态
    WXBlankTipViewStatus_EmptyData,     //1 空数据状态
    WXBlankTipViewStatus_Fail,          //2 请求失败状态
    WXBlankTipViewStatus_NoNetWork,     //3 网络连接失败状态
} WXBlankTipViewStatus;

@interface UIScrollView (WXBlankPageView)

/**
 * 以下所有的属性需要配合 <judgeBlankView:> 方法使用
 */

/** 空数据标题 */
@property (nonatomic, copy) NSString *emptyDataTitle;
/** 空数据副标题 */
@property (nonatomic, copy) NSString *emptyDataSubTitle;
/** 空数据图片 */
@property (nonatomic, strong) UIImage *emptyDataImage;
/** 空数据按钮标题 */
@property (nonatomic, copy) NSString *emptyDataBtnTitle;


/** 请求失败文字 */
@property (nonatomic, copy) NSString *requestFailTitle;
/** 请求失败图片 */
@property (nonatomic, strong) UIImage *requestFailImage;
/** 请求失败按钮 */
@property (nonatomic, copy) NSString *requestFailBtnTitle;


/** 网络连接失败文字 */
@property (nonatomic, copy) NSString *networkErrorTitle;
/** 网络连接失败图片 */
@property (nonatomic, strong) UIImage *networkErrorImage;
/** 网络连接失败按钮 */
@property (nonatomic, copy) NSString *networkErrorBtnTitle;

/** 按钮点击的事件 */
@property (nonatomic, copy) void (^blankTipViewActionBlcok)(WXBlankTipViewStatus status);

/**
 * 一个属性即可自动设置显示请求提示view,(但是在请求失败时只能显示无数据提示)
 * 此方法一定要放在请求数据回来时的reloadData之前设置此属性效果才正常
 */
@property(nonatomic, assign) BOOL automaticShowBlankView;


/** 外部可控制整体View的中心点上下偏移位置 {0, 0}:表示上下居中显示, 默认居中显示 */
@property(nonatomic, assign) CGPoint blankViewOffsetPoint;

/**
 * 配置下拉列表分页标识
 * 当前类配合调用 -judgeBlankView: 方法来决定是否能显示下一页控件
 */
NSDictionary* ZXManageMorePageInfo(NSDictionary *dataDict);


#pragma mark -- 给表格添加上下拉刷新事件

/**
 初始化表格的上下拉刷新控件
 
 @param headerBlock 下拉刷新需要调用的函数
 @param footerBlock 上拉刷新需要调用的函数
 @param startRefreshing 是否需要立即刷新
 */
- (void)addHeaderRefreshBlock:(WXRefreshingBlock)headerBlock
           footerRefreshBlock:(WXRefreshingBlock)footerBlock
              startRefreshing:(BOOL)startRefreshing;

/**
 * 开始加载头部数据
 
 @param animation 加载时是否需要动画
 */
- (void)headerRefreshingByAnimation:(BOOL)animation;


#pragma mark -- 处理表格上下拉刷新,分页,添加空白页事件

/**
 此方法作用: 调用后会自动收起表格上下拉刷新控件, 判断分页逻辑, 添加数据空白页等操作
 调用条件：  必须要在UITableView/UICollectionView 实例的reloadData方法执行后调用才能生效
 
 @param totalCurrentPageInfo 页面上表格分页数据 "pageCount"数 与 "curPage"数 包装的字典
 
 1. 页面请求成功样例:
 [self.tableView reloadData];
 NSDictionary *pageDic = @{kTotalPageKey   : @(self.model.pageCount),
                           kCurrentPageKey : @(self.model.curPage)};
 [self.tableView judgeBlankView:pageDic];
 
 2. 页面请求失败样例:
 [self.tableView judgeBlankView:nil];
 */
- (void)judgeBlankView:(NSDictionary *)totalCurrentPageInfo;

/**
 * 处理空白页 <此方法与上方法作用相同>
 */
- (void)judgeBlankViewCurrentPage:(NSNumber *)currentPage totalPage:(NSNumber *)totalPage;

//移除
- (void)removeBlankView;

@end

