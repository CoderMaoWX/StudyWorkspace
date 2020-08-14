//
//  WXDataModel.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "WXDataModel.h"

@implementation WXDataModel

- (instancetype)initWith:(NSString *)name withAge:(NSInteger)age {
    if (self == [super init]) {
        self.name = name;
        self.age = age;
    }
    return self;
}

@end
