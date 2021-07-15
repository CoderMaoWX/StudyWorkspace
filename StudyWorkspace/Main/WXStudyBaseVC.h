//
//  WXStudyBaseVC.h
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXPublicHeader.h"
#import "WXCollectionViewManager.h"
#import "WXTableViewManager.h"

typedef void (^ConfigCellBlock)(UITableViewCell * cell, id rowData, NSIndexPath *indexPath);

@interface WXStudyBaseVC : UIViewController

/** 是否使用全屏返回手势 */
@property (nonatomic, assign) BOOL                              shouldPanBack;

/** 系统下拉刷新控件 */
@property (nonatomic, strong) UIRefreshControl                  *refreshControl;

/** 子类请求对象数组 */
@property (nonatomic, strong) NSMutableArray                    *requestTaskArr;

@property (nonatomic, copy) NSString                            *subTitle;

@property (nonatomic, copy) NSString                            *tipText;

/**
 * UITableView/UICollectionView的数据源代理
 * 注意: 两个列表的使用的数据源都是: self.listDataArray
 * 警告: 页面上不要同事出现UITableView/UICollectionView两个列表
 */
@property (nonatomic, strong) NSMutableArray                    *listDataArray;

/// 懒加载的UITableView列表
@property (nonatomic, strong) UITableView                       *plainTableView;

@property (nonatomic,strong,readonly) WXTableViewManager        *tableViewManager;

/// 懒加载的UICollectionView列表
@property (nonatomic, strong) UICollectionView                  *collectionView;

@property (nonatomic,strong,readonly) WXCollectionViewManager   *collectionViewManager;


#pragma mark -============== 布局页面子视图 ==============

/// 子类实现:添加子视图
- (void)wx_InitView;

/// 子类实现: 布局视图
- (void)wx_AutoLayoutView;


#pragma mark -============== <UITableView> 配置父类表格数据和代理 ==============

// ///由子类覆盖: 表格需要注册的Cell <UITableViewCell.type>
// - (NSArray<Class> *)registerTableViewCell {
//     return @[
//         [UITableViewCell1 class],
//         [UITableViewCell2 class],
//         ...
//      ];
// }
- (NSArray<Class> *)registerTableViewCell;

// ///由子类覆盖: 配置表格Cell高度 (警告: 父类不能复写次方法, 只能留给之类复写次方法)
// - (WXTableViewRowHeightBlock)heightForRowBlcok {
//     return ^CGFloat (id rowData, NSIndexPath *indexPath) {
//         return kDefaultCellHeight; 或者: UITableViewAutomaticDimension;
//     };
// }
@property (nonatomic, copy) WXTableViewRowHeightBlock heightForRowBlcok;

// ///由子类覆盖: 配置相同类型Cell表格
// - (WXTableViewCellBlock)cellForRowBlock {
//     return ^(UITableViewCell *cell, id rowData, NSIndexPath *indexPath) {
//         WX_Log(@"cellForRowAtIndexPath: %@", cell)
//
//         SEL sel = NSSelectorFromString(@"setDataModel:");
//         if ([cell respondsToSelector:sel]) {
//             WX_PerformSelectorLeakWarning(
//               [cell performSelector:sel withObject:rowData];
//             );
//         }
//     };
// }
@property (nonatomic, copy) WXTableViewCellBlock cellForRowBlock;


// ///由子类覆盖: 根据数据自定义配置不同类型Cell表格
//- (WXTableViewMutableCellBlock)mutableCellForRowBlock {
//    return ^UITableViewCell* (UITableView *tableView, NSDictionary *rowData, NSIndexPath *indexPath) {
//        UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([xxxCell class]) forIndexPath:indexPath];
//        if (![rowData isKindOfClass:[NSDictionary class]]) return c;
//        NSString *name = rowData.allKeys.firstObject;
//        WXStudyCell *cell = (WXStudyCell *)c;
//        cell.titleLabel.text = name;
//        cell.subTitleLabel.text = rowData[name];
//        return c;
//    };
//}
@property (nonatomic, copy) WXTableViewMutableCellBlock mutableCellForRowBlock;


