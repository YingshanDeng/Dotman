//
//  DMGameView.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/8.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMGameView;
@protocol DMGameViewDelegate <NSObject>

/**
 *  完成一次消除过程的回调
 *
 *  @param score 该次消除的得分
 */
- (void)didFinishOnceDisappearWithScore:(NSInteger)score;

@end

@interface DMGameView : UIView

/**
 *  能否进行游戏
 */
@property (nonatomic, assign) BOOL canPlaying;

/**
 *  能否绘制消除线条
 */
@property (nonatomic, assign) BOOL canDrawLine;


/**
 *  委托
 */
@property (nonatomic, weak) id<DMGameViewDelegate> delegate;

/**
 *  开始游戏
 */
- (void)startGame;

/**
 *  暂停游戏
 */
- (void)pauseGame;

/**
 *  恢复游戏
 */
- (void)resumeGame;

/**
 *  重启游戏
 */
- (void)restartGame;

/**
 *  停止游戏
 */
- (void)stopGameWithCompletion:(void (^)(void))block;

/**
 *  游戏结束
 */
- (void)gameOver;

@end
