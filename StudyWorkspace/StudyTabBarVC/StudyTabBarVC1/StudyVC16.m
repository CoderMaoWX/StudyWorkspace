//
//  StudyVC16.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/11/12.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "StudyVC16.h"
#import "UIImage+YYWebImage.h"
#import "UIButton+WXExtension.h"

@interface StudyVC16 ()
@property (nonatomic, strong) UIButton *addToBagBtn;
@end

@implementation StudyVC16

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.addToBagBtn];
}

-(UIButton *)addToBagBtn{
    if (!_addToBagBtn) {
        _addToBagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addToBagBtn.frame = CGRectMake(20, 100, 380, 48);;
        _addToBagBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [_addToBagBtn setTitle:@"ADD TO BAG" forState:UIControlStateNormal];
        [_addToBagBtn addTarget:self action:@selector(addToBagBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _addToBagBtn.layer.masksToBounds = YES;
        _addToBagBtn.layer.cornerRadius = 2.0;
        _addToBagBtn.contentMode = UIViewContentModeScaleAspectFill;
        
        UIColor *textColor = [UIColor whiteColor];
        UIColor *backgroundColor = [UIColor redColor];
        [_addToBagBtn setTitleColor:textColor forState:UIControlStateNormal];
        [_addToBagBtn setBackgroundColor:backgroundColor];
        [_addToBagBtn setBackgroundImage:nil forState:UIControlStateNormal];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"checkout_arrow" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        //UIImage *gifImage = [UIImage sd_imageWithGIFData:gifData];//SDWebImage方法不能设置大小
        UIImage *gifImage = [UIImage yy_imageWithSmallGIFData:gifData scale:3];
        [_addToBagBtn setImage:gifImage forState:UIControlStateNormal];
        [_addToBagBtn layoutStyle:(WXButtonEdgeInsetsStyleRight) imageTitleSpace:5];
    }
    return _addToBagBtn;
}

- (void)addToBagBtnAction {
    
}

@end
