//
//  ZXCollectionViewManager.h
//  ZXOwner
//
//  Created by 610582 on 2020/8/28.
//  Copyright © 2020 51zxwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef CGSize (^ZXCollectionViewItemSizeBlock) (id itemData, NSIndexPath *indexPath);
typedef void (^ZXCollectionViewDidScrollBlock) (UIScrollView *scrollView);
typedef void (^ZXCollectionViewCellBlock) (id cell, id rowData, NSIndexPath *indexPath);
typedef UICollectionViewCell* (^ZXCollectionViewMutableCellBlock) (UICollectionView *collectionView, id rowData, NSIndexPath *indexPath);

/**
 * 默认为单组的CollectionView
 */
@interface ZXCollectionViewManager : NSObject<UICollectionViewDelegate, UICollectionViewDataSource>

/**
 * 配置表格Cell, 不同类型的Cell就传多个, 相同就传一个, eg: @[ [UICollectionViewCell Class], ... ]
 */
+ (instancetype)createWithCellClass:(NSArray<Class> *)cellClases;

/**
 * 可临时配置表格Cell, 不同类型的Cell就传多个, 相同就传一个, eg: @[ [UICollectionViewCell Class], ... ]
 */
@property (nonatomic, strong) NSArray<NSArray<Class> *> *cellClases;


/** numberOfSections组数目, 默认为:1 */
@property (nonatomic, assign) NSInteger numberOfSections;

/** 多组时: 获取每组的数据源 */
@property (nonatomic, strong) NSArray * (^dataOfSections)(NSInteger section);


/** 获取每个Item的大小Block */
@property (nonatomic, copy) ZXCollectionViewItemSizeBlock sizeForItemBlcok;


/** 配置相同类型的Cell回调 (和mutableCellForRowBlock二选一) */
@property (nonatomic, copy) ZXCollectionViewCellBlock cellForItemBlock;

/** 配置不同类型的Cell回调 (和cellForRowBlock二选一) */
@property (nonatomic, copy) ZXCollectionViewMutableCellBlock mutableCellForItemBlock;

/** 点击Cell回调 */
@property (nonatomic, copy) ZXCollectionViewCellBlock didSelectItemBlcok;

/** 滚动列表回调 */
@property (nonatomic, copy) ZXCollectionViewDidScrollBlock didScrollBlock;


/**
 *  获取数组中的元素
 */
- (id)itemDataForIndexPath:(NSIndexPath *)indexPath;

@end
