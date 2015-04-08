//
//  DMRoundNode.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/8.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  圆形node
 */
@interface DMRoundNode : UIView

/**
 *  指定颜色(必需)
 */
@property (nonatomic, strong) UIColor *nodeColor;

/**
 *  指定图片(可选)
 */
@property (nonatomic, strong) UIImage *nodeImage;

@end

