//
//  WXColorDefiner.h
//  StudyWorkspace
//
//  Created by mao wangxin on 2017/1/18.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#ifndef WXColorDefiner_h
#define WXColorDefiner_h

//----------------------颜色类宏---------------------------
//rgb颜色
#define RGB(r,g,b)                          [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f                                                                                 alpha:1.f]

//rgb颜色,  a:透明度
#define RGB_A(r,g,b,a)                      [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f                                                                                 alpha:(a)]

// (16进制->10进制, a:透明度）
#define UIColorFromHex_A(hexValue, a)       [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:(a)]

#define UIColorFromHex(hexValue)            ([UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0x00FF00) >> 8))/255.0 blue:((float)(hexValue & 0x0000FF))/255.0 alpha:1.0])


//----------------------规范:全局颜色宏---------------------------

//view背景
#define Color_BackGround           UIColorFromHex(0xf5f5f5)

//主色
#define Color_Main                 UIColorFromHex(0xfe9b00)

//主色 (按钮不点击)
#define Color_DisableBtn           RGB(227, 227, 227)

//全局灰色线条颜色
#define Color_Line                 UIColorFromHex(0xe5e5e5)

//全局输入框边框颜色
#define Color_TextBorderColor      RGB(207, 207, 207)

//全局黑色字体颜色
#define Color_BlackFont            UIColorFromHex(0x323232)

//全局灰色字体颜色
#define Color_grayFont             UIColorFromHex(0xa4a4a4)

//纯白色
#define WhiteColor                 [UIColor whiteColor]

//cell的DetailTextLabel字体颜色
#define DetailTextLabelColor       (UIColorFromHex(0xa4a4a4))

/** 导航栏字体颜色*/
#define WXNavBarFontColor          (WhiteColor)
/** 导航栏背景颜色*/
#define WXNabBarBackColor          (UIColorFromHex(0x282828))


//----------------------按钮状态颜色宏---------------------------

#define WX_Btn_NormalColor       (Color_Main)
#define WX_Btn_HighlightedColor  ([Color_Main colorWithAlphaComponent:0.4])
#define WX_Btn_DisabledColor     (UIColorFromHex(0xdcdcdc))


#endif /* WXColorDefiner_h */
