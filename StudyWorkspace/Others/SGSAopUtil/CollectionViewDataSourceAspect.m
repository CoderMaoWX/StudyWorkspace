//
//  CollectionViewDataSourceAspect.m
//  StudyWorkspace
//
//  Created by 610582 on 2023/11/16.
//  Copyright © 2023 MaoWX. All rights reserved.
//

#import "CollectionViewDataSourceAspect.h"
#import "SGSAopUtil.h"

@implementation CollectionViewDataSourceAspect

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"【Generate Cell】%@:%zd-%zd",collectionView, indexPath.section, indexPath.item);
    return sgs_AOP_callOriginalSelector();
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"【Generate Cell】%@:%zd-%zd",tableView, indexPath.section, indexPath.item);
    return sgs_AOP_callOriginalSelector();
}

@end
