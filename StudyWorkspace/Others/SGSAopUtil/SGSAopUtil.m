//
//  SGSAopUtil.m
//  testOC
//
//  Created by 刘泽祥 on 28/07/2020.
//  Copyright © 2020 JD. All rights reserved.
//

#import "SGSAopUtil.h"
#import <objc/message.h>

@class SGSTargetObject, SGSTargetClass;

@interface SGSTargetSelector : NSObject {
    SEL _injectionSelector;
    NSString *_injectionSelectorStr;
}


@property (nonatomic, assign) Class originClass;

@property (nonatomic, weak) SGSTargetObject *belongObject;

@property (nonatomic, assign) SEL targetSelector;

@property (nonatomic, assign) SGSAOPMethodType methodType;

@property (nonatomic, assign, readonly) SEL injectionSelector;
@property (nonatomic, copy, readonly) NSString *injectionSelectorStr;

@end

@interface SGSTargetObject : NSObject {
    NSString *_sgs_Prifix_Object;
}

@property (nonatomic, weak) SGSTargetClass *belongClass;

@property (nonatomic, weak) id targetObject;

@property (nonatomic, strong) NSMutableArray<SGSTargetSelector *> *targetSelectors;

@property (nonatomic, copy, readonly) NSString *sgs_Prifix_Object;

- (SGSTargetSelector *)findTargetSelector:(SEL)sel methodType:(SGSAOPMethodType)methodType;
- (SGSTargetSelector *)findPreviousTargetSelector:(SEL)sel methodType:(SGSAOPMethodType)methodType;
- (SEL)trueSelector:(SEL)injectionSelector;
- (SEL)originalTargetSelector:(SEL)processSelector;
+ (SEL)sgsOriginalSelector:(SEL)originalSelector;

@end

@interface SGSTargetClass : NSObject {
    NSString *_sgs_Prifix_Class;
}

@property (nonatomic, assign) Class targetClass;

@property (nonatomic, strong) NSMutableArray<SGSTargetObject *> *targetObjects;

@property (nonatomic, copy, readonly) NSString *sgs_Prifix_Class;

- (SGSTargetObject *)findTargetObject:(id)obj;

@end


@implementation SGSTargetSelector

- (SEL)injectionSelector {
    if (!_injectionSelector) {
        _injectionSelector = NSSelectorFromString(self.injectionSelectorStr);
    }
    return _injectionSelector;
}

- (NSString *)injectionSelectorStr {
    if (!_injectionSelectorStr) {
        NSString *targetSelectorStr = NSStringFromSelector(_targetSelector);
        _injectionSelectorStr = [NSString stringWithFormat:@"%@京_东%@京_东%@", _belongObject.sgs_Prifix_Object, NSStringFromClass(_originClass), targetSelectorStr];
    }
    return _injectionSelectorStr;
}

@end


@implementation SGSTargetObject

- (NSMutableArray<SGSTargetSelector *> *)targetSelectors {
    if (!_targetSelectors) {
        _targetSelectors = [NSMutableArray<SGSTargetSelector *> new];
    }
    return _targetSelectors;
}

- (instancetype)initTargetObjectForMetaClass:(Class)cls {
    if (self = [super init]) {
        
    }
    return self;
}

- (SGSTargetSelector *)findTargetSelector:(SEL)sel methodType:(SGSAOPMethodType)methodType {
    SGSTargetSelector *targetSelector;
    for (NSInteger i = self.targetSelectors.count - 1; i >= 0; i --) {
        SGSTargetSelector *currentSel = self.targetSelectors[i];
        if (currentSel.targetSelector == sel && currentSel.methodType == methodType) {
            targetSelector = currentSel;
            break;
        }
    }
    return targetSelector;
}

- (SGSTargetSelector *)findTargetSelector:(SEL)sel originClass:(Class)originCls methodType:(SGSAOPMethodType)methodType  {
    SGSTargetSelector *previousSel = nil;
    NSInteger i = self.targetSelectors.count - 1;
    for (; i >= 0; i --) {
        SGSTargetSelector *currentSel = self.targetSelectors[i];
        if (currentSel.targetSelector == sel && currentSel.methodType == methodType && currentSel.originClass == originCls) {
        }
    }
    return previousSel;
}

- (SGSTargetSelector *)findPreviousTargetSelector:(SEL)sel methodType:(SGSAOPMethodType)methodType {
    SGSTargetSelector *previousSel = nil;
    NSArray<NSString *> *components = [self componentsOfProcessSelectorWithPrifixStr:sel];// sgs京_东TargetClassName京_东TargetObjectAddress京_东OriginClassName京_东Selector
    if (components.count > 4) {
        Class originClass = NSClassFromString(components[3]);
        NSString *trueSelectorStr = [[components subarrayWithRange:NSMakeRange(4, components.count - 4)] componentsJoinedByString:@"京_东"];
        SEL trueSelector = NSSelectorFromString(trueSelectorStr);
        NSInteger i = self.targetSelectors.count - 1;
        BOOL isFindPrivious = NO;
        for (; i >= 0; i --) {
            SGSTargetSelector *currentSel = self.targetSelectors[i];
            if (isFindPrivious) {
                if (currentSel.targetSelector == trueSelector && currentSel.methodType == methodType) {
                    previousSel = currentSel;
                    break;
                }
            } else {
                if (currentSel.targetSelector == trueSelector && currentSel.methodType == methodType && currentSel.originClass == originClass) {
                    isFindPrivious = YES;
                }
            }
        }
    }
    return previousSel;
}

