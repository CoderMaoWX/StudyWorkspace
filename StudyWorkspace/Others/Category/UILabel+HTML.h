//
//  UILabel+HTML
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (HTML)

- (void)WX_setHTMLFromString:(NSString *)string;

- (void)WX_setHTMLFromString:(NSString *)string textColor:(NSString *)textColor;

- (void)WX_setHTMLFromString:(NSString *)string completion: (void (^)(NSAttributedString *stringAttributed))completion;
@end
