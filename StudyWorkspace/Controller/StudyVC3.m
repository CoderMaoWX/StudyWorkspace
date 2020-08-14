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
    self.horizontalStackView.frame = CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width-20, 100);
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