- (SEL)trueSelector:(SEL)injectionSelector {
    NSArray<NSString *> *components = [self componentsOfProcessSelectorWithPrifixStr:injectionSelector];// sgs京_东origin京_东Selector
    if (components.count > 4) {
        NSString *trueSelectorStr = [[components subarrayWithRange:NSMakeRange(4, components.count - 4)] componentsJoinedByString:@"京_东"];
        return NSSelectorFromString(trueSelectorStr);
    }
    return nil;
}

- (SEL)originalTargetSelector:(SEL)processSelector {
    SEL trueSelector = [self trueSelector:processSelector];
    if (trueSelector) {
        return [[self class] sgsOriginalSelector:trueSelector];
    }
    return nil;
}

+ (SEL)sgsOriginalSelectorName:(SEL)originalSelector {
    NSString *oriSelStr = NSStringFromSelector(originalSelector);
    if ([oriSelStr hasPrefix:[self sgsOriginalSelectorPrefix]]) {
        NSString *trueSelStr = [oriSelStr substringFromIndex:[self sgsOriginalSelectorPrefix].length];
        return NSSelectorFromString(trueSelStr);
    }
    return nil;
}

+ (SEL)sgsOriginalSelector:(SEL)originalSelector {
    NSString *originSelectorStr = [NSString stringWithFormat:@"%@%@", [self sgsOriginalSelectorPrefix], NSStringFromSelector(originalSelector)];
    return NSSelectorFromString(originSelectorStr);
}

+ (NSString *)sgsOriginalSelectorPrefix {
    return @"sgs京_东origin京_东";
}

- (SEL)sgsOriginalSelector_ErrorLog:(SEL)originalSelector {
    NSArray<NSString *> *components = [self componentsOfProcessSelectorWithPrifixStr:originalSelector];// sgs京_东origin京_东Selector
    if (components.count > 2) {
        NSString *trueSelectorStr = [[components subarrayWithRange:NSMakeRange(2, components.count - 2)] componentsJoinedByString:@"京_东"];
        return NSSelectorFromString(trueSelectorStr);
    }
    return nil;
}

- (NSArray<NSString *> *)componentsOfProcessSelectorWithPrifixStr:(SEL)sel {
    NSString *selStr = NSStringFromSelector(sel);
    return [selStr componentsSeparatedByString:@"京_东"];
}

- (NSString *)sgs_Prifix_Object {
    if (!_sgs_Prifix_Object) {
        _sgs_Prifix_Object = [NSString stringWithFormat:@"%@京_东%p", _belongClass.sgs_Prifix_Class, self];
    }
    return _sgs_Prifix_Object;
}

@end

@implementation SGSTargetClass

- (NSArray<SGSTargetObject *> *)targetObjects {
    if (!_targetObjects) {
        _targetObjects = [NSMutableArray<SGSTargetObject *> new];
    }
    return _targetObjects;
}

- (SGSTargetObject *)findTargetObject:(id)obj {
    SGSTargetObject *targetObject;
    for (NSInteger i = self.targetObjects.count - 1; i >= 0; i --) {
        SGSTargetObject *currentObj = self.targetObjects[i];
        if (obj == currentObj.targetObject) {
            targetObject = currentObj;
        }
    }
    return targetObject;
}

- (NSString *)sgs_Prifix_Class {
    if (!_sgs_Prifix_Class) {
        _sgs_Prifix_Class = [NSString stringWithFormat:@"sgs京_东%@", NSStringFromClass(_targetClass)];
    }
    return _sgs_Prifix_Class;
}

@end


@interface SGSAopUtil()

@property (nonatomic, strong) NSMutableArray<SGSTargetClass *> *swizzledClasses;

@property (nonatomic, strong) NSMutableArray<NSString *> *functionBlackList;

+ (instancetype)sharedUtil;

- (SGSTargetClass *)findTargetClass:(Class)cls;

@end


@implementation SGSAopUtil

+ (instancetype)sharedUtil {
    static SGSAopUtil *_sharedUtil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _sharedUtil = [SGSAopUtil new];
    });
    return _sharedUtil;
}

+ (BOOL)hookWithTargetContainerObject:(id)targetContainerObject withNewProcessClass:(Class)newProcessClass {
    return [[self sharedUtil] hookedTargetContainerObject:targetContainerObject withNewProcessClass:newProcessClass];
}

