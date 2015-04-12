//
//  DMWaveView.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/11.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMWaveView : UIView

/**
 *  水波的高度
 *  注：水波的高度指的是距离顶部的高度
 */
@property (nonatomic, assign) CGFloat waveHeight;

/**
 *  水波颜色
 */
@property (nonatomic, strong) UIColor *waveColor;

/**
 *  开始水波动画
 */
- (void)startWaterWave;

/**
 *  暂停水波动画
 */
- (void)pauseWateWave;

/**
 *  恢复水波动画
 */
- (void)resumeWaterWave;

@end
