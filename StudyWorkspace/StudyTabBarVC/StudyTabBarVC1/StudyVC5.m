//
//  StudyVC5.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/17.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "StudyVC5.h"
#import <objc/runtime.h>

@interface Test1 : NSObject
@end

@implementation Test1

- (void)doSomething2 {
    NSLog(@"into Test1, call doSomething2");
}

- (void)doSomething3:(NSValue*)val {
    NSInteger value;
    [val getValue:&value];
    NSLog(@"into Test1, call doSomething3, param=%ld", value);
}

+ (void)doClassMethod1:(NSString*)val {
    NSLog(@"into Test1, call doClassMethod1, param=%@", val);
}
@end


@interface StudyVC5 ()

@end

@implementation StudyVC5

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"查看控制台打印日志");
    
    /////////////////////////// 实例方法 ///////////////////////////
    // 1 调用不存在的实例方法“doSomething”
    // 在 resolveInstanceMethod 方法内提供了解救方案，即动态添加了一个方法作为实例方法“doSomething”的替代。
    SEL sel1 = NSSelectorFromString(@"doSomething:");
    [self performSelector:sel1 withObject:nil];
    
    
    // 2 调用不存在的实例方法“doSomething2”
    // 在 forwardingTargetForSelector 方法内提供了解救方案，即将实例化的Test1类对象return给了调用，
    SEL sel2 = NSSelectorFromString(@"doSomething2");
    [self performSelector:sel2 withObject:nil];
    
    // 3 调用不存在的实例方法“doSomething3”
    // 在 forwardInvocation 方法内提供了解救方案，即将实例化的Test1类对象return给了调用，
    SEL sel3 = NSSelectorFromString(@"doSomething3:");
    NSInteger b = 88;
    NSValue *value3 = [NSValue value:&b withObjCType:@encode(NSInteger)];
    [self performSelector:sel3 withObject:value3]; //？？传递的参数类型最后Test1里不对。
    
    /////////////////////////// 类方法 ///////////////////////////
    // 4 调用不存在的类方法"doClassMethod1"
    // 在 resolveClassMethod 方法内提供了解救方案，即动态添加了一个方法作为类方法“doClassMethod1”的替代。
    SEL sel4 = NSSelectorFromString(@"doClassMethod1:");
    [self.class performSelector:sel4 withObject:@"aaa"];

}

+ (BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@" >> Class resolving %@", NSStringFromSelector(sel));
    if (sel == @selector(doClassMethod1:)) {
        
        IMP imp = imp_implementationWithBlock(^(id self, NSString *val) {
            NSLog(@">>> call doClassMethod1, into block, param=%@", val);
        });
        Class metaClass = object_getClass(self);
        class_addMethod(metaClass, sel, imp, "v@:@@");
        return YES;
    }
    BOOL rev = [super resolveClassMethod:sel];
    return rev;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(doSomething:)) {
        //        class_addMethod([self class], sel, imp_implementationWithBlock(^(id self, NSString *str) {
        //            NSLog(@"block, val=%@", str);
        //        }), "v@");
        class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:@");
    }
    return [super resolveInstanceMethod:sel];
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(doSomething2)) {
        return [Test1 new]; //Test1.h中没有申明，但Test1.m中有方法就可以。
    }
    return [super forwardingTargetForSelector:aSelector];
}

/*
 -forwardInvocation:在一个对象无法识别消息之前调用，再需要重载-methodSignatureForSelector:,因为在调用-forwardInvocation：之前是要把消息打包成NSIvocation对象的，所以需要-methodSignatureForSelector:重载，如果不能在此方法中不能不为空的NSMethodSignature对象，程序依然会崩溃
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if (aSelector == @selector(doSomething3:)) {
        NSMethodSignature *methodSignature = [super methodSignatureForSelector:aSelector];
        if (!methodSignature) {
            if ([Test1 instancesRespondToSelector:aSelector]) {
                methodSignature = [Test1 instanceMethodSignatureForSelector:aSelector];
            }
        }
        return methodSignature;
    }
    return nil;
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (anInvocation.selector == @selector(doSomething3:)) {
        Test1 *test1 = [Test1 new];
        if ([test1 respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:test1];
        }
    }
}

#pragma mark - Custom Method

void dynamicMethodIMP(id self, SEL _cmd, NSString *str) {
    
    NSLog(@"into dynamicMethodIMP, param=%@", str);
    
}

@end