- (BOOL)hookedTargetContainerObject:(id)targetContainerObject withNewProcessClass:(Class)newProcessClass {
    NSCParameterAssert(targetContainerObject);
    NSCParameterAssert(newProcessClass);
    
    // 1. List Property Getter And Setter Functions
    Class metaClass = objc_getMetaClass(NSStringFromClass([newProcessClass class]).UTF8String);
    
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([newProcessClass class], &count);
    NSMutableArray *propertiesFunctionArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i ++) {
        const char* propertyName =property_getName(properties[i]);
        NSString *propertyGetSELStr = [NSString stringWithUTF8String: propertyName];
        [propertiesFunctionArray addObject: propertyGetSELStr];
        NSString *propertySetSELStr = [NSString stringWithFormat:@"set%@%@:", [propertyGetSELStr substringToIndex:1].uppercaseString, [propertyGetSELStr substringFromIndex:1]];
        [propertiesFunctionArray addObject: propertySetSELStr];
    }
    free(properties);
    
    // 2. Hook all instance functions
    unsigned int instanceMethodCount =0;
    Method* instanceMethodList = class_copyMethodList([newProcessClass class], &instanceMethodCount);
    
    int instance_i = 0;
    for(instance_i = 0; instance_i < instanceMethodCount; instance_i ++)
    {
        Method temp = instanceMethodList[instance_i];
        SEL instanceSelector = method_getName(temp);
        NSString *instanceSelectorStr = NSStringFromSelector(instanceSelector);
        
        if ([self.functionBlackList containsObject:instanceSelectorStr] || [propertiesFunctionArray containsObject:instanceSelectorStr]) {
            continue;
        }
        if (![self hookedTargetContainerObject:targetContainerObject targetSelector:instanceSelector targetMethodType:SGSAOPMethodType_InstanceType withNewProcessClass:newProcessClass]) {
            [NSException raise:@"Hook Instance Selctor Failed" format:@"\n\tnewProcessClass:%@\n\tnewProcessClass:%@\n\ttargetContainerObject:%@", NSStringFromClass(newProcessClass), NSStringFromSelector(instanceSelector), targetContainerObject];
        }
    }
    free(instanceMethodList);
    
    // 3. Hook all class functions
    unsigned int classMethodCount =0;
    Method* classMethodList = class_copyMethodList(metaClass, &classMethodCount);
    
    for(int i=0;i<classMethodCount;i++)
    {
        Method temp = classMethodList[i];
        SEL classSelector = method_getName(temp);
        
        if ([self.functionBlackList containsObject:NSStringFromSelector(classSelector)]) {
            continue;
        }
        if (![self hookedTargetContainerObject:targetContainerObject targetSelector:classSelector targetMethodType:SGSAOPMethodType_ClassType withNewProcessClass:newProcessClass]) {
            [NSException raise:@"Hook Class Selctor Failed" format:@"\n\tnewProcessClass:%@\n\tnewProcessClass:%@\n\ttargetContainerObject:%@", NSStringFromClass(newProcessClass), NSStringFromSelector(classSelector), targetContainerObject];
        }
    }
    free(classMethodList);
    
    return YES;
}

+ (BOOL)hookWithTargetContainerObject:(id)targetContainerObject targetInstanceSelector:(SEL)targetSelector withNewProcessClass:(Class)newProcessClass {
    return [[self sharedUtil] hookedTargetContainerObject:targetContainerObject targetSelector:targetSelector targetMethodType:SGSAOPMethodType_InstanceType withNewProcessClass:newProcessClass];
}

/*
 New Process Object must have a same function named same as target selector.
 */
+ (BOOL)hookWithTargetContainerObject:(id)targetContainerObject targetClassSelector:(SEL)targetSelector withNewProcessClass:(Class)newProcessClass {
    return [[self sharedUtil] hookedTargetContainerObject:targetContainerObject targetSelector:targetSelector targetMethodType:SGSAOPMethodType_ClassType withNewProcessClass:newProcessClass];
}

