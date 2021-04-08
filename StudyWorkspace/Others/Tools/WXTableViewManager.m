//
//  WXTableViewManager.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "WXTableViewManager.h"
#import "WXPublicHeader.h"

@interface WXTableViewManager ()
@property (nonatomic, strong) Class CellCalss;
@property (nonatomic, assign) BOOL isXibCell;
@property (nonatomic, assign) BOOL hasRegisterCell;
@property (nonatomic, copy)   NSString *cellIdentifier;
@end

@implementation WXTableViewManager

/**
 * 创建表格dataSource (适用于相同类型的Cell)
 */
+ (instancetype)createWithCellClass:(Class)cellClass {
    return [[WXTableViewManager alloc] initWithClass:cellClass];
}

- (instancetype)initWithClass:(Class)cellClass {
    self = [super init];
    if (self) {
        NSAssert([cellClass isSubclassOfClass:[UITableViewCell class]], @"❌❌❌初始化参数:cellClass 必须为UITableViewCell的类型");
        _CellCalss = cellClass;
        _cellIdentifier = NSStringFromClass(cellClass);
        NSString *path = [[NSBundle mainBundle] pathForResource:_cellIdentifier ofType:@"nib"];
        _isXibCell = (path.length>0);
    }
    return self;
}

/**
 *  获取数组中的元素
 */
- (id)rowDataForIndexPath:(NSIndexPath *)indexPath {
    if (self.groupTabDataOfSections) {
        NSArray *arrary = self.groupTabDataOfSections(indexPath.section);
        if ([arrary isKindOfClass:[NSArray class]]) {
            if (arrary.count>indexPath.row) {
                return arrary[indexPath.row];
            }
        }
    } else if (self.plainTabDataArrBlcok) {
        NSArray *rowDataArr = self.plainTabDataArrBlcok();
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
    if (self.groupTabNumberOfSections) {
        return self.groupTabNumberOfSections();
    } else {
        return (self.plainTabDataArrBlcok && self.plainTabDataArrBlcok().count != 0) ? 1 : 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.groupTabDataOfSections) {
        NSArray *arrary = self.groupTabDataOfSections(section);
        return arrary.count;
    } else {
        return self.plainTabDataArrBlcok ? self.plainTabDataArrBlcok().count : 0;
    }
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.hasRegisterCell) {
        self.hasRegisterCell = YES;
        if (self.isXibCell) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass(_CellCalss) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:_cellIdentifier];
        } else {
            [tableView registerClass:_CellCalss forCellReuseIdentifier:_cellIdentifier];
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];

    id rowData = [self rowDataForIndexPath:indexPath];
    if (self.cellForRowBlock) {
        self.cellForRowBlock(cell, rowData, indexPath);
    } else {
        SEL sel = NSSelectorFromString(@"setDataModel:");
        if ([cell respondsToSelector:sel]) {
            ZXPerformSelectorLeakWarning(
              [cell performSelector:sel withObject:rowData];
            );
        }
    }
    return cell;
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
        id rowData = [self rowDataForIndexPath:indexPath];
        self.didSelectRowBlcok(rowData, indexPath);
    }
}

-(void)dealloc{
    self.cellForRowBlock = nil;
    self.groupTabNumberOfSections = nil;
    self.groupTabDataOfSections = nil;
    self.plainTabDataArrBlcok = nil;
    self.heightForRowBlcok = nil;
    self.heightForSectionBlcok = nil;
    self.viewForSectionBlcok = nil;
    self.didSelectRowBlcok = nil;
}

@end

