//
//  DMTimingViewController.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/11.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMTimingViewController.h"
#import "ASProgressPopUpView.h"
#import "AppDelegate.h"
#import "DMGameView.h"


@interface DMTimingViewController () <ASProgressPopUpViewDataSource, DMGameViewDelegate>

/**
 *  定时器视图
 */
@property (nonatomic, strong) ASProgressPopUpView *timerProgressView;


/**
 *  定时器是否暂停标识
 */
@property (nonatomic, assign) BOOL pauseFlag;

/**
 *  游戏视图
 */
@property (nonatomic, strong) DMGameView *gameView;


@end


@implementation DMTimingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupGameView];
    [self setupTimerView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.gameView startGame];
    [self startProgress];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _pauseFlag = YES; // 用于停止定时器
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
    CGFloat height = ScreenRect.size.height - 2.5 - tabBarFrame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.gameView = [[DMGameView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
    self.gameView.delegate = self;
    [self.view addSubview:self.gameView];
}


#pragma mark - 定时器相关
// 定时器视图
- (void)setupTimerView
{
    self.timerProgressView = [[ASProgressPopUpView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    CGRect tabBarFrame = delegate.tabBarViewController.tabBarView.frame;
    // progress bar 的高度固定是 2.5
    CGFloat y = ScreenRect.size.height - tabBarFrame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame) - 2.5;
    [self.timerProgressView setFrame:CGRectMake(tabBarFrame.origin.x, y, ScreenRect.size.width, 2.5)];
    
    self.timerProgressView.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20.0f];
    self.timerProgressView.popUpViewColor = DMTabBarViewController_TabBarView_TabBarColor;
    
    self.timerProgressView.dataSource = self;
    
    self.timerProgressView.progress = 0;
    [self.timerProgressView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.timerProgressView];
}

// 定时器开始
- (void)startProgress
{
    [self.timerProgressView showPopUpViewAnimated:YES];
    self.pauseFlag = NO;
    [self progress];
}

// 定时器暂停
- (void)pauseProgress
{
    self.pauseFlag = YES;
}

// 定时器恢复
- (void)resumeProgress
{
    self.pauseFlag = NO;
    [self progress];
}

- (void)progress
{
    if (!self.pauseFlag)
    {
        float progress = self.timerProgressView.progress;
        if (progress < 1.0)
        {
            progress += 0.05 / DM_Solo_Timing_Game_Duration;
            [self.timerProgressView setProgress:progress animated:YES];
            [NSTimer scheduledTimerWithTimeInterval:0.05
                                             target:self
                                           selector:@selector(progress)
                                           userInfo:nil
                                            repeats:NO];
        }
        else if (progress == 1.0)
        {
            self.pauseFlag = YES;
        }
    }
}

#pragma mark - ASProgressPopUpViewDataSource
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    CGFloat cur = progress * DM_Solo_Timing_Game_Duration;
    NSInteger second = floor(cur);
    NSInteger microSecond = floor((cur - second) * 100);
//    NSLog(@"%02ld--%02ld", (long)second, (long)microSecond);
    return [NSString stringWithFormat:@"%02ld.%02ld s", (long)second, (long)microSecond];
}

// by default ASProgressPopUpView precalculates the largest popUpView size needed
// it then uses this size for all values and maintains a consistent size
// if you want the popUpView size to adapt as values change then return 'NO'
- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return NO;
}

#pragma mark - DMGameViewDelegate
- (void)didFinishOnceDisappearWithScore:(NSInteger)score
{
    
}

#pragma mark - Other
- (void)dealloc
{
    _pauseFlag = YES;
}


@end
