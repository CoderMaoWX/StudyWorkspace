//
//  WXTableViewManager.m
//  ZXOwner
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoZX. All rights reserved.
//

#import "WXTableViewManager.h"
#import "WXMacroDefiner.h"
#import "WXFrameDefiner.h"

@interface WXTableViewManager ()
@property (nonatomic, assign) BOOL hasRegisterCell;
@end

@implementation WXTableViewManager

/**
 * 创建表格dataSource (适用于相同类型的Cell)
 */
+ (instancetype)createWithCellClass:(NSArray<Class> *)cellClases {
    return [[WXTableViewManager alloc] initWithClass:cellClases];
}

- (instancetype)initWithClass:(NSArray<Class> *)cellClases {
    self = [super init];
    if (self) {
        self.cellClases = cellClases;
    }
    return self;
}

- (void)setCellClases:(NSArray<Class> *)cellClases {
    _cellClases = cellClases;
    self.hasRegisterCell = NO;
}

///手动注册所有 < UITableViewCell >
- (void)registerTableViewCell:(UITableView *)tableView {
    NSLog(@"手动注册所有UITableViewCell: %@", self.cellClases);
    NSAssert(self.cellClases.count > 0, @"❌❌❌cellClases: 至少要传入一个UITableViewCell的类型来注册");
    
    for (Class cellClass in self.cellClases) {
        NSAssert([cellClass isSubclassOfClass:[UITableViewCell class]], @"❌❌❌初始化参数:cellClass 必须为UITableViewCell的类型");
        
        NSString *identifier = NSStringFromClass(cellClass);
        NSString *path = [[NSBundle mainBundle] pathForResource:identifier ofType:@"nib"];
        if (path.length > 0) { //isXibCell
            UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
        } else {
            [tableView registerClass:cellClass forCellReuseIdentifier:identifier];
        }
    }
}

/**
 *  获取数组中的元素
 */
- (id)rowDataForIndexPath:(NSIndexPath *)indexPath {
    if (self.dataOfSections) {
        NSArray *sectionArrary = self.dataOfSections(indexPath.section);
        if ([sectionArrary isKindOfClass:[NSArray class]]) {
            if (sectionArrary.count > indexPath.row) {
                return sectionArrary[indexPath.row];
            }
        }
    }
    return nil;
}

#pragma mark -===========UITableViewDataSource===========

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MAX(self.numberOfSections, 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataOfSections) {
        NSArray *arrary = self.dataOfSections(section);
        return arrary.count;
    }
    return 0;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.hasRegisterCell) {
        self.hasRegisterCell = YES;
        [self registerTableViewCell:tableView];
    }
    id rowData = [self rowDataForIndexPath:indexPath];
    if (self.mutableCellForRowBlock) {
        return self.mutableCellForRowBlock(tableView, rowData, indexPath);
    } else {
        NSString *identifier = NSStringFromClass((Class)self.cellClases.firstObject);
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
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
        self.didScrollBlock(scrollView);
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
