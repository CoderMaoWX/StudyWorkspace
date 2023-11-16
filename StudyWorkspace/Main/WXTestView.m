//
//  WXTestView.m
//  StudyWorkspace
//
//  Created by 610582 on 2023/5/15.
//  Copyright © 2023 MaoWX. All rights reserved.
//

#import "WXTestView.h"

@implementation WXTestView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addDismissControl];
    }
    return self;
}

- (void)addDismissControl {
    CGRect rect = self.bounds;
    rect.size.height -= 20;//点击背景消失
    UIControl *control = [[UIControl alloc] initWithFrame:rect];
    [control addTarget:self action:@selector(hideAddCartPopView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

- (void)hideAddCartPopView {
    NSLog(@"hideAddCartPopView");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"WXTestView : %@", event);
}
@end
