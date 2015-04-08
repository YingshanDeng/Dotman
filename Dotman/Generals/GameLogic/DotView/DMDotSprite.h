//
//  DMDotSprite.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/8.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMRoundNode.h"

@interface DMDotSprite : UIView

/**
 *  显示状态的 Dot
 */
@property (nonatomic, strong) DMRoundNode *showingDot;

/**
 *  选中状态的 Dot
 */
@property (nonatomic, strong) DMRoundNode *selectingDot;

/**
 *  颜色
 */
@property (nonatomic, strong) UIColor *dotColor;

/**
 *  Dot 的坐标索引
 */
@property (nonatomic, assign) CGPoint coordinate;

/**
 *  创建后的初始位置：处于屏幕外（top of screen）
 */
@property (nonatomic, assign) CGPoint originPosition;

/**
 *  最终的现实位置
 */
@property (nonatomic, assign) CGPoint showingPosition;

/**
 *  dot 是否动画ing
 */
@property (nonatomic, assign) BOOL animating;

/**
 *  是否消除
 */
@property (nonatomic, assign) BOOL disappear;




/**
 *  生成 Dot Sprite
 *
 *  @param coordinate       坐标索引（并非真实的坐标位置）
 *  @param superViewFrame   父视图的frame
 */
- (void)generateDotWithCoordinate:(CGPoint)coordinate withSuperViewFrame:(CGRect)superViewFrame;

/**
 *  dot 接收点击区域
 *
 *  @return rect
 */
- (CGRect)getDetetionAreaRect;

/**
 *  游戏开始时dot掉落动画
 */
- (void)runStartDropDownAnimationWithBlock:(void (^)(int index))block;

/**
 *  选中时的瞬间动画
 */
- (void)runSelectingAnimation;

/**
 *  消除dot的动画
 */
- (void)runDisappearDotAnimationWithBlock:(void (^)(void))block;


/**
 *  选中dot之上的dot的掉落动画
 */
- (void)runDropDownAnimation;

/**
 *  重新生产dot
 */
- (void)reGenerateDotWithBlock:(void (^)(void))block;

/**
 *  调整dot颜色动画（遇到当前无法玩的情况）
 */
- (void)runPlayabilityAdjustAnimationWithDelay:(int)delay withBlock:(void (^)(int index))block;


@end
