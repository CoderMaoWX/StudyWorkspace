//
//  StudyVC3.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "StudyVC3.h"

@interface StudyVC3 ()
@property (nonatomic, strong) UIStackView * verticalStackView;
@property (nonatomic, strong) UIStackView * horizontalStackView;
@end

@implementation StudyVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.horizontalStackView];
    self.horizontalStackView.frame = CGRectMake(10, 100, 300, 100);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UILabel * lbl = [self textLbl];
    
    [self.horizontalStackView addArrangedSubview:lbl];
    [UIView animateWithDuration:1 animations:^{
        [self.horizontalStackView layoutIfNeeded];
    }];
}

- (UILabel *)textLbl{
    UILabel * lbl = [UILabel new];
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    lbl.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    lbl.text = @"文字";
    return lbl;
}

/**
 Alignment                              效果
 UIStackViewAlignmentFill               在StackView垂直方向上拉伸所有子view，使得填充完StackView

 UIStackViewAlignmentLeading            在StackView垂直方向上按照子view的leading edge对齐

 UIStackViewAlignmentTop                等效UIStackViewAlignmentLeading,用于竖向Stackview

 UIStackViewAlignmentFirstBaseline      在StackView垂直方向上按照子view 的first baseline对其，仅适用于水平方向StackView

 UIStackViewAlignmentCenter             在StackView垂直方向上按照子View的中心线对其

 UIStackViewAlignmentTrailing           在StackView垂直方向上按照子View的trailing edge对齐

 UIStackViewAlignmentBottom             等效UIStackViewAlignmentTrailing,用于竖向Stackview

 UIStackViewAlignmentLastBaseline       在StackView垂直方向上按照子view 的last baseline对齐，仅适用于水平方向StackView
 */


/* *
 Distribution                               效果
 UIStackViewDistributionFill
 在StackView延伸方向上缩放子View使得子View能填充完StackView，子View的缩放顺序依赖于其hugging优先级，如果相等的话，则按照index顺序

 UIStackViewDistributionFillEqually
 在StackView延伸方向上将每个子View都拉伸成一样长

 UIStackViewDistributionFillProportionally
 在StackView延伸方向上将根据子View的内容进行缩放

 UIStackViewDistributionEqualSpacing
 在StackView延伸方向上将子View中间隔相等的空白进行缩放，如果子View不够大，则用空白填充开始部分，如果子View过大，则根据hugging顺序缩放，如果相等的话，则按照index顺序

 UIStackViewDistributionEqualCentering
 在StackView延伸方向上将子View的中线线，等距进行缩放，如果子View不够大，则用空白填充开始部分，如果子View过大，则根据hugging顺序缩放，如果相等的话，则按照index顺序

 */

#pragma mark --- 懒加载

- (UIStackView *)horizontalStackView{
    if (_horizontalStackView == nil) {
        _horizontalStackView = [UIStackView new];
        _horizontalStackView.axis = UILayoutConstraintAxisHorizontal;
        _horizontalStackView.distribution = UIStackViewDistributionFillEqually;
        _horizontalStackView.spacing = 10;
        _horizontalStackView.alignment = UIStackViewAlignmentFill;
        _horizontalStackView.backgroundColor = [UIColor yellowColor];
    }
    return _horizontalStackView;
}

@end
