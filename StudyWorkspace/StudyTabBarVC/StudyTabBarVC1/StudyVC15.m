//
//  StudyVC15.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/4/28.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "StudyVC15.h"
#import <Foundation/Foundation.h>

@interface Favourite : NSObject
@property (nonatomic, copy) NSString *title;
@end
@implementation Favourite
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.title = name;
    }
    return self;
}
@end
//===========

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) Favourite *favourite;
@end
@implementation Person

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}
@end

@interface StudyVC15 ()
@property (nonatomic, copy) NSString *tmpURL;
@end

@implementation StudyVC15

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testNSPredicate];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self systemApi_NSMapTable];
}

- (void)systemApi_NSURLComponents {
    self.tmpURL = @"https://www.support.blah.com:80/path.path_path/demo_file.html?sess=1234&id=6789&discout=%2520off";
//    self.tmpURL = @"http://username:password@www.example.com/index.html?sess=1234&id=6789";
    
    NSURL *url = [NSURL URLWithString:self.tmpURL];
    NSLog(@"===: %@", self.tmpURL.pathComponents);
    
    NSArray *tempArray = @[@"aaaa.txt", @"bbbb",@"cccc", @"dddd.gggg"];
    NSArray *array1 = [self.tmpURL stringsByAppendingPaths:tempArray];
    NSArray *array2 = [tempArray pathsMatchingExtensions:@[@"txt", @"gggg"]];
    
    NSURLComponents *component = [NSURLComponents componentsWithString:self.tmpURL];
 
    [component.queryItems enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@: %@", obj.name, obj.value);
    }];
}

- (void)systemApi_NSProcessInfo {
    // 获取当前进程对应的ProcessInfo对象
    NSProcessInfo* proInfo = [NSProcessInfo processInfo];
    
    // 获取运行该程序所指定的参数
    NSArray* arr = [proInfo arguments];
    NSLog(@"运行程序的参数为：%@" , arr);
    NSLog(@"进程标识符为：%d" ,[proInfo processIdentifier]);
    NSLog(@"进程的进程名为：%@" ,[proInfo processName]);
    NSLog(@"进程所在系统的主机名为：%@" , [proInfo hostName]);
    NSLog(@"进程所在系统的操作系统为：%ld" , [proInfo operatingSystem]);
    NSLog(@"进程所在系统的操作系统名为：%@" , [proInfo operatingSystemName]);
    
    NSLog(@"进程所在系统的操作系统版本字符串为：%@", [proInfo operatingSystemVersionString]);
    NSLog(@"进程所在系统的物理内存为：%lld", [proInfo physicalMemory]);
    NSLog(@"进程所在系统的处理器数量为：%ld" , [proInfo processorCount]);
    NSLog(@"进程所在系统的激活的处理器数量为：%ld" , [proInfo activeProcessorCount]);
    NSLog(@"进程所在系统的运行时间为：%f", [proInfo systemUptime]);
}

- (void)systemApi_NSMapTable {
    Person *p1 = [[Person alloc] initWithName:@"jack"];

    Favourite *f1 = [[Favourite alloc] initWithName:@"ObjC"];

    Person *p2 = [[Person alloc] initWithName:@"rose"];

    Favourite *f2 = [[Favourite alloc] initWithName:@"Swift"];

    NSMapTable *MapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory];
    
    [MapTable setObject:f1 forKey:p1];

    [MapTable setObject:f2 forKey:p2];

    NSMutableSet *set = [NSMutableSet set];
    [set intersectSet:set];
    
    NSOrderedSet *orderSet = [NSOrderedSet init];
}

// NSMutableOrderedSet集合是否有序; 结论: 是有序的;
- (void)testMethodForOrderedSet {
    NSMutableOrderedSet *mutableOrderedSet = [NSMutableOrderedSet new];
    [mutableOrderedSet addObject:@"1"];
    [mutableOrderedSet addObject:@"2"];
    [mutableOrderedSet addObject:@"4"];
    [mutableOrderedSet addObject:@"2"];
    [mutableOrderedSet addObject:@"1"];
    [mutableOrderedSet addObject:@"3"];

    NSLog(@"mutableOrderedSet: %@", mutableOrderedSet);
    /* 输出: mutableOrderedSet: {(
     1,
     2,
     4,
     3
     )} */
}

///学习谓词: https://swift.gg/2019/11/19/nspredicate-objective-c/
- (void)testNSPredicate {
//    NSMutableArray *mutableArray = [NSMutableArray array];
//    NSPredicate *pre = [[NSPredicate alloc] init];
//
//    // 修改原数组
//    [mutableArray filterUsingPredicate:pre];
//
//    // 返回新的数组
//    [mutableArray filteredArrayUsingPredicate:pre];
    
    
    Favourite *favourite1 = [Favourite new];
    favourite1.title = @"chang ge";
    Person *person1 = [Person new];
    person1.name = @"zhangsan";
    person1.favourite = favourite1;
    
    
    Favourite *favourite2 = [Favourite new];
    favourite2.title = @"you yong";
    Person *person2 = [Person new];
    person2.name = @"lisi";
    person2.favourite = favourite2;
    
    
    Favourite *favourite3 = [Favourite new];
    favourite3.title = @"xia qi";
    Person *person3 = [Person new];
    person3.name = @"wangwu";
    person3.favourite = favourite3;
    
    
    Favourite *favourite4 = [Favourite new];
    favourite4.title = [@"爬山" uppercaseString];
    Person *person4 = [Person new];
    person4.name = @"xiaobai";
    person4.favourite = favourite4;
        
    NSArray *employeeArray = @[ person1, person2, person3, person4 ];
    
    // 我们得到一个长度大于 10 的识别符字符串的数组
    NSString *predicateFormat = @"SELF.name.length > 5";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat];
    NSArray *longEmployeeIDs = [[employeeArray filteredArrayUsingPredicate:predicate] valueForKey:@"name"];
    NSArray *longEmployeeIDs2 = [[employeeArray filteredArrayUsingPredicate:predicate] valueForKeyPath:@"favourite.title"];

    // 现在 longEmployeeIDs 已经不含有 Person 对象了，只有字符串
    NSLog(@"longEmployeeIDs: %@", longEmployeeIDs2);
}

@end
