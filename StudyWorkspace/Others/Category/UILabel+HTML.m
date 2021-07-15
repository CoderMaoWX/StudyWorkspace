//
//  UILabel+HTML
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//


#import "UILabel+HTML.h"

@implementation UILabel (HTML)
- (void)WX_setHTMLFromString:(NSString *)string {
    
    if (![string length]) return;
    
    string = [string stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>",
                                              self.font.fontName,
                                              self.font.pointSize]];
    // 使用 NSHTMLTextDocumentType 时，要在子线程初始化，在主线程赋值，否则会不定时出现 webthread crash
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSAttributedString *stringAttributed = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.attributedText = stringAttributed;
        });
    });
    
}

- (void)WX_setHTMLFromString:(NSString *)string textColor:(NSString *)textColor {
    
    if (![string length]) return;
    
    string = [string stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx; color:%@;}</style>",
                                              self.font.fontName,
                                              self.font.pointSize,
                                              textColor]];
    // 使用 NSHTMLTextDocumentType 时，要在子线程初始化，在主线程赋值，否则会不定时出现 webthread crash
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSAttributedString *stringAttributed = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.attributedText = stringAttributed;
        });
    });
    
}


- (void)WX_setHTMLFromString:(NSString *)string completion: (void (^)(NSAttributedString *stringAttributed))completion {
    
    if (![string length]) return;
    
    string = [string stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>",
                                              self.font.fontName,
                                              self.font.pointSize]];
    // 使用 NSHTMLTextDocumentType 时，要在子线程初始化，在主线程赋值，否则会不定时出现 webthread crash
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSAttributedString *stringAttributed = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
        

        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.attributedText = stringAttributed;
            if (completion) {
                completion(stringAttributed);
            }
        });
    });
    
}
@end
