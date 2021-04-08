//
//  WXStudyBaseVC.h
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXPublicHeader.h"
#import "ZXCollectionViewManager.h"
#import "ZXTableViewManager.h"

typedef void (^ConfigCellBlock)(UITableViewCell * cell, id rowData, NSIndexPath *indexPath);

@interface WXStudyBaseVC : UIViewController

/// UITableView/UICollectionView的数据源代理
@property (nonatomic, strong) NSMutableArray            *listDataArray;

@property (nonatomic, strong) UITableView               *plainTableView;

@property (nonatomic, strong) UICollectionView          *collectionView;

/** 是否使用全屏返回手势 */
@property (nonatomic, assign) BOOL                      shouldPanBack;

/** 系统下拉刷新控件 */
@property (nonatomic, strong) UIRefreshControl          *refreshControl;

/** 子类请求对象数组 */
@property (nonatomic, strong) NSMutableArray            *requestTaskArr;

@property (nonatomic, copy) NSString                    *subTitle;

@property (nonatomic, copy) NSString                    *tipText;


#pragma mark -============== 布局页面子视图 ==============

/// 子类实现:添加子视图
- (void)wx_InitView;

/// 子类实现: 布局视图
- (void)wx_AutoLayoutView;


#pragma mark -============== <UITableView> 配置父类表格数据和代理 ==============

///由子类覆盖: 表格需要注册的Cell
- (Class)registerTableViewCell;

///由子类覆盖: 配置表格Cell高度
- (ZXTableViewRowHeightBlock)heightForRowBlcok;

///由子类覆盖: 配置表格数据方法
- (ZXTableViewConfigBlock)cellForRowBlock;

///由子类覆盖: 点击表格代理方法
- (ZXTableViewConfigBlock)didSelectRowBlcok;


///滚动列表回调
- (void(^)(CGPoint contentOffset))didScrollBlock;



#pragma mark -============== <UICollectionView> 配置父类表格数据和代理 ==============

///由子类覆盖: 表格需要注册的Cell
- (Class)registerCollectionViewCell;

///由子类覆盖: 配置表格布局样式
- (void)configFlowLayout:(UICollectionViewFlowLayout *)flowLayout;

///由子类覆盖: 配置表格Cell大小
- (ZXCollectionViewItemSizeBlock)sizeForItemBlcok;

///由子类覆盖: 配置表格数据方法
- (ZXCollectionViewConfigBlock)cellForItemBlock;

///由子类覆盖: 点击表格代理方法
- (ZXCollectionViewConfigBlock)didSelectItemBlcok;



///添加一个透明视图让事件传递到顶层,使其能够侧滑返回
- (void)showLeftSlidBackView;

/** 返回上一页面  */
- (void)backBtnClick:(UIButton *)backBtn;

/** 父类释放时取消子类所有请求操作 */
- (void)cancelRequestSessionTask;

@end
