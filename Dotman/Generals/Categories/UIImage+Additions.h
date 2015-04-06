//
//  UIImage+Additions.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/6.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

/**
 *  根据颜色获取纯色图片image
 *
 *  @param color 指定颜色
 *
 *  @return 纯色图片image
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
