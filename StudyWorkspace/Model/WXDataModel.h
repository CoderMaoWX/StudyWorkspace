//
//  WXDataModel.h
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXDataModel : NSObject

@property(nonatomic,strong) NSString    *name;

@property(nonatomic,assign) NSInteger   age;

- (instancetype)initWith:(NSString *)name withAge:(NSInteger)age;

@end

NS_ASSUME_NONNULL_END