- (BOOL)hookedTargetContainerObject:(id)targetContainerObject targetSelector:(SEL)targetSelector targetMethodType:(SGSAOPMethodType)methodType withNewProcessClass:(Class)newProcessClass {
    NSCParameterAssert(targetContainerObject);
    NSCParameterAssert(targetSelector);
    NSCParameterAssert(newProcessClass);
    
    __block BOOL success = NO;
    sgs_aopSelectorLocked(^{
        
        // 1. Validate
        BOOL isNewClass = NO, isNewObject = NO, isNewSelector = NO;
        Class targetCls = [targetContainerObject isKindOfClass:[NSObject class]] ? [targetContainerObject class] : targetContainerObject;
        SGSTargetClass *sgTargetClass = [self findTargetClass:targetCls];
        if (!sgTargetClass) {
            isNewClass = YES;
            sgTargetClass = [SGSTargetClass new];
            sgTargetClass.targetClass = targetCls;
        }
        
        SGSTargetObject *sgTargetObject = [sgTargetClass findTargetObject:targetContainerObject];
        if (!sgTargetObject) {
            isNewObject = YES;
            sgTargetObject = [SGSTargetObject new];
            sgTargetObject.targetObject = targetContainerObject;
            sgTargetObject.belongClass = sgTargetClass;
        }
        
        SGSTargetSelector *sgTargetSelector = [sgTargetObject findTargetSelector:targetSelector originClass:newProcessClass methodType:methodType];
        if (!sgTargetSelector) {
            isNewSelector = YES;
            sgTargetSelector = [SGSTargetSelector new];
            sgTargetSelector.targetSelector = targetSelector;
            sgTargetSelector.belongObject = sgTargetObject;
            sgTargetSelector.originClass = newProcessClass;
            sgTargetSelector.methodType = methodType;
        } else {
            success = NO;
            return;
        }
        
        // 2. Injection New Function
        success = [self sgs_injectSelector:sgTargetSelector.injectionSelector type:methodType intoClass:targetCls fromClass:newProcessClass fromClassSelector:targetSelector];
        if (!success) {
            success = YES;
            return;
        }
        
        // 3. (Optional)Injection Auto Forward Function
        Method msdTrueSuper = nil;
        if (isNewClass) {
            success = [self sgs_injectAutoForwardFunctionIntoClass:targetCls];
            if (!success) {
                success = NO;
                return;
            }
        }
        
        // 4. Swizzle original Method
        if (isNewSelector) {
            
            // Fix Super Class
            SEL sgsOriginalSelector = [SGSTargetObject sgsOriginalSelector:targetSelector];
            if (methodType == SGSAOPMethodType_ClassType
                && [[targetCls superclass] respondsToSelector:targetSelector]
                && [[targetCls superclass] respondsToSelector:sgsOriginalSelector]) { // Class
                msdTrueSuper = class_getClassMethod([targetCls superclass], sgsOriginalSelector);
            } else if (methodType == SGSAOPMethodType_InstanceType
                       && [[targetCls superclass] instancesRespondToSelector:targetSelector]
                       && [[targetCls superclass] instancesRespondToSelector:sgsOriginalSelector]) { // Instance
                msdTrueSuper = class_getInstanceMethod([targetCls superclass], sgsOriginalSelector);
            }
            if (msdTrueSuper) {
                class_addMethod(targetCls, sgsOriginalSelector, method_getImplementation(msdTrueSuper), method_getTypeEncoding(msdTrueSuper));
                class_addMethod(targetCls, targetSelector, method_getImplementation(msdTrueSuper), method_getTypeEncoding(msdTrueSuper));
            }
            
            Method msdTrue = methodType == SGSAOPMethodType_ClassType ? class_getClassMethod(targetCls, targetSelector) : class_getInstanceMethod(targetCls, targetSelector);
            
            targetCls = methodType == SGSAOPMethodType_ClassType ? objc_getMetaClass(NSStringFromClass(targetCls).UTF8String) : targetCls;
            
            Method newProcessMsd = methodType == SGSAOPMethodType_ClassType ? class_getClassMethod(objc_getMetaClass(NSStringFromClass(newProcessClass).UTF8String), targetSelector) : class_getInstanceMethod(newProcessClass, targetSelector);
            if (!newProcessMsd) {
                success = NO;
                [newProcessClass doesNotRecognizeSelector:targetSelector];
                return;
            }
            IMP forceForwardIMP = sgs_getMsgForwardIMP(newProcessMsd);

            IMP newProcessImp = method_getImplementation(newProcessMsd);
            const char *newProcessType = method_getTypeEncoding(newProcessMsd);
            class_addMethod(targetCls, sgTargetSelector.injectionSelector, newProcessImp, newProcessType);
            class_addMethod(targetCls, sgsOriginalSelector, method_getImplementation(msdTrue), method_getTypeEncoding(msdTrue));
            if (!class_addMethod(targetCls, targetSelector, forceForwardIMP, method_getTypeEncoding(newProcessMsd))) {
                class_replaceMethod(targetCls, targetSelector, forceForwardIMP, method_getTypeEncoding(newProcessMsd));
            }
        }
        
        // 5. Add Injection Log
        if (success) {
            if (isNewClass) { [self.swizzledClasses addObject:sgTargetClass]; }
            if (isNewObject) { [sgTargetClass.targetObjects addObject:sgTargetObject]; }
            if (isNewSelector) { [sgTargetObject.targetSelectors addObject:sgTargetSelector]; }
        }
    });

    return success;
}

#pragma mark - Auto Forward

- (void)sgs_forwardInvocation:(NSInvocation *)anInvocation {
    [self sgs_performSelectorWithAopInvocation:anInvocation];
}

+ (void)sgs_forwardInvocation:(NSInvocation *)anInvocation {
    [self sgs_performSelectorWithAopInvocation:anInvocation];
}

#pragma mark - Injection & Swizzle

static IMP sgs_getMsgForwardIMP(Method method) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);

            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (__unused NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}

