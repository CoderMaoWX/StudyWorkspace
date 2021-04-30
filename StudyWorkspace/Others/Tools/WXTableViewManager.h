//
//  WXTableViewManager.h
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

typedef CGFloat (^WXTableViewRowHeightBlock) (id rowData, NSIndexPath *indexPath);
typedef CGFloat (^WXTableViewSectionHeightBlock) (ZXSectionType sectionType, NSInteger section);
typedef UIView* (^WXTableViewSectionViewBlock) (ZXSectionType sectionType, NSInteger section);
typedef void (^WXTableViewCellBlock) (id cell, id rowData, NSIndexPath *indexPath);
typedef UITableViewCell* (^WXTableViewMutableCellBlock) (UITableView *tableView, id rowData, NSIndexPath *indexPath);
typedef void (^WXTableViewDidScrollBlock) (UIScrollView *scrollView);

@interface WXTableViewManager : NSObject<UITableViewDelegate,UITableViewDataSource>

/**
 * 配置表格Cell, 不同类型的Cell就传多个, 相同就传一个, eg: @[ [UITableViewCell Class], ... ]
 */
+ (instancetype)createWithCellClass:(NSArray<Class> *)cellClases;

/**
 * 可临时配置表格Cell, 不同类型的Cell就传多个, 相同就传一个, eg: @[ [UITableViewCell Class], ... ]
 */
@property (nonatomic, strong) NSArray<NSArray<Class> *> *cellClases;


/** numberOfSections组数目, 默认为:1 */
@property (nonatomic, assign) NSInteger numberOfSections;

/** 多组时: 获取每组的数据源 */
@property (nonatomic, strong) NSArray * (^dataOfSections)(NSInteger section);

/** 获取SectionView高度Block */
@property (nonatomic, copy) WXTableViewSectionHeightBlock heightForSectionBlcok;

/** 获取SectionView的Block */
@property (nonatomic, copy) WXTableViewSectionViewBlock viewForSectionBlcok;

/** 获取Row高度Block */
@property (nonatomic, copy) WXTableViewRowHeightBlock heightForRowBlcok;

/** 配置相同类型的Cell回调 (和mutableCellForRowBlock二选一) */
@property (nonatomic, copy) WXTableViewCellBlock cellForRowBlock;

/** 配置不同类型的Cell回调 (和cellForRowBlock二选一) */
@property (nonatomic, copy) WXTableViewMutableCellBlock mutableCellForRowBlock;

/** 点击Cell回调 */
@property (nonatomic, copy) WXTableViewCellBlock didSelectRowBlcok;

/** 滚动列表回调 */
@property (nonatomic, copy) WXTableViewDidScrollBlock didScrollBlock;

/**
 *  获取表中元素
 */
- (id)rowDataForIndexPath:(NSIndexPath *)indexPath;

@end


