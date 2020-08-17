//
//  SecondViewController.m
//  XibDemo
//
//  Created by mao wangxin on 2017/1/5.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "StudyVC13.h"

@interface StudyVC13 ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) UILabel *customLabel;
@end

@implementation StudyVC13

- (void)viewDidLoad {
    [super viewDidLoad];
}


/**
 * 初始化
 */
- (UILabel *)customLabel {
    if(!_customLabel){
        _customLabel = [[UILabel alloc] init];
        _customLabel.backgroundColor = [UIColor greenColor];
        _customLabel.text = @"UILabel+UILabel";
        [_customLabel sizeToFit];
        _customLabel.center = self.view.center;
        [self.view addSubview:_customLabel];
    }
    return _customLabel;
}

/**
 * 抖动弹性动画
 */
- (IBAction)btnAction1:(id)sender
{
    self.customLabel.center = CGPointMake(self.view.center.x-20, self.view.center.y);
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.1
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        self.customLabel.center = CGPointMake(self.view.center.x, self.view.center.y);
    }
                     completion:nil];
}

/**
 * 弹性约束动画
 */
- (IBAction)btnAction2:(id)sender {
    [self.textLabel removeFromSuperview];

    [UIView animateWithDuration:3
                          delay:0
         usingSpringWithDamping:0.1
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

@end
