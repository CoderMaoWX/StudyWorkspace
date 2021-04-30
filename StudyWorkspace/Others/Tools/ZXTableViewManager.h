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
} ZXSectionType;

@interface ZXTableViewManager<CellType: UITableViewCell *> : NSObject<UITableViewDelegate,UITableViewDataSource>

typedef CGFloat (^ZXTableViewRowHeightBlock) (id rowData, NSIndexPath *indexPath);
typedef void (^ZXTableViewConfigBlock) (CellType cell, id rowData, NSIndexPath *indexPath);
typedef void (^ZXTableViewDidScrollBlock) (CGPoint contentOffset);
typedef UITableViewCell* (^ZXTableViewMutableCellBlock) (UITableView *tableView, id rowData, NSIndexPath *indexPath);

/**
 * 配置表格Cell, 不同类型的Cell就传多个, 单组就传一个, eg: @[ [UITableViewCell Class] ]
 */
+ (instancetype)createWithCellClass:(NSArray<Class> *)cellClases;

/**
 * 配置表格Cell, 不同类型的Cell就传多个, 单组就传一个, eg: @[ [UITableViewCell Class] ]
 */
@property (nonatomic, strong) NSArray<NSArray<Class> *> *cellClases;



/** numberOfSections组数目, 默认为:1 */
@property (nonatomic, assign) NSInteger numberOfSections;

/** 多组时: 获取每组的数据源 */
@property (nonatomic, strong) NSArray * (^dataOfSections)(NSInteger section);

/** 获取SectionView高度Block */
@property (nonatomic, copy) CGFloat (^heightForSectionBlcok)(ZXSectionType sectionType, NSInteger section);

/** 获取SectionView的Block */
@property (nonatomic, copy) UIView * (^viewForSectionBlcok)(ZXSectionType sectionType, NSInteger section);

/** 获取Row高度Block */
@property (nonatomic, copy) ZXTableViewRowHeightBlock heightForRowBlcok;

/** 配置相同类型的Cell回调 */
@property (nonatomic, copy) ZXTableViewConfigBlock cellForRowBlock;

/** 配置不同类型的Cell回调 */
@property (nonatomic, copy) ZXTableViewMutableCellBlock mutableCellForRowBlock;

/** 点击Cell回调 */
@property (nonatomic, copy) ZXTableViewConfigBlock didSelectRowBlcok;

/** 滚动列表回调 */
@property (nonatomic, copy) ZXTableViewDidScrollBlock didScrollBlock;

/**
 *  获取表中元素
 */
- (id)rowDataForIndexPath:(NSIndexPath *)indexPath;

@end


