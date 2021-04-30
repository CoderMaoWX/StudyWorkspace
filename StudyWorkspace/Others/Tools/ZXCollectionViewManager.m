//
//  ZXCollectionViewManager.m
//  ZXOwner
//
//  Created by 610582 on 2020/8/28.
//  Copyright © 2020 51zxwang. All rights reserved.
//

#import "ZXCollectionViewManager.h"
#import "WXMacroDefiner.h"

@interface ZXCollectionViewManager ()
@property (nonatomic, strong) Class CellCalss;
@property (nonatomic, assign) BOOL isXibCell;
@property (nonatomic, assign) BOOL hasRegisterCell;
@property (nonatomic, copy)   NSString *cellIdentifier;
@end

@implementation ZXCollectionViewManager

/**
 * 创建表格dataSource (适用于相同类型的Cell)
 */
+ (instancetype)createWithCellClass:(Class)cellClass {
    return [[ZXCollectionViewManager alloc] initWithClass:cellClass];
}

- (instancetype)initWithClass:(Class)cellClass {
    self = [super init];
    if (self) {
        NSAssert([cellClass isSubclassOfClass:[UICollectionViewCell class]], @"❌❌❌初始化参数:cellClass 必须为UICollectionViewCell的类型");
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
- (id)itemDataForIndexPath:(NSIndexPath *)indexPath {
    NSArray *rowDataArr = self.listDataArray;
    if ([rowDataArr isKindOfClass:[NSArray class]]) {
        if (indexPath.row < rowDataArr.count) {
            return rowDataArr[indexPath.item];
        }
    }
    return nil;
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listDataArray.count;
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
        if (self.isXibCell) {
            UINib *nib = [UINib nibWithNibName:_cellIdentifier bundle:nil];
            [collectionView registerNib:nib forCellWithReuseIdentifier:_cellIdentifier];
        } else {
            [collectionView registerClass:_CellCalss forCellWithReuseIdentifier:_cellIdentifier];
        }
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];

    id itemData = [self itemDataForIndexPath:indexPath];
    if (self.cellForItemBlock) {
        self.cellForItemBlock(cell, itemData, indexPath);
    } else {
        SEL sel = NSSelectorFromString(@"setDataModel:");
        if ([cell respondsToSelector:sel]) {
            WX_PerformSelectorLeakWarning(
              [cell performSelector:sel withObject:itemData];
            );
        }
    }
    return cell;
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
