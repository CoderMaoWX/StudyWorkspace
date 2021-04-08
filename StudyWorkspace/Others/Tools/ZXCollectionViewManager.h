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
typedef void (^ZXCollectionViewConfigBlock) (id cell, id itemData, NSIndexPath *indexPath);
typedef void (^ZXCollectionViewDidScrollBlock) (CGPoint contentOffset);

/**
 * 默认为单组的CollectionView
 */
@interface ZXCollectionViewManager : NSObject<UICollectionViewDelegate, UICollectionViewDataSource>

/** 单组的数据源 */
@property (nonatomic, strong) NSArray *listDataArray;

/** 获取每个Item的大小Block */
@property (nonatomic, copy) ZXCollectionViewItemSizeBlock sizeForItemBlcok;

/** 配置表格Cell */
@property (nonatomic, copy) ZXCollectionViewConfigBlock cellForItemBlock;

/** 点击Cell回调 */
@property (nonatomic, copy) ZXCollectionViewConfigBlock didSelectItemBlcok;

/** 滚动列表回调 */
@property (nonatomic, copy) ZXCollectionViewDidScrollBlock didScrollBlock;

/**
 * 创建表格dataSource (适用于相同类型的Cell)
 */
+ (instancetype)createWithCellClass:(Class)cellClass;

/**
 *  获取数组中的元素
 */
- (id)itemDataForIndexPath:(NSIndexPath *)indexPath;

@end