- (BOOL)sgs_injectAutoForwardFunctionIntoClass:(Class)targetCls {
    BOOL success = YES;
    success &= [self sgs_injectSelector:@selector(sgs_forwardInvocation:) type:SGSAOPMethodType_InstanceType intoClass:targetCls fromClass:[self class]];
    success &= [self sgs_injectSelector:@selector(sgs_forwardInvocation:) type:SGSAOPMethodType_ClassType intoClass:targetCls fromClass:[self class]];
    
    void (^swizzleMethod)(SEL, SEL, SGSAOPMethodType) = ^(SEL selA, SEL selB, SGSAOPMethodType methodType) {
        Method originMethod = methodType == SGSAOPMethodType_ClassType ? class_getClassMethod(targetCls, selA) : class_getInstanceMethod(targetCls, selA);
        Method hookedMethod = methodType == SGSAOPMethodType_ClassType ? class_getClassMethod(targetCls, selB) : class_getInstanceMethod(targetCls, selB);

        [self sgs_injectSelector:selB type:methodType intoClass:targetCls fromClass:[self class]]; // avoid change function in base class
        
        Class targetClsTmp = methodType == SGSAOPMethodType_ClassType ? objc_getMetaClass(NSStringFromClass(targetCls).UTF8String) : targetCls;
        class_replaceMethod(targetClsTmp,
                            selB,
                            class_replaceMethod(targetClsTmp,
                                                selA,
                                                method_getImplementation(hookedMethod),
                                                method_getTypeEncoding(hookedMethod)),
                            method_getTypeEncoding(originMethod));
    };
    swizzleMethod(@selector(sgs_forwardInvocation:), @selector(forwardInvocation:), SGSAOPMethodType_ClassType);
    swizzleMethod(@selector(sgs_forwardInvocation:), @selector(forwardInvocation:), SGSAOPMethodType_InstanceType);
    
    return success;
}

/// Inject new selector into target class with same selector in original class
- (BOOL)sgs_injectSelector:(SEL)targetSelector type:(SGSAOPMethodType)methodType intoClass:(Class)targetCls fromClass:(Class)originCls {
    return [self sgs_injectSelector:targetSelector type:methodType intoClass:targetCls fromClass:originCls fromClassSelector:targetSelector];
}

/// Inject new selector into target class where the implementation come from original class's another selector
- (BOOL)sgs_injectSelector:(SEL)targetSelector type:(SGSAOPMethodType)methodType intoClass:(Class)targetCls fromClass:(Class)originCls fromClassSelector:(SEL)originSelector {
    targetCls = methodType == SGSAOPMethodType_ClassType ? objc_getMetaClass(NSStringFromClass(targetCls).UTF8String) : targetCls;
    Method msd = methodType == SGSAOPMethodType_ClassType ? class_getClassMethod(originCls, originSelector) : class_getInstanceMethod(originCls, originSelector);
    IMP imp = method_getImplementation(msd);
    return class_addMethod(targetCls, targetSelector, imp, method_getTypeEncoding(msd));
}

#pragma mark -

- (SGSTargetClass *)findTargetClass:(Class)cls {
    SGSTargetClass *targetClass;
    for (NSInteger i = self.swizzledClasses.count - 1; i >= 0; i --) {
        SGSTargetClass * currentCls = self.swizzledClasses[i];
        if (currentCls.targetClass == cls) {
            targetClass = currentCls;
        }
    }
    return targetClass;;
}

#pragma mark - Lazy

- (NSMutableArray<NSString *> *)functionBlackList {
    if (!_functionBlackList) {
        _functionBlackList = [NSMutableArray<NSString *> new];
        [_functionBlackList addObject:@".cxx_destruct"];
    }
    return _functionBlackList;
}

- (NSMutableArray<SGSTargetClass *> *)swizzledClasses {
    if (!_swizzledClasses) {
        _swizzledClasses = [NSMutableArray<SGSTargetClass *> new];
    }
    return _swizzledClasses;
}

#pragma mark - Lock

static void sgs_aopSelectorLocked(dispatch_block_t block) {
    if (@available(iOS 10.0.0, *)) {
        static dispatch_semaphore_t semaphore_t;
        static dispatch_once_t sgs_pred;
        dispatch_once(&sgs_pred, ^{
            semaphore_t = dispatch_semaphore_create(1);
        });
        
        dispatch_semaphore_wait(semaphore_t,DISPATCH_TIME_FOREVER);
        block();
        dispatch_semaphore_signal(semaphore_t);
    } else {
        static dispatch_semaphore_t semaphore_t;
        static dispatch_once_t sgs_pred;
        dispatch_once(&sgs_pred, ^{
            semaphore_t = dispatch_semaphore_create(1);
        });
        
        dispatch_semaphore_wait(semaphore_t,DISPATCH_TIME_FOREVER);
        block();
        dispatch_semaphore_signal(semaphore_t);
    }
}

@end

