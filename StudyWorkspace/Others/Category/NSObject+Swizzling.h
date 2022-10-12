//
//  NSObject+Swizzling.h
//  TestDemo
//
//  Created by Bruce on 16/12/22.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

/**
 * 获取类的成员变量名数组(当前类定义，包括属性定义的成员变量)
 */
+ (NSArray *)WX_memberVaribaleNames;


/**
 * 获取类的属性名数组(当前类定义,只是声明property的成员变量。)
 */
+ (NSArray *)WX_propertyNames;


/**
 * 获取类方法名数组(当前类定义，不包括父类中的方法)
 */
+ (NSArray *)WX_methodNames;


/**
 *  校验一个类是否有该属性
 */
+ (BOOL)WX_hasVarName:(NSString *)name;

/**
 * 根据成员变量的实例对象获取在类中对应的变量名
 *
 * @param target 类自身的实例对象id
 * @param instance 类中变量的实例对象id
 *
 * @return 实例对象的变量名
 */
NSString *getNameWithInstance(id target, id instance);

/**`
 * 根据成员变量在类中对应的变量名获取实例对象
 *
 * @param target 类自身的实例对象id
 * @param name 成员变量在类中对应的变量名
 *
 * @return 变量名对应的实例对象
 */
id getInstanceWithName(id target, NSString* name);

/**
 *  交换两个实例方法的实现
 *
 *  @param originalSelector 原始方法
 *  @param swizzledSelector  需要覆盖原始的方法
 */
+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;


- (BOOL)class_addMethod:(Class)class selector:(SEL)selector imp:(IMP)imp types:(const char *)types;

- (BOOL)isContainSel:(SEL)sel inClass:(Class)class;

@end