// ///由子类覆盖: 点击表格代理方法
// - (WXTableViewCellBlock)didSelectRowBlcok {
//     return ^(UITableViewCell *cell, id rowData, NSIndexPath *indexPath) {
//         WX_Log(@"didSelectRowBlcok: %@", rowData)
//     };
// }
@property (nonatomic, copy) WXTableViewCellBlock didSelectRowBlcok;

// ///滚动列表回调
// - (void(^)(CGPoint contentOffset))didScrollBlock {
//     return ^(CGPoint contentOffset) {
//     };
// }
@property (nonatomic, copy) void (^didScrollBlock)(UIScrollView *scrollView);



#pragma mark -============== <UICollectionView> 配置父类表格数据和代理 ==============

// ///由子类覆盖: 表格需要注册的Cell <UICollectionViewCell.type>
// - (NSArray<Class> *)registerCollectionCell {
//     return @[
//         [UICollectionViewCell1 class],
//         [UICollectionViewCell2 class],
//         ...
//      ];
// }
- (NSArray<Class> *)registerCollectionViewCell;

// ///由子类覆盖: 配置表格布局样式
// - (void)configFlowLayout:(UICollectionViewFlowLayout *)flowLayout {
//     flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//     flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, (isPhoneXSeries ? 34 : 12), 0);
//     flowLayout.estimatedItemSize = CGSizeMake(94, 28);
// }
- (void)configFlowLayout:(UICollectionViewFlowLayout *)flowLayout;


// ///由子类覆盖: 配置表格Cell高度 (警告: 父类不能复写次方法, 只能留给之类复写次方法)
// - (WXCollectionViewItemSizeBlock)sizeForItemBlcok {
//     return ^ CGSize (id itemData, NSIndexPath *indexPath) {
//         return CGSizeMake(50.0, 50.0);
//     };
// }
@property (nonatomic, copy) WXCollectionViewItemSizeBlock sizeForItemBlcok;

// ///由子类覆盖: 配置表格数据方法
// - (ZXCollectionViewConfigBlock)cellForItemBlock {
//     return ^(UICollectionViewCell *cell, id itemData, NSIndexPath *indexPath) {
//         WX_Log(@"cellForItemAtIndexPath: %@", cell)
//         SEL sel = NSSelectorFromString(@"setDataModel:");
//         if ([cell respondsToSelector:sel]) {
//             WX_PerformSelectorLeakWarning(
//               [cell performSelector:sel withObject:itemData];
//             );
//         }
//     };
// }
@property (nonatomic, copy) WXCollectionViewCellBlock cellForItemBlock;

// ///由子类覆盖: 根据数据自定义配置不同类型Cell表格
//- (WXTableViewMutableCellBlock)mutableCellForRowBlock {
//    return ^UICollectionViewCell* (UICollectionView *collectionView, NSDictionary *rowData, NSIndexPath *indexPath) {
//        UICollectionViewCell *c = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([xxxCell class]) forIndexPath:indexPath];
//        if (![rowData isKindOfClass:[NSDictionary class]]) return c;
//        NSString *name = rowData.allKeys.firstObject;
//        WXStudyCell *cell = (WXStudyCell *)c;
//        cell.titleLabel.text = name;
//        cell.subTitleLabel.text = rowData[name];
//        return c;
//    };
//}
@property (nonatomic, copy) WXCollectionViewMutableCellBlock mutableCellForItemBlock;


// ///由子类覆盖: 点击表格代理方法
// - (WXCollectionViewCellBlock)didSelectItemBlcok {
//     return ^(UICollectionViewCell *cell, id itemData, NSIndexPath *indexPath) {
//         WX_Log(@"didSelectItemBlcok: %@", itemData)
//     };
// }
@property (nonatomic, copy) WXCollectionViewCellBlock didSelectItemBlcok;


/** 返回上一页面  */
- (void)goBackAction;


/** 父类释放时取消子类所有请求操作 */
- (void)cancelRequestSessionTask;

@end
