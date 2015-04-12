//
//  DMMovingViewController.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/11.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMMovingViewController.h"
#import "DMGameView.h"
#import "DMWaveView.h"
#import "AppDelegate.h"


@interface DMMovingViewController () <DMGameViewDelegate>

/**
 *  游戏视图
 */
@property (nonatomic, strong) DMGameView *gameView;

/**
 *  当前可移动次数
 */
@property (nonatomic, assign) NSInteger movingNumber;

/**
 *  水波背景视图
 */
@property (nonatomic, strong) DMWaveView *waveView;

@end

@implementation DMMovingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:223.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
  
    [self setupGameView];
    [self setupWaveView];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.gameView startGame];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

#pragma mark - 游戏界面相关
- (void)setupGameView
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    CGRect tabBarFrame = delegate.tabBarViewController.tabBarView.frame;
    CGFloat height = ScreenRect.size.height - tabBarFrame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.gameView = [[DMGameView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
    self.gameView.delegate = self;
    // 设置游戏背景为透明色
    [self.gameView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.gameView];
}


#pragma mark - 移动次数相关
- (void)setupWaveView
{
    self.waveView = [[DMWaveView alloc] initWithFrame:self.gameView.frame];
    CGFloat lowestWaveHeight = self.waveView.frame.size.height - 10;

    self.waveView.waveHeight = lowestWaveHeight;
    self.waveView.waveColor = DMTabBarViewController_TabBarView_TabBarColor;
    [self.waveView startWaterWave];
    [self.view insertSubview:self.waveView belowSubview:self.gameView];
}

#pragma mark - DMGameViewDelegate
- (void)didFinishOnceDisappearWithScore:(NSInteger)score
{
    // 提升水波的高度
    CGFloat interval = self.waveView.frame.size.height / DM_Solo_Moving_Game_Number;
    self.waveView.waveHeight -= interval;
}

@end
