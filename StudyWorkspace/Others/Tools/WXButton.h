//
//  WXButton.h
//  StudyWorkspace
//
//  Created by Luke on 2022/3/13.
//  Copyright © 2022 MaoWX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WXImagePlacementStyle) {
    WXImagePlacementLeading = 0, // image在左，label在右
    WXImagePlacementTrailing,    // image在右，label在左
    WXImagePlacementTop,         // image在上，label在下
    WXImagePlacementBottom,      // image在下，label在上
};

@interface WXButton : UIButton

/// Defaults to Leading, only single edge values (top/leading/bottom/trailing) are supported.
@property (nonatomic, assign) WXImagePlacementStyle imagePlacementStyle;

@property (nonatomic, assign) CGFloat imageTitleSpace;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, strong) UIFont *titleFont;

@property(nonatomic, strong) UIColor *titleColor;

@property(nonatomic, assign) NSInteger numberOfLines;

@property(nonatomic, copy) NSAttributedString *attributedTitle;

@property(nonatomic, assign) NSLineBreakMode textLineBreakMode;

@property(nonatomic, assign) CGFloat preferredMaxLayoutWidth;

@property(nonatomic, strong) UIImage *image;

@property(nonatomic, strong) UIImage *backgroundImage;

///Margin: (top/leading/bottom/trailing)
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat leadingMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat trailingMargin;

@end
