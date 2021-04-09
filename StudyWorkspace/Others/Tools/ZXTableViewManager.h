//
//  ZXTableViewManager.h
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HeaderType,
    FooterType,
} SectionType;


@interface ZXTableViewManager<CellType: UITableViewCell *> : NSObject<UITableViewDelegate,UITableViewDataSource>

typedef CGFloat (^ZXTableViewRowHeightBlock) (id rowData, NSIndexPath *indexPath);
typedef void (^ZXTableViewConfigBlock) (CellType cell, id rowData, NSIndexPath *indexPath);
typedef void (^ZXTableViewDidScrollBlock) (CGPoint contentOffset);


/** numberOfSections组数目, 默认为1组 */
@property (nonatomic, assign) NSInteger numberOfSections;

/** 单组的数据源 */
@property (nonatomic, strong) NSArray *plainTabDataArr;

/** 多组时: 获取每组的数据源 */
@property (nonatomic, strong) NSArray* (^dataOfSections)(NSInteger section);

/** 获取SectionView高度Block */
@property (nonatomic, copy) CGFloat (^heightForSectionBlcok)(SectionType sectionType, NSInteger section);

/** 获取SectionView的Block */
@property (nonatomic, copy) UIView * (^viewForSectionBlcok)(SectionType sectionType, NSInteger section);

/** 获取Row高度Block */
@property (nonatomic, copy) ZXTableViewRowHeightBlock heightForRowBlcok;

/** 配置表格Cell */
@property (nonatomic, copy) ZXTableViewConfigBlock cellForRowBlock;

/** 点击Cell回调 */
@property (nonatomic, copy) ZXTableViewConfigBlock didSelectRowBlcok;

/** 滚动列表回调 */
@property (nonatomic, copy) ZXTableViewDidScrollBlock didScrollBlock;

/**
 * 创建表格dataSource (适用于相同类型的Cell)
 */
+ (instancetype)createWithCellClass:(Class)cellClass;

/**
 *  获取数组中的元素
 */
- (id)rowDataForIndexPath:(NSIndexPath *)indexPath;

@end


