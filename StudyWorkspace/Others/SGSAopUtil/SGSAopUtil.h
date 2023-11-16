//
//  SGSAopUtil.h
//  testOC
//
//  Created by 刘泽祥 on 28/07/2020.
//  Copyright © 2020 JD. All rights reserved.
//
/**
 * 京东-平台业务中心开源的iOS平台轻量级面向切面编程工具
 * https://gitee.com/jd-platform-opensource/sgsaoputil
 */


#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

#define _sgs_INTSIZEOF(n) ((sizeof(n) + sizeof(int) - 1) & ~(sizeof(int) - 1))
#define sgs_va_start(ap,v) ( ap = (void *)&v + _sgs_INTSIZEOF(v) )
#define sgs_va_arg_p(ap,t) (ap -= _sgs_INTSIZEOF(t))
#define sgs_va_end(ap) ( ap = (void *)0 )

// call Original Selector
#define sgs_AOP_callOriginalSelector() ({\
    Class sgs京_东baseClass = object_getClass(self);\
    NSMethodSignature *sgs京_东sign = class_isMetaClass(sgs京_东baseClass) ? [[self class] methodSignatureForSelector:_cmd] :[[self class] instanceMethodSignatureForSelector:_cmd];\
    NSInvocation *sgs京_东invocation = [NSInvocation invocationWithMethodSignature:sgs京_东sign];\
    sgs京_东invocation.target = self;\
    sgs京_东invocation.selector = _cmd;\
    void * sgs京_东paramPoint;\
    sgs京_东paramPoint = (void *)&self + _sgs_INTSIZEOF(self);\
    sgs_va_start(sgs京_东paramPoint, self);\
    for (NSUInteger i = 0; i < sgs京_东sign.numberOfArguments; i ++) {\
        const char *argType = [sgs京_东sign getArgumentTypeAtIndex:i];\
        if (strcmp(argType, @encode(id)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, id) atIndex:i];\
        } else if (strcmp(argType, @encode(SEL)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, SEL) atIndex:i];\
        } else if (strcmp(argType, @encode(Class)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, Class) atIndex:i];\
        } else if (strcmp(argType, @encode(char)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, char) atIndex:i];\
        } else if (strcmp(argType, @encode(int)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, int) atIndex:i];\
        } else if (strcmp(argType, @encode(short)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, short) atIndex:i];\
        } else if (strcmp(argType, @encode(long)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, long) atIndex:i];\
        } else if (strcmp(argType, @encode(long long)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, long long) atIndex:i];\
        } else if (strcmp(argType, @encode(unsigned char)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, unsigned char) atIndex:i];\
        } else if (strcmp(argType, @encode(unsigned int)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, unsigned int) atIndex:i];\
        } else if (strcmp(argType, @encode(unsigned short)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, unsigned short) atIndex:i];\
        } else if (strcmp(argType, @encode(unsigned long)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, unsigned long) atIndex:i];\
        } else if (strcmp(argType, @encode(unsigned long long)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, unsigned long long) atIndex:i];\
        } else if (strcmp(argType, @encode(float)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, float) atIndex:i];\
        } else if (strcmp(argType, @encode(double)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, double) atIndex:i];\
        } else if (strcmp(argType, @encode(BOOL)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, BOOL) atIndex:i];\
        } else if (strcmp(argType, @encode(bool)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, bool) atIndex:i];\
        } else if (strcmp(argType, @encode(char *)) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, char *) atIndex:i];\
        } else if (strcmp(argType, @encode(void (^)(void))) == 0) {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, void (^)(void)) atIndex:i];\
        } else {\
            [sgs京_东invocation setArgument:sgs_va_arg_p(sgs京_东paramPoint, NSValue *) atIndex:i];\
        }\
    }\
    sgs_va_end(sgs京_东paramPoint);\
    [self sgs_performSelectorWithAopInvocation:sgs京_东invocation];\
})

typedef NS_ENUM(NSInteger, SGSAOPMethodType) {
    SGSAOPMethodType_InstanceType = 0,
    SGSAOPMethodType_ClassType = 1,
};

@interface SGSAopUtil : NSObject

/*
 New Process Class must functions named same as all target selectors.
 */
+ (BOOL)hookWithTargetContainerObject:(id)targetContainerObject withNewProcessClass:(Class)newProcessClass;

/*
 New Process Class must have a instance function named same as target selector.
 */
+ (BOOL)hookWithTargetContainerObject:(id)targetContainerObject targetInstanceSelector:(SEL)targetSelector withNewProcessClass:(Class)newProcessClass;

/*
 New Process Class must have a class function named same as target selector.
 */
+ (BOOL)hookWithTargetContainerObject:(id)targetContainerObject targetClassSelector:(SEL)targetSelector withNewProcessClass:(Class)newProcessClass;

@end


@interface NSObject(SGSAOPUtil)

+ (id)sgs_performSelectorWithAopInvocation:(NSInvocation *)anInvocation;

- (id)sgs_performSelectorWithAopInvocation:(NSInvocation *)anInvocation;

@end

NS_ASSUME_NONNULL_END