@implementation NSObject(SGSAOPUtil)

#define sgs_FIND_PRIVIOUS_SELECTOR(supCls, type) \
    if (sgTargetClass && sgTargetObject && sgTargetSelector) {\
        anInvocation.selector = sgTargetSelector.injectionSelector;\
    } else if (sgTargetClass && sgTargetObject && [NSStringFromSelector(anInvocation.selector) hasPrefix:sgTargetObject.sgs_Prifix_Object]) {\
        sgTargetSelector = [sgTargetObject findPreviousTargetSelector:anInvocation.selector methodType:type];\
        if (sgTargetSelector) {\
            anInvocation.selector = sgTargetSelector.injectionSelector;\
        } else {\
            SGSTargetClass *sgTargetSuperClass = [[SGSAopUtil sharedUtil] findTargetClass:[self superclass]];\
            SGSTargetObject *sgTargetSuperObject = [sgTargetSuperClass findTargetObject:[self superclass]];\
            SEL trueSel = [sgTargetObject trueSelector:anInvocation.selector];\
            SGSTargetSelector *sgTargetSuperSelector = [sgTargetSuperObject findTargetSelector:trueSel methodType:type];\
            SEL oriSel = [SGSTargetObject sgsOriginalSelector:trueSel];\
            if (sgTargetSuperSelector && (class_getMethodImplementation(supCls, oriSel) == class_getMethodImplementation(supCls, oriSel))) {\
                anInvocation.selector = sgTargetSuperSelector.injectionSelector;\
            } else {\
                anInvocation.selector = [sgTargetObject originalTargetSelector:anInvocation.selector];\
            }\
        }\
    } else if (sgTargetSuperClass) {\
       SGSTargetObject *sgTargetSuperObject = [sgTargetSuperClass findTargetObject:[self superclass]];\
       SGSTargetSelector *sgTargetSuperSelector = [sgTargetSuperObject findTargetSelector:anInvocation.selector methodType:type];\
       if (sgTargetSuperSelector)  {\
           anInvocation.selector = sgTargetSuperSelector.injectionSelector;\
       } else if ([NSStringFromSelector(anInvocation.selector) hasPrefix:sgTargetSuperObject.sgs_Prifix_Object]) {\
           SGSTargetSelector *sgTargetSuperSelector = [sgTargetSuperObject findPreviousTargetSelector:anInvocation.selector methodType:type];\
           \
           if (sgTargetSuperSelector) {\
               anInvocation.selector = sgTargetSuperSelector.injectionSelector;\
           } else if (sgTargetSuperObject) {\
               anInvocation.selector = [sgTargetSuperObject originalTargetSelector:anInvocation.selector];\
           }\
       }\
    }
    
#define sgs_GET_RETURN_VALUE(type) do { type val = 0; [anInvocation getReturnValue:&val]; return @(val); } while (0)
#define sgs_RETURN \
    const char *returnType = anInvocation.methodSignature.methodReturnType;\
    if (strcmp(returnType, @encode(id)) == 0 || strcmp(returnType, @encode(Class)) == 0) {\
        __autoreleasing id returnObj;\
        [anInvocation getReturnValue:&returnObj];\
        return returnObj;\
    } else if (strcmp(returnType, @encode(SEL)) == 0) {\
        SEL selector = 0;\
        [anInvocation getReturnValue:&selector];\
        return NSStringFromSelector(selector);\
    } else if (strcmp(returnType, @encode(Class)) == 0) {\
        __autoreleasing Class theClass = Nil;\
        [anInvocation getReturnValue:&theClass];\
        return theClass;\
    } else if (strcmp(returnType, @encode(char)) == 0) {\
        sgs_GET_RETURN_VALUE(char);\
    } else if (strcmp(returnType, @encode(int)) == 0) {\
        sgs_GET_RETURN_VALUE(int);\
    } else if (strcmp(returnType, @encode(short)) == 0) {\
        sgs_GET_RETURN_VALUE(short);\
    } else if (strcmp(returnType, @encode(long)) == 0) {\
        sgs_GET_RETURN_VALUE(long);\
    } else if (strcmp(returnType, @encode(long long)) == 0) {\
        sgs_GET_RETURN_VALUE(long long);\
    } else if (strcmp(returnType, @encode(unsigned char)) == 0) {\
        sgs_GET_RETURN_VALUE(unsigned char);\
    } else if (strcmp(returnType, @encode(unsigned int)) == 0) {\
        sgs_GET_RETURN_VALUE(unsigned int);\
    } else if (strcmp(returnType, @encode(unsigned short)) == 0) {\
        sgs_GET_RETURN_VALUE(unsigned short);\
    } else if (strcmp(returnType, @encode(unsigned long)) == 0) {\
        sgs_GET_RETURN_VALUE(unsigned long);\
    } else if (strcmp(returnType, @encode(unsigned long long)) == 0) {\
        sgs_GET_RETURN_VALUE(unsigned long long);\
    } else if (strcmp(returnType, @encode(float)) == 0) {\
        sgs_GET_RETURN_VALUE(float);\
    } else if (strcmp(returnType, @encode(double)) == 0) {\
        sgs_GET_RETURN_VALUE(double);\
    } else if (strcmp(returnType, @encode(BOOL)) == 0) {\
        sgs_GET_RETURN_VALUE(BOOL);\
    } else if (strcmp(returnType, @encode(bool)) == 0) {\
        sgs_GET_RETURN_VALUE(BOOL);\
    } else if (strcmp(returnType, @encode(char *)) == 0) {\
        sgs_GET_RETURN_VALUE(const char *);\
    } else if (strcmp(returnType, @encode(void (^)(void))) == 0) {\
        __unsafe_unretained id block = nil;\
        [anInvocation getReturnValue:&block];\
        return [block copy];\
    } else if (strcmp(returnType, @encode(void)) == 0) {\
        return nil;\
    } else {\
        NSUInteger valueSize = 0;\
        NSGetSizeAndAlignment(returnType, &valueSize, NULL);\
        unsigned char valueBytes[valueSize];\
        [anInvocation getReturnValue:valueBytes];\
        return [NSValue valueWithBytes:valueBytes objCType:returnType];\
    }\
    return nil;

