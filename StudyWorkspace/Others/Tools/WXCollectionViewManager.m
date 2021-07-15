//
//  WXCollectionViewManager.m
//  ZXOwner
//
//  Created by 610582 on 2020/8/28.
//  Copyright © 2020 51zxwang. All rights reserved.
//

#import "WXCollectionViewManager.h"
#import "WXMacroDefiner.h"

@interface WXCollectionViewManager ()
@property (nonatomic, assign) BOOL hasRegisterCell;
@end

@implementation WXCollectionViewManager

/**
 * 创建表格dataSource (适用于相同类型的Cell)
 */
+ (instancetype)createWithCellClass:(NSArray<Class> *)cellClases {
    return [[WXCollectionViewManager alloc] initWithClass:cellClases];
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

///手动注册所有 < UICollectionViewCell >
- (void)registerCollectionViewCell:(UICollectionView *)collectionView {
    NSLog(@"手动注册所有UITableViewCell: %@", self.cellClases);
    NSAssert(self.cellClases.count > 0, @"❌❌❌cellClases: 至少要传入一个UICollectionViewCell的类型来注册");
    
    for (Class cellClass in self.cellClases) {
        NSAssert([cellClass isSubclassOfClass:[UICollectionViewCell class]], @"❌❌❌初始化参数:cellClass 必须为UICollectionViewCell的类型");
        
        NSString *identifier = NSStringFromClass(cellClass);
        NSString *path = [[NSBundle mainBundle] pathForResource:identifier ofType:@"nib"];
        if (path.length > 0) { //isXibCell
            UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
            [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        } else {
            [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
        }
    }
}

/**
 *  获取数组中的元素
 */
- (id)itemDataForIndexPath:(NSIndexPath *)indexPath {
    if (self.dataOfSections) {
        NSArray *sectionArrary = self.dataOfSections(indexPath.section);
        if ([sectionArrary isKindOfClass:[NSArray class]]) {
            if (sectionArrary.count > indexPath.item) {
                return sectionArrary[indexPath.item];
            }
        }
    }
    return nil;
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MAX(self.numberOfSections, 1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataOfSections) {
        NSArray *arrary = self.dataOfSections(section);
        return arrary.count;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sizeForItemBlcok) {
        id rowData = [self itemDataForIndexPath:indexPath];
        return self.sizeForItemBlcok(rowData, indexPath);
        
    } else if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
        if (CGSizeEqualToSize(flowLayout.estimatedItemSize, CGSizeZero)) {
            return flowLayout.itemSize;
        } else {
            return flowLayout.estimatedItemSize;
        }
    }
    //警告不能使用: UICollectionViewFlowLayoutAutomaticSize
    return CGSizeMake(50.0, 50.0);//System Item Size
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.hasRegisterCell) {
        self.hasRegisterCell = YES;
        [self registerCollectionViewCell:collectionView];
    }
    id rowData = [self itemDataForIndexPath:indexPath];
    if (self.mutableCellForItemBlock) {
        return self.mutableCellForItemBlock(collectionView, rowData, indexPath);
    } else {
        NSString *identifier = NSStringFromClass((Class)self.cellClases.firstObject);
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if (self.cellForItemBlock) {
            self.cellForItemBlock(cell, rowData, indexPath);
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.didSelectItemBlcok) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        id rowData = [self itemDataForIndexPath:indexPath];
        self.didSelectItemBlcok(cell, rowData, indexPath);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.didScrollBlock) {
        self.didScrollBlock(scrollView);
    }
}

@end
