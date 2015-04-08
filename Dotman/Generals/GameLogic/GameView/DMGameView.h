//
//  DMGameView.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/8.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMGameView : UIView


/**
 *  能否进行游戏
 */
@property (nonatomic, assign) BOOL canPlaying;

/**
 *  能否绘制消除线条
 */
@property (nonatomic, assign) BOOL canDrawLine;


- (void)startGame;


@end
