//
//  StudyVC18.m
//  StudyWorkspace
//
//  Created by 610582 on 2022/12/30.
//  Copyright © 2022 MaoWX. All rights reserved.
//

#import "StudyVC18.h"

@interface StudyVC18 ()
@property (weak, nonatomic) IBOutlet UILabel *backgroundTextLabel;
@property (nonatomic, strong) UIView *tmpColorView;
@property (weak, nonatomic) IBOutlet UILabel *foregroundTextLabel;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (nonatomic, strong) UIImageView *tmpMaskView;
@end

@implementation StudyVC18

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)valueChangedAction:(UISlider *)sender {
    CGFloat maskX = sender.value;
    self.tmpMaskView.frame = CGRectMake(maskX, 0, 77, 30);

    CGFloat textX = self.foregroundTextLabel.frame.origin.x + maskX;
    CGFloat textY = self.foregroundTextLabel.frame.origin.y;
    self.tmpColorView.frame = CGRectMake(textX, textY, 77, 30);
}

- (UIImageView *)tmpMaskView {
    if (!_tmpMaskView) {
        _tmpMaskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_send"]];
        _tmpMaskView.contentMode = UIViewContentModeScaleAspectFill;

        self.foregroundTextLabel.textColor = UIColor.whiteColor;
        self.foregroundTextLabel.maskView = _tmpMaskView;
    }
    return _tmpMaskView;
}

- (UIView *)tmpColorView {
    if (!_tmpColorView) {
        _tmpColorView = [[UIView alloc] initWithFrame:CGRectZero];
        _tmpColorView.backgroundColor = [UIColor blueColor];
        [self.view addSubview:_tmpColorView];
        [self.view insertSubview:_tmpColorView belowSubview:self.foregroundTextLabel];
    }
    return _tmpColorView;
}


@end
