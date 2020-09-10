//
//  UIWindow+Lookin.h
//  StudyWorkspace
//
//  Created by 610582 on 2020/9/10.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (Lookin)

// @override
- (BOOL)canBecomeFirstResponder;

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;

@end

NS_ASSUME_NONNULL_END
