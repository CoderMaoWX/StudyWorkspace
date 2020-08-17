//
//  DrawCGPathVC.m
//  DrawDemo
//
//  Created by mao wangxin on 2017/6/4.
//  Copyright © 2017年 Luke. All rights reserved.
//

#import "DrawCGPathVC.h"
#import "DrawPathView.h"

@interface DrawCGPathVC ()
@end

@implementation DrawCGPathVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shouldPanBack = NO;
}


/**
 *  开始涂鸦
 */
- (IBAction)startDrawPath:(UIButton *)sender
{
    DrawPathView *selfView = (DrawPathView *)self.view;
    [selfView startDrawPath];
}

/**
 *  重新涂鸦
 */
- (IBAction)afreshDrawPath:(UIButton *)sender
{
    DrawPathView *selfView = (DrawPathView *)self.view;
    [selfView afreshDrawPath];
}

/**
 *  轨迹运动
 */
- (IBAction)moveSport:(UIButton *)sender
{
    DrawPathView *selfView = (DrawPathView *)self.view;
    [selfView moveLayerFromPath];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
