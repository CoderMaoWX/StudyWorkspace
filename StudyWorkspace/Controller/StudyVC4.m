//
//  StudyVC4.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "StudyVC4.h"

@interface StudyVC4 ()

@end

@implementation StudyVC4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self testInvocationMethod];
}


#pragma mark - ====================== <NSInvocation> ======================

/**
 * NSInvocation;用来包装方法和对应的对象，它可以存储方法的名称，对应的对象，对应的参数,
 * NSMethodSignature：签名：再创建NSMethodSignature的时候，必须传递一个签名对象， 签名对象的作用：用于获取参数的个数和方法的返回值
 */
 - (void)testInvocationMethod {
     //创建签名对象的时候不是使用NSMethodSignature这个类创建，而是方法属于谁就用谁来创建
     NSMethodSignature*signature = [StudyVC4 instanceMethodSignatureForSelector:@selector(sendMessageWithNumber:WithContent:)];
     //1、创建NSInvocation对象
     NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
     invocation.target = self;
     //invocation中的方法必须和签名中的方法一致。
     invocation.selector = @selector(sendMessageWithNumber:WithContent:);
     /*第一个参数：需要给指定方法传递的值, 第一个参数需要接收一个指针，也就是传递值的时候需要传递地址*/
     //第二个参数：需要给指定方法的第几个参数传值
     NSString*number = @"1111";
     //注意：设置参数的索引时不能从0开始，因为0已经被self占用，1已经被_cmd占用
     [invocation setArgument:&number atIndex:2];
     NSString*number2 = @"啊啊啊";
     [invocation setArgument:&number2 atIndex:3];
     //2、调用NSInvocation对象的invoke方法
     //只要调用invocation的invoke方法，就代表需要执行NSInvocation对象中制定对象的指定方法，并且传递指定的参数
     [invocation invoke];
}

- (void)sendMessageWithNumber:(NSString*)number WithContent:(NSString*)content{
    NSLog(@"number: %@, content: %@",number,content);
}


- (void)userDefaultApi {
    /**
    // 同步对共享对象的任何更改默认用户和从内存中释放它。
    resetStandardUserDefaults
    // 返回共享默认对象。
    + (NSUserDefaults *)standardUserDefaultsaddSuiteNamed：
    // 插入到接收器的搜索列表中指定的域名。
    - (void)addSuiteNamed:( NSString *) suiteName
    // 返回与指定键相关联的数组。
    - ( NSArray *)arrayForKey:( NSString *) defaultName
    // 返回布尔值与指定键相关联。
    - (BOOL)boolForKey:( NSString *) defaultName
    // 返回数据对象与指定键相关联。
    - ( NSData *)dataForKey:( NSString *) defaultName
    // 返回Dictionary对象与指定键相关联。
    - ( NSDictionary *)dictionaryForKey:( NSString *) defaultName
    // 返回一个字典，它包含在搜索列表中的域的所有键值对联盟。（ NSData ， NSString ， NSNumber ， NSDate ，NSArray ，或NSDictionary ）
    - ( NSDictionary *)dictionaryRepresentation
    // 消除了在标准应用程序域指定的默认??键值。
    - (void)removeObjectForKey:( NSString *) defaultName
    // 删除指定的从用户的默认持久域的内容。
    - (void)removePersistentDomainForName:( NSString *) domainName
    // 设置指定的默认??键到指定的布尔值。
    - (void)setBool:(BOOL) value forKey:( NSString *) defaultName
    // 设置为指定的字典持久域。
    - (void)setPersistentDomain:( NSDictionary *) domain forName:( NSString *) domainName
    // 设置指定的默认??键到指定的URL值。
    - (void)setURL:( NSURL *) url forKey:( NSString *) defaultName
    // 设置为指定的字典挥发性域。
    - (void)setVolatileDomain:( NSDictionary *) domain forName:( NSString *) domainName
    // 返回与指定键关联的字符串数组。
    - ( NSArray *)stringArrayForKey:( NSString *) defaultName
    // 返回与指定键关联的字符串。
    - ( NSString *)stringForKey:( NSString *) defaultName
    //返回NSURL实例与指定键相关联。
    - ( NSURL *)URLForKey:( NSString *) defaultName
    // 返回double值与指定键相关联。
    - (double)doubleForKey:( NSString *) defaultName
    // 返回浮点值与指定键相关联。
    - (float)floatForKey:( NSString *) defaultName
    // 返回NSUserDefaults对象初始化的用户帐户的默认为指定的。
    - (id)initWithUser:( NSString *) username
    // 返回整数值与指定键关联..
    - （ NSInteger NSInteger )integerForKey:( NSString *) defaultName
    // 返回与指定默认的第一个发生关联的对象。
    - (id)objectForKey:( NSString *) defaultName
    // 判断此key是否存在
    - (BOOL)objectIsForcedForKey:( NSString *) key

     */
}


@end
