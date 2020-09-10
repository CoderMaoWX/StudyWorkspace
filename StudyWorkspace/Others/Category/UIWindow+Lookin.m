//
//  UIWindow+Lookin.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/9/10.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "UIWindow+Lookin.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation UIWindow (Lookin)

//默认是NO，所以得重写此方法，设成YES
- (BOOL)canBecomeFirstResponder {
     return YES;
}

//然后实现下列方法://很像TouchEvent事件
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

/**
* http://iphonedevwiki.net/index.php/AudioServices
* 震动反馈1: (3DTouch中的peek)
* (1521: peek震动, 1520:pop震动, 1521:三连震) 系统声音: 1057
* 优点:能满足大部分震动场景, (使用时倒入头文件: #import <AudioToolbox/AudioToolbox.h> )
* 缺点:无法精准控制震动力度
*/
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"摇晃手机");
    SystemSoundID soundID = 1057;
    AudioServicesPlaySystemSound(soundID);
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self playSound:1000];
//    });
    
    UIAlertController *alertController =  [UIAlertController
                                           alertControllerWithTitle: nil
                                           message:@"导出UI结构"
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"审查元素" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"3D视图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"测间距" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIViewController *rootVC = window.rootViewController;
    [rootVC presentViewController:alertController animated:YES completion:nil];
}
 
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

- (void)playSound:(SystemSoundID)soundID {
    AudioServicesPlaySystemSound(soundID);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger addID = soundID + 1;
        NSLog(@"系统声音编号: %ld", (long)addID);
        [self playSound:(SystemSoundID)addID];
    });
}

@end
