//
//  NSDictionary+SafeAccess.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/1/25.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "NSDictionary+SafeAccess.h"

@implementation NSDictionary (SafeAccess)

- (NSDictionary *)deleteAllNullValue {
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return @{};
    }
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in self.allKeys) {
        if ([[self objectForKey:keyStr] isEqual:[NSNull null]]
            || [self objectForKey:keyStr] == nil) {
            [mutableDic setObject:@"" forKey:keyStr];
        } else {
            [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

- (BOOL)hasKey:(NSString *)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    return [self objectForKey:key] != nil;
}

- (NSString*)ds_stringForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return  @"";
    }
    
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return @"";
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return @"";
}

- (NSNumber*)ds_numberForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return  nil;
    }
    
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    return nil;
}

- (NSDecimalNumber *)ds_decimalNumberForKey:(id)key {
    
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return  nil;
    }
    
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber * number = (NSNumber*)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString * str = (NSString*)value;
        return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
    }
    return nil;
}


- (NSArray*)ds_arrayForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return @[];
    }
    
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return @[];
    }
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    return @[];
}


- (NSDictionary*)ds_dictionaryForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return  @{};
    }
    
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return @{};
    }
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    return @{};
}

- (NSInteger)ds_integerForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return  0;
    }
    
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    return 0;
}

- (NSUInteger)ds_unsignedIntegerForKey:(id)key{
    
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return  0;
    }
    
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value unsignedIntegerValue];
    }
    return 0;
}

- (BOOL)ds_boolForKey:(id)key {
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value boolValue];
    }
    return NO;
}

- (int16_t)ds_int16ForKey:(id)key {
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}

- (int32_t)ds_int32ForKey:(id)key {
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}

- (int64_t)ds_int64ForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value longLongValue];
    }
    return 0;
}

- (char)ds_charForKey:(id)key{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value charValue];
    }
    return 0;
}

- (short)ds_shortForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}

- (float)ds_floatForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value floatValue];
    }
    return 0;
}

- (double)ds_doubleForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value doubleValue];
    }
    return 0;
}

- (long long)ds_longLongForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value longLongValue];
    }
    return 0;
}

- (unsigned long long)ds_unsignedLongLongForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        value = [nf numberFromString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedLongLongValue];
    }
    return 0;
}

- (NSDate *)dateForKey:(id)key dateFormat:(NSString *)dateFormat {
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = dateFormat;
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""] && !dateFormat) {
        return [formater dateFromString:value];
    }
    return nil;
}

//CG
- (CGFloat)CGFloatForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return 0.0;
    }
    
    CGFloat f = [self[key] doubleValue];
    return f;
}

- (CGPoint)pointForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return CGPointZero;
    }
    
    CGPoint point = CGPointFromString(self[key]);
    return point;
}

- (CGSize)sizeForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return CGSizeZero;
    }
    
    CGSize size = CGSizeFromString(self[key]);
    return size;
}

- (CGRect)rectForKey:(id)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSDictionary class]]) {
        return CGRectZero;
    }
    
    CGRect rect = CGRectFromString(self[key]);
    return rect;
}

@end

#pragma --mark NSMutableDictionary setter

@implementation NSMutableDictionary (SafeAccess)

-(void)setObj:(id)i forKey:(NSString*)key {
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    
    if (i!=nil) {
        self[key] = i;
    }
}

-(void)setString:(NSString*)i forKey:(NSString*)key;
{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    [self setValue:i forKey:key];
}

-(void)setBool:(BOOL)i forKey:(NSString *)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    self[key] = @(i);
}

-(void)setInt:(int)i forKey:(NSString *)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    self[key] = @(i);
}

-(void)setInteger:(NSInteger)i forKey:(NSString *)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    self[key] = @(i);
}

-(void)setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    self[key] = @(i);
}

-(void)setCGFloat:(CGFloat)f forKey:(NSString *)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    self[key] = @(f);
}

-(void)setChar:(char)c forKey:(NSString *)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    self[key] = @(c);
}

-(void)setFloat:(float)i forKey:(NSString *)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    self[key] = @(i);
}

-(void)setDouble:(double)i forKey:(NSString*)key{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    self[key] = @(i);
}

-(void)setLongLong:(long long)i forKey:(NSString*)key{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    self[key] = @(i);
}

-(void)setPoint:(CGPoint)o forKey:(NSString *)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    self[key] = NSStringFromCGPoint(o);
}

-(void)setSize:(CGSize)o forKey:(NSString *)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    self[key] = NSStringFromCGSize(o);
}

-(void)setRect:(CGRect)o forKey:(NSString *)key
{
    // 兼容判断
    if (![self isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    self[key] = NSStringFromCGRect(o);
}
@end
