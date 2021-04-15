//
//  UIImage+Extension.h
//  StudyWorkspace
//
//  Created by 610582 on 2021/4/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

///原图 -> 高斯模糊图
- (UIImage *)blurImageWithDegree:(CGFloat)blurDegree;

@end

NS_ASSUME_NONNULL_END
