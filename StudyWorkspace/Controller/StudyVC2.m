//
//  StudyVC2.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "StudyVC2.h"
#import "WXDataModel.h"

@interface StudyVC2 ()

@end

@implementation StudyVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self testNSPredicate];
}

#pragma mark - ====================== <NSPredicate> ======================

- (void)testNSPredicate {
    //熟悉Predicate
//    [self testPredicateDefinition];
    
    //学习Predicate的比较功能
    [self testPredicateComparation];
    
    //学习Predicate范围运算功能
    //[self testPredicateRange];
    
    //学习Predicate 与自身相比的功能
    //[self testPredicateComparationToSelf];
    
    //学习Predicate 字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
    //[self testPredicateRelateToNSString];
    
    //学习Predicate 的通配
    //[self testPredicateWildcard];
    
    //学习Predicate自定义对象通配
    //[self testPredicateCutomObject];
}

/* Predicate 的通配
 (5)通配符：LIKE
 例：@"name LIKE[cd] '*er*'"
 //  *代表通配符,Like也接受[cd].
 @"name LIKE[cd] '???er*'"
 */
- (void)testPredicateWildcard{
    NSArray *placeArray = [NSArray arrayWithObjects:@"Shanghai",@"Hangzhou",@"Beijing",@"Macao",@"Taishan", nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF  like '*ai*' "];
    
    NSArray *tempArray = [placeArray filteredArrayUsingPredicate:predicate];
    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj == %@",obj);
    }];
}

/* Predicate 字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
 (4)字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
 例：@"name CONTAIN[cd] 'ang'"   //包含某个字符串
 @"name BEGINSWITH[c] 'sh'"     //以某个字符串开头
 @"name ENDSWITH[d] 'ang'"      //以某个字符串结束
 注:[c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
 */
- (void)testPredicateRelateToNSString{
    NSArray *placeArray = [NSArray arrayWithObjects:@"Shanghai",@"Hangzhou",@"Beijing",@"Macao",@"Taishan", nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS [cd] 'an' "];
    // NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF Beginswith [cd] 'sh' "];
    
    NSArray *tempArray = [placeArray filteredArrayUsingPredicate:predicate];
    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj == %@",obj);
    }];
}

/* Predicate 与自身相比的功能
 (3)字符串本身:SELF
 例：@“SELF == ‘APPLE’"
 */
- (void)testPredicateComparationToSelf{
    NSArray *placeArray = [NSArray arrayWithObjects:@"Shanghai",@"Hangzhou",@"Beijing",@"Macao",@"Taishan", nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == 'Beijing'"];
    NSArray *tempArray = [placeArray filteredArrayUsingPredicate:predicate];
    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj == %@",obj);
    }];
}

/* Predicate范围运算功能
 (2)范围运算符：IN、BETWEEN
 例：@"number BETWEEN {1,5}"
 @"address IN {'shanghai','beijing'}"
 */
- (void)testPredicateRange{
    NSArray *array = [NSArray arrayWithObjects:@1,@2,@3,@4,@5,@2,@6, nil];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF in {2,5}"]; 找到 in 的意思是array中{2,5}的元素
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BETWEEN {2,5}"];
    NSArray *fliterArray = [array filteredArrayUsingPredicate:predicate];
    [fliterArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"fliterArray = %@",obj);
    }];
}

/** 测试Predicate的比较功能
 (1)比较运算符>,<,==,>=,<=,!=
 可用于数值及字符串
 例：@"number > 100"
 */
- (void)testPredicateComparation{
    NSArray *array = [NSArray arrayWithObjects:@1,@2,@3,@4,@5,@2,@6, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF >=4"];
    NSArray *fliterArray = [array filteredArrayUsingPredicate:predicate];
    [fliterArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"fliterArray = %@",obj);
    }];
}

#pragma mark 熟悉Predicate
- (void)testPredicateDefinition{
    NSArray *array = [[NSArray alloc]initWithObjects:@"beijing",@"shanghai",@"guangzou",@"wuhan", nil];;
    //表示在数组里面筛选还有@"be"的字符串
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",@"be"];
    NSArray *temp = [array filteredArrayUsingPredicate:predicate];
    [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"temp = %@",obj);
    }];
    
    /***************************************************************/
    //NSPredicate给我留下最深印象的是两个数组求交集的一个需求，如果按照一般写法，需要2个遍历，但NSArray提供了一个filterUsingPredicate的方法，用了NSPredicate，就可以不用遍历！
    NSArray *array1 = [NSArray arrayWithObjects:@1,@2,@3,@5,@5,@6,@7, nil];
    NSArray *array2 = [NSArray arrayWithObjects:@4,@5, nil];
    // 表示筛选array1在array2中的元素!YES！其中SELF指向filteredArrayUsingPredicate的调用者。
    /*测试方案：
     NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF  in %@",array2];
     NSArray *temp1 = [array1 filteredArrayUsingPredicate:predicate1];
     结果：
     2015-11-08 10:55:19.879 NSPredicateDemo[11595:166012] obj ==5
     2015-11-08 10:55:19.879 NSPredicateDemo[11595:166012] obj ==5
     
     NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF  in %@",array1];
     NSArray *temp1 = [array2 filteredArrayUsingPredicate:predicate1];
     结果：
     2015-11-08 10:55:19.879 NSPredicateDemo[11595:166012] obj ==5
     
     */
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF  in %@",array2];
    NSArray *temp1 = [array1 filteredArrayUsingPredicate:predicate1];
    
    [temp1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"temp1 = %@",obj);
    }];
    
    /*
     2015-11-08 10:55:19.879 NSPredicateDemo[11595:166012] obj ==5
     2015-11-08 10:55:19.879 NSPredicateDemo[11595:166012] obj ==5
     */
}

// new3个Person对象装进数组
- (void)testPredicateCutomObject {
    WXDataModel * p1 = [[WXDataModel alloc] initWith:@"w1" withAge:12 ];
    WXDataModel * p2 = [[WXDataModel alloc] initWith:@"w2" withAge:23 ];
    WXDataModel * p3 = [[WXDataModel alloc] initWith:@"w3" withAge:50 ];

    NSArray * arry = @[p1, p2, p3];

    // 查询name 为`w3`的对象
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"self.ages = 50 || self.name = 'w1' "];
    //NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ages = 50 or name = 'w1' "];
    //NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ages = 50 AND name = 'w1' "];
    
    // 得到符合条件的数据集合
    NSArray * pers = [arry filteredArrayUsingPredicate:predicate];
    for (WXDataModel * pss in pers) {
         NSLog(@"Person.name===== %@",pss.name);
    }
}

@end
