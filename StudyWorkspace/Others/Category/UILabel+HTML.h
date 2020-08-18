//
//  UILabel+HTML.h
//  Zaful
//
//  Created by liuxi on 2017/9/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (HTML)

- (void)zf_setHTMLFromString:(NSString *)string;

- (void)zf_setHTMLFromString:(NSString *)string textColor:(NSString *)textColor;

- (void)zf_setHTMLFromString:(NSString *)string completion: (void (^)(NSAttributedString *stringAttributed))completion;
@end