+ (id)sgs_performSelectorWithAopInvocation:(NSInvocation *)anInvocation {
    
    SGSTargetClass *sgTargetClass = [[SGSAopUtil sharedUtil] findTargetClass:[self class]];
    SGSTargetObject *sgTargetObject = [sgTargetClass findTargetObject:self];
    SGSTargetSelector *sgTargetSelector = [sgTargetObject findTargetSelector:anInvocation.selector methodType:SGSAOPMethodType_ClassType];

    SGSTargetClass *sgTargetSuperClass = [[SGSAopUtil sharedUtil] findTargetClass:[self superclass]];
    
//    if (sgTargetClass && sgTargetObject && sgTargetSelector) {
//        anInvocation.selector = sgTargetSelector.injectionSelector;
//    } else if (sgTargetClass && sgTargetObject && [NSStringFromSelector(anInvocation.selector) hasPrefix:sgTargetObject.sgs_Prifix_Object]) {
//        sgTargetSelector = [sgTargetObject findPreviousTargetSelector:anInvocation.selector methodType:SGSAOPMethodType_ClassType];
//        if (sgTargetSelector) {
//            anInvocation.selector = sgTargetSelector.injectionSelector;
//        } else {
//            SGSTargetClass *sgTargetSuperClass = [[SGSAopUtil sharedUtil] findTargetClass:[self superclass]];
//            SGSTargetObject *sgTargetSuperObject = [sgTargetSuperClass findTargetObject:[self superclass]];
//            SEL trueSel = [sgTargetObject trueSelector:anInvocation.selector];
//            SGSTargetSelector *sgTargetSuperSelector = [sgTargetSuperObject findTargetSelector:trueSel methodType:SGSAOPMethodType_ClassType];
//            SEL oriSel = [SGSTargetObject sgsOriginalSelector:trueSel];
//            if (sgTargetSuperSelector && (class_getMethodImplementation(objc_getMetaClass(NSStringFromClass([self class]).UTF8String), oriSel) == class_getMethodImplementation(objc_getMetaClass(NSStringFromClass([self superclass]).UTF8String), oriSel))) {
//                anInvocation.selector = sgTargetSuperSelector.injectionSelector;
//            } else {
//                anInvocation.selector = [sgTargetObject originalTargetSelector:anInvocation.selector];
//            }
//        }
//    } else if (sgTargetSuperClass) {
//       SGSTargetObject *sgTargetSuperObject = [sgTargetSuperClass findTargetObject:[self superclass]];
//        SGSTargetSelector *sgTargetSuperSelector = [sgTargetSuperObject findTargetSelector:anInvocation.selector methodType:SGSAOPMethodType_InstanceType];
//        if (sgTargetSuperSelector)  {
//            anInvocation.selector = sgTargetSuperSelector.injectionSelector;
//        } else if ([NSStringFromSelector(anInvocation.selector) hasPrefix:sgTargetSuperObject.sgs_Prifix_Object]) {
//           SGSTargetSelector *sgTargetSuperSelector = [sgTargetSuperObject findPreviousTargetSelector:anInvocation.selector methodType:SGSAOPMethodType_ClassType];
//
//           if (sgTargetSuperSelector) {
//               anInvocation.selector = sgTargetSuperSelector.injectionSelector;
//           } else if (sgTargetSuperObject) {
//               anInvocation.selector = [sgTargetSuperObject originalTargetSelector:anInvocation.selector];
//           }
//       }
//    }
    Class superCls = objc_getMetaClass(NSStringFromClass([self superclass]).UTF8String);
    sgs_FIND_PRIVIOUS_SELECTOR(superCls, SGSAOPMethodType_ClassType);
    if ([anInvocation.target respondsToSelector:anInvocation.selector]) {
        [anInvocation invoke];
    } else {
        if (sgTargetSelector && [NSStringFromSelector(anInvocation.selector) hasPrefix:sgTargetObject.sgs_Prifix_Object]) {
            [sgTargetSelector.originClass doesNotRecognizeSelector:[sgTargetObject trueSelector:anInvocation.selector]];
        } else {
            [self doesNotRecognizeSelector:anInvocation.selector];
        }
    }
    
    sgs_RETURN;
}

