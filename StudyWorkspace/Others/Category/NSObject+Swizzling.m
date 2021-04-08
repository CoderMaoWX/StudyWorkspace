//
//  NSObject+Swizzling.m
//  TestDemo
//
//  Created by Bruce on 16/12/22.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>
#import "WXMacroDefiner.h"


@implementation NSObject (Swizzling)

/**
 * 警告：此方法不要删除，在使用KVC赋值时防止崩溃
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    WX_Log(@"❌❌❌ 警告:< %@ >: KVC赋值没有该属性: %@",[self class],key);
}

/**
 * 获取成员变量
 */
+ (NSArray *)WX_memberVaribaleNames {
    unsigned int numIvars;
    Ivar * vars = class_copyIvarList(self, &numIvars);
    NSMutableArray *tempResultArr = [NSMutableArray arrayWithCapacity:numIvars];
    for (NSInteger i = 0; i < numIvars; i++) {
        Ivar thisIvar = vars[i];
        NSString *varibleName = [NSString stringWithUTF8String:ivar_getName(thisIvar)]; //获取成员变量名字
        WX_Log(@"WX_memberVaribaleNames===%@",varibleName);
        [tempResultArr addObject:varibleName];
    }
    free(vars);
    
    return [NSArray arrayWithArray:tempResultArr];
}

/**
 * 获取类的属性名数组(只是声明property的成员变量)
 */
+ (NSArray *)WX_propertyNames {
    unsigned int numPropertys;
    objc_property_t *propertys = class_copyPropertyList(self, &numPropertys);
    NSMutableArray *tempResultArr = [NSMutableArray arrayWithCapacity:numPropertys];
    for (NSInteger i = 0; i < numPropertys; i++) {
        objc_property_t thisProperty = propertys[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(thisProperty)];
        WX_Log(@"WX_propertyNames-----%@",propertyName);
        [tempResultArr addObject:propertyName];
    }
    free(propertys);
    
    return [NSArray arrayWithArray:tempResultArr];
}

/**
 * 获取类方法名数组(当前类定义的，不包括父类中的方法)
 */
+ (NSArray *)WX_methodNames {
    unsigned int numMethods;
    Method *methods = class_copyMethodList(self, &numMethods);
    NSMutableArray *tempResultArr = [NSMutableArray arrayWithCapacity:numMethods];
    for (NSInteger i = 0; i < numMethods; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
        NSString *selName = [NSString stringWithUTF8String:sel_getName(sel)];
        [tempResultArr addObject:selName];
    }
    free(methods);
    
    return [NSArray arrayWithArray:tempResultArr];
}


/**
 *  校验一个类是否有该属性
 */
+ (BOOL)WX_hasVarName:(NSString *)name
{
    unsigned int outCount;
    BOOL hasProperty = NO;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i++)
    {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        
        NSString *absoluteName = [NSString stringWithString:name];
        absoluteName = [absoluteName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if ([keyName isEqualToString:absoluteName]) {
            hasProperty = YES;
            break;
        }
    }
    //释放
    free(ivars);
    return hasProperty;
}

/**
 *  交换两个实例方法的实现
 *
 *  @param originalSelector 原始方法
 *  @param swizzledSelector  需要覆盖原始的方法
 */
+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    //原有方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    //替换原有方法的新方法
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    //先尝试給源SEL添加IMP，这里是为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {//添加成功：说明源SEL没有实现IMP，将源SEL的IMP替换到交换SEL的IMP
        class_replaceMethod(class,swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {//添加失败：说明源SEL已经有IMP，直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (BOOL)class_addMethod:(Class)class selector:(SEL)selector imp:(IMP)imp types:(const char *)types {
    return class_addMethod(class,selector,imp,types);
}

- (BOOL)isContainSel:(SEL)sel inClass:(Class)class {
    unsigned int count;
    
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *tempMethodString = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        if ([tempMethodString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    return NO;
}

@end

