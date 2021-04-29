//
//  ZXTableViewManager.m
//  ZXOwner
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoZX. All rights reserved.
//

#import "ZXTableViewManager.h"
#import "WXMacroDefiner.h"
#import "WXFrameDefiner.h"

@interface ZXTableViewManager ()
@property (nonatomic, copy)   NSString *cellIdentifier;
@end

@implementation ZXTableViewManager

/**
 * 创建表格dataSource (适用于相同类型的Cell)
 */
+ (instancetype)createWithCellClass:(NSArray<Class> *)cellClass {
    return [[ZXTableViewManager alloc] initWithClass:cellClass];
}

- (instancetype)initWithClass:(NSArray<Class> *)cellClass {
    self = [super init];
    if (self) {
        self.numberOfSections = 1;
//        NSAssert(cellClass.count == 0, @"必须要传入UITableViewCell类型来注册");
        _cellIdentifier = NSStringFromClass(cellClass.firstObject);
    }
    return self;
}

/**
 *  获取数组中的元素
 */
- (id)rowDataForIndexPath:(NSIndexPath *)indexPath {
    if (self.dataOfSections) {
        NSArray *arrary = self.dataOfSections(indexPath.section);
        if ([arrary isKindOfClass:[NSArray class]]) {
            if (arrary.count>indexPath.row) {
                return arrary[indexPath.row];
            }
        }
    } else if (self.plainTabDataArr) {
        NSArray *rowDataArr = self.plainTabDataArr;
        if ([rowDataArr isKindOfClass:[NSArray class]]) {
            if (indexPath.row < rowDataArr.count) {
                return rowDataArr[indexPath.row];
            }
        }
    }
    return nil;
}

#pragma mark -===========UITableViewDataSource===========

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataOfSections) {
        NSArray *arrary = self.dataOfSections(section);
        return arrary.count;
    } else {
        return self.plainTabDataArr.count;
    }
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id rowData = [self rowDataForIndexPath:indexPath];
    if (self.mutableCellForRowBlock) {
        return self.mutableCellForRowBlock(tableView, rowData, indexPath);
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.cellForRowBlock) {
            self.cellForRowBlock(cell, rowData, indexPath);
        } else {
            SEL sel = NSSelectorFromString(@"setDataModel:");
            if ([cell respondsToSelector:sel]) {
                WX_PerformSelectorLeakWarning(
                  [cell performSelector:sel withObject:rowData];
                );
            }
        }
        return cell;
    }
}

//隐藏最后一条细线
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    cell.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
    if (indexPath.row == ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kScreenWidth);
    }
}

#pragma mark -===========UITableViewDelegate===========

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.heightForRowBlcok) {
        id rowData = [self rowDataForIndexPath:indexPath];
        return self.heightForRowBlcok(rowData, indexPath);
    } else {
        return (tableView.rowHeight > 0) ? tableView.rowHeight : kDefaultCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.heightForSectionBlcok) {
        return self.heightForSectionBlcok(HeaderType, section);
    } else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.heightForSectionBlcok) {
        return self.heightForSectionBlcok(FooterType, section);
    } else {
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.viewForSectionBlcok) {
        return self.viewForSectionBlcok(HeaderType, section);
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.viewForSectionBlcok) {
        return self.viewForSectionBlcok(FooterType, section);
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectRowBlcok) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        id rowData = [self rowDataForIndexPath:indexPath];
        self.didSelectRowBlcok(cell, rowData, indexPath);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.didScrollBlock) {
        self.didScrollBlock(scrollView.contentOffset);
    }
}

- (void)dealloc {
    self.cellForRowBlock = nil;
    self.dataOfSections = nil;
    self.heightForRowBlcok = nil;
    self.heightForSectionBlcok = nil;
    self.viewForSectionBlcok = nil;
    self.didSelectRowBlcok = nil;
}

@end
