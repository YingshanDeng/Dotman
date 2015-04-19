//
//  DMGameOverView.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/19.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMGameOverView;

@protocol DMGameOverViewDelegate <NSObject>

- (void)didGameOverViewSelectExit:(DMGameOverView *)gameOverView;

- (void)didGameOverViewSelectPlayAgain:(DMGameOverView *)gameOverView;

@end


@interface DMGameOverView : UIView

@property (nonatomic, weak) id<DMGameOverViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withBlurView:(UIView *)blurView withScore:(NSInteger)score;

- (void)updateScore:(NSInteger)score;

- (void)showGameOverViewWithBlock:(void (^)(void))block;

- (void)hideGameOverViewWithBlock:(void (^)(void))block;

@end
