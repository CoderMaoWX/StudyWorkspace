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

///由子类覆盖: 表格需要注册的Cell <UITableViewCell.type>
- (NSArray<Class> *)registerTableViewCell;

///由子类覆盖: 配置表格Cell高度
@property (nonatomic, copy) ZXTableViewRowHeightBlock heightForRowBlcok;

///由子类覆盖: 配置表格数据方法
@property (nonatomic, copy) ZXTableViewConfigBlock cellForRowBlock;

///由子类覆盖: 点击表格代理方法
@property (nonatomic, copy) ZXTableViewConfigBlock didSelectRowBlcok;

///列表滚动回调
@property (nonatomic, copy) void (^didScrollBlock)(CGPoint contentOffset);

/**
 * TableView使用方法示例
 *
 ///由子类覆盖: 配置表格Cell高度 (警告: 父类不能复写次方法, 只能留给之类复写次方法)
 - (ZXTableViewRowHeightBlock)heightForRowBlcok {
     return ^CGFloat (id rowData, NSIndexPath *indexPath) {
         return kDefaultCellHeight;
     };
 }

 ///由子类覆盖: 配置表格数据方法
 - (ZXTableViewConfigBlock)cellForRowBlock {
     return ^(UITableViewCell *cell, id rowData, NSIndexPath *indexPath) {
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
     return ^(UITableViewCell *cell, id rowData, NSIndexPath *indexPath) {
         WX_Log(@"didSelectRowBlcok: %@", rowData)
     };
 }

 ///滚动列表回调
 - (void(^)(CGPoint contentOffset))didScrollBlock {
     return ^(CGPoint contentOffset) {
 
     };
 }
 */

#pragma mark -============== <UICollectionView> 配置父类表格数据和代理 ==============

///由子类覆盖: 表格需要注册的Cell
- (Class)registerCollectionViewCell;

///由子类覆盖: 配置表格布局样式
- (void)configFlowLayout:(UICollectionViewFlowLayout *)flowLayout;


///由子类覆盖: 配置表格Cell高度
@property (nonatomic, copy) ZXCollectionViewItemSizeBlock sizeForItemBlcok;

///由子类覆盖: 配置表格Cell
@property (nonatomic, copy) ZXCollectionViewConfigBlock cellForItemBlock;

///由子类覆盖: 点击表格代理方法
@property (nonatomic, copy) ZXCollectionViewConfigBlock didSelectItemBlcok;

/**
 * CollectionView使用方法示例
 *
 ///由子类覆盖: 配置表格布局样式
 - (void)configFlowLayout:(UICollectionViewFlowLayout *)flowLayout {
     flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
     flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, (isPhoneXSeries ? 34 : 12), 0);
     flowLayout.estimatedItemSize = CGSizeMake(94, 28);
 }

 ///由子类覆盖: 配置表格Cell高度 (警告: 父类不能复写次方法, 只能留给之类复写次方法)
 - (ZXCollectionViewItemSizeBlock)sizeForItemBlcok {
     return ^ CGSize (id itemData, NSIndexPath *indexPath) {
         return CGSizeMake(50.0, 50.0);
     };
 }

 ///由子类覆盖: 配置表格数据方法
 - (ZXCollectionViewConfigBlock)cellForItemBlock {
     return ^(UICollectionViewCell *cell, id itemData, NSIndexPath *indexPath) {
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
     return ^(UICollectionViewCell *cell, id itemData, NSIndexPath *indexPath) {
         WX_Log(@"didSelectItemBlcok: %@", itemData)
     };
 }
 
 ///滚动列表回调
 - (void(^)(CGPoint contentOffset))didScrollBlock {
     return ^(CGPoint contentOffset) {
 
     };
 }
 */

/** 返回上一页面  */
- (void)backBtnClick:(UIButton *)backBtn;

/** 父类释放时取消子类所有请求操作 */
- (void)cancelRequestSessionTask;

@end
