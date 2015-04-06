//
//  DMMacros.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/5.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#ifndef Dotman_DMMacros_h
#define Dotman_DMMacros_h

/**
 *  屏幕 bounds
 */
#define ScreenRect  [[UIScreen mainScreen] bounds]

/**
 *  状态栏 frame
 */
#define StatusFrame [[UIApplication sharedApplication] statusBarFrame]


// 获取RGB颜色
#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)      RGBA(r,g,b,1.0f)


#endif
