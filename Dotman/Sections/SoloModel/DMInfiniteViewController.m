//
//  DMInfiniteViewController.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/11.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMInfiniteViewController.h"
#import "DMGameView.h"
#import "AppDelegate.h"

@interface DMInfiniteViewController () <DMGameViewDelegate>

@property (nonatomic, strong) DMGameView *gameView;

@end

@implementation DMInfiniteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.310 green:1.000 blue:0.308 alpha:1.000]];
    
    [self setupGameView];
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

#pragma mark - DMGameViewDelegate
- (void)didFinishOnceDisappearWithScore:(NSInteger)score
{
    
}


@end