- (id)sgs_performSelectorWithAopInvocation:(NSInvocation *)anInvocation {
    
    SGSTargetClass *sgTargetClass = [[SGSAopUtil sharedUtil] findTargetClass:[self class]];
    SGSTargetObject *sgTargetObject = [sgTargetClass findTargetObject:self];
    if (!sgTargetObject) {
        sgTargetObject = [sgTargetClass findTargetObject:[self class]];
    }
    SGSTargetSelector *sgTargetSelector = [sgTargetObject findTargetSelector:anInvocation.selector methodType:SGSAOPMethodType_InstanceType];

    SGSTargetClass *sgTargetSuperClass = [[SGSAopUtil sharedUtil] findTargetClass:[self superclass]];

//    if (sgTargetSelector) {
//        anInvocation.selector = sgTargetSelector.injectionSelector;
//    } else if (sgTargetObject && [NSStringFromSelector(anInvocation.selector) hasPrefix:sgTargetObject.sgs_Prifix_Object]) {
//        sgTargetSelector = [sgTargetObject findPreviousTargetSelector:anInvocation.selector methodType:SGSAOPMethodType_InstanceType];
//        if (sgTargetSelector) {
//            anInvocation.selector = sgTargetSelector.injectionSelector;
//        } else {
//            SGSTargetClass *sgTargetSuperClass = [[SGSAopUtil sharedUtil] findTargetClass:[self superclass]];
//            SGSTargetObject *sgTargetSuperObject = [sgTargetSuperClass findTargetObject:[self superclass]];
//            SEL trueSel = [sgTargetObject trueSelector:anInvocation.selector];
//            SGSTargetSelector *sgTargetSuperSelector = [sgTargetSuperObject findTargetSelector:trueSel methodType:SGSAOPMethodType_InstanceType];
//            SEL oriSel = [SGSTargetObject sgsOriginalSelector:trueSel];
//            if (sgTargetSuperSelector && (class_getMethodImplementation([self class], oriSel) == class_getMethodImplementation([self superclass], oriSel))) {
//                anInvocation.selector = sgTargetSuperSelector.injectionSelector;
//            } else {
//                anInvocation.selector = [sgTargetObject originalTargetSelector:anInvocation.selector];
//            }
//        }
//    } else if (sgTargetSuperClass) {
//        SGSTargetObject *sgTargetSuperObject = [sgTargetSuperClass findTargetObject:[self superclass]];
//        SGSTargetSelector *sgTargetSuperSelector = [sgTargetObject findTargetSelector:anInvocation.selector methodType:SGSAOPMethodType_InstanceType];
//        if (sgTargetSuperSelector)  {
//            anInvocation.selector = sgTargetSuperSelector.injectionSelector;
//        } else if ([NSStringFromSelector(anInvocation.selector) hasPrefix:sgTargetSuperObject.sgs_Prifix_Object]) {
//            SGSTargetSelector *sgTargetSuperSelector = [sgTargetSuperObject findPreviousTargetSelector:anInvocation.selector methodType:SGSAOPMethodType_InstanceType];
//
//            if (sgTargetSuperSelector) {
//                anInvocation.selector = sgTargetSuperSelector.injectionSelector;
//            } else if (sgTargetSuperObject) {
//                anInvocation.selector = [sgTargetSuperObject originalTargetSelector:anInvocation.selector];
//            }
//        }
//    }
    sgs_FIND_PRIVIOUS_SELECTOR([self class], SGSAOPMethodType_InstanceType);
    if ([anInvocation.target respondsToSelector:anInvocation.selector]) {
        [anInvocation invoke];
    } else {
        if (sgTargetSelector && [NSStringFromSelector(anInvocation.selector) hasPrefix:sgTargetObject.sgs_Prifix_Object]) {
            [sgTargetSelector.originClass doesNotRecognizeSelector:[sgTargetObject trueSelector:anInvocation.selector]];
        } else if (sgTargetObject && [NSStringFromSelector(anInvocation.selector) hasPrefix:[[SGSTargetObject class] sgsOriginalSelectorPrefix]]) {
            [self doesNotRecognizeSelector:[sgTargetObject sgsOriginalSelector_ErrorLog:anInvocation.selector]];
        } else {
            [self doesNotRecognizeSelector:anInvocation.selector];
        }
    }
    
    sgs_RETURN;
}
#undef sgs_RETURN
#undef sgs_GET_RETURN_VALUE
#undef sgs_FIND_PRIVIOUS_SELECTOR

@end
