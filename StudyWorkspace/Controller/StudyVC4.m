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

@end
