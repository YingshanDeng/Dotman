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
#import "DMHamburgerButton.h"
#import "JTNumberScrollAnimatedView.h"
#import "DMCoverView.h"
#import "DMGameOverView.h"
#import "UIImage+Additions.h"

@interface DMMovingViewController () <DMGameViewDelegate, DMGameOverViewDelegate>

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

/**
 *  navigation item left bar button item
 */
@property (nonatomic, strong) DMHamburgerButton *menuBtn;

/**
 *  navigation item right bar button item
 */
@property (nonatomic, strong) JTNumberScrollAnimatedView *scoreView;

/**
 *  当前的分数
 */
@property (nonatomic, assign) NSInteger currentScore;

/**
 *  下拉视图（包含恢复，重启，退出三个button）
 */
@property (nonatomic, strong) UIView *dropView;

/**
 *  阴影覆盖层
 */
@property (nonatomic, strong) DMCoverView *coverView;

/**
 *  游戏结束视图
 */
@property (nonatomic, strong) DMGameOverView *gameOverView;


@end

@implementation DMMovingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:223.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
  
    [self setupCustomNavigationItem];
    [self setupGameView];
    [self setupWaveView];
    [self setupDropDownView];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 初始化当前的分数
    self.currentScore = 0;

    // 可以移动的次数
    self.movingNumber = DM_Solo_Moving_Game_Number;
    
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

#pragma mark - Navigation Item
/**
 *  Navigation Item自定义
 */
- (void)setupCustomNavigationItem
{
    // 隐藏导航栏的 back item
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem = nil;
    
    [self setupNavigationItemLeftBarButtonItem];
    [self setupNavigationItemRightBarButtonItem];
}

- (void)setupNavigationItemLeftBarButtonItem
{
    self.menuBtn = [[DMHamburgerButton alloc] initWithFrame:CGRectZero];
    [self.menuBtn addTarget:self action:@selector(menuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuBtn setTransform:CGAffineTransformMakeScale(0.47, 0.47)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuBtn];
}

- (void)setupNavigationItemRightBarButtonItem
{
    CGFloat naviHeight = self.navigationController.navigationBar.frame.size.height;
    
    // score label
    UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25];
    NSAttributedString *scoreAttrString = [[NSAttributedString alloc] initWithString:@"Score" attributes:@{NSFontAttributeName : labelFont, NSForegroundColorAttributeName : [UIColor whiteColor]}];
    CGSize labelSize = [scoreAttrString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGRect labelFrame = CGRectMake(0, 0, labelSize.width, naviHeight);
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [scoreLabel setAttributedText:scoreAttrString];
    [scoreLabel setAdjustsFontSizeToFitWidth:YES];
    [scoreLabel setTextAlignment:NSTextAlignmentRight];
    
    
    // score view
    NSString *formatString = @"000000"; // 六位数显示
    UIFont *scoreViewFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24]; //HelveticaNeue-Light
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:formatString attributes:@{NSFontAttributeName : scoreViewFont, NSForegroundColorAttributeName : [UIColor whiteColor]}];
    CGRect rect = [attrString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    // 加 10 宽度使数字之间不会太紧密
    CGSize scoreViewSize = CGSizeMake(rect.size.width + 10, naviHeight);
    
    // Score 和 数字之间的间隔
    CGFloat interval = 8.0f;
    
    CGRect scoreViewFrame = CGRectMake(labelSize.width + interval, 0, scoreViewSize.width, naviHeight);
    self.scoreView = [[JTNumberScrollAnimatedView alloc] initWithFrame:scoreViewFrame];
    self.scoreView.textColor = [UIColor whiteColor];
    self.scoreView.font = scoreViewFont;
    self.scoreView.value = @(0);
    self.scoreView.minLength = 6;
    self.scoreView.duration = 1.0f;
    [self.scoreView startAnimation];
    
    
    // content view
    UIView *contentView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(labelSize.width + scoreViewSize.width + interval, naviHeight)}];
    [contentView addSubview:scoreLabel];
    [contentView addSubview:self.scoreView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:contentView];
}


- (void)menuBtnAction:(UIButton *)btn
{
    if (!self.menuBtn.showMenu)
    {
        [self addShadowCoverView];
        [self showDropDownView];
        [self pauseGame]; // 暂停游戏
    }
    else
    {
        [self removeShadowCoverView];
        [self hideDropDownView];
        [self resumeGame]; // 恢复游戏
    }
    self.menuBtn.showMenu = !self.menuBtn.showMenu;
    
    //TODO: 此处用于防止连续点击，待重构
    self.menuBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.menuBtn.enabled = YES;
    });
}

#pragma mark - 阴影覆盖层
// 添加阴影覆盖层
- (void)addShadowCoverView
{
    if (self.coverView == nil)
    {
        self.coverView = [[DMCoverView alloc] initCoverViewWithFrame:self.gameView.bounds withType:DMCoverViewShadowType withBlurView:nil];
        [self.view insertSubview:self.coverView belowSubview:self.dropView];
    }
    self.coverView.hidden = NO;
    [self.coverView fadeInToShowWithBlock:^{
        
    }];
}

// 移除阴影覆盖层
- (void)removeShadowCoverView
{
    [self.coverView fadeOutToHideWithBlock:^{
        
    }];
}

#pragma mark - 游戏结束视图
- (void)setupGameOverview
{
    if (self.gameOverView == nil)
    {
        self.gameOverView = [[DMGameOverView alloc]initWithFrame:self.gameView.bounds withBlurView:self.gameView withScore:self.currentScore];
        self.gameOverView.delegate = self;
        [self.view addSubview:self.gameOverView];
    }
    else
    {
        [self.gameOverView updateScore:self.currentScore];
    }
}

#pragma mark - 游戏控制
/**
 *  暂停游戏
 */
- (void)pauseGame
{
    [self.gameView pauseGame];
    [self.waveView pauseWateWave];
}

/**
 *  恢复游戏
 */
- (void)resumeGame
{
    [self.gameView resumeGame];
    [self.waveView resumeWaterWave];
}

/**
 *  停止游戏
 */
- (void)stopGame
{
    [self.gameView stopGameWithCompletion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

/**
 *  重启游戏
 */
- (void)restartGame
{
    [self.gameView restartGame];
    [self.waveView resumeWaterWave];
    self.currentScore = 0;
    [self updateScore:self.currentScore];
}

/**
 *  游戏结束
 */
- (void)gameOver
{
    self.menuBtn.enabled = NO;
    [self.gameView gameOver];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupGameOverview];
        [self.gameOverView showGameOverViewWithBlock:^{
            
        }];
    });
   
}

// 设置当前的分数
- (void)updateScore:(NSInteger)score
{
    self.scoreView.value = @(score);
    [self.scoreView startAnimation];
}


#pragma mark - 下拉框
- (void)setupDropDownView
{
    CGRect dropFrame = CGRectMake(0, - 180, self.view.bounds.size.width, 180);
    self.dropView = [[UIView alloc] initWithFrame:dropFrame];
    [self.dropView setBackgroundColor:DMTabBarViewController_TabBarView_TabBarColor];
    [self.view addSubview:self.dropView];
    
    
    CGFloat btnHeight = 50.0f;
    
    
    UIButton *resumeBtn = [self dropDownButtonWithTitle:@"Resume"];
    [resumeBtn setTag:DMSoloGameDropDownButtonResumeType];
    CGRect resumeBtnFrame = CGRectMake(0, 29, self.dropView.frame.size.width, btnHeight);
    [resumeBtn setFrame:resumeBtnFrame];
    [self.dropView addSubview:resumeBtn];
    
    UIImageView *lineBreakView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79, self.dropView.frame.size.width, 0.5)];
    [lineBreakView_2 setBackgroundColor:[UIColor colorWithWhite:1.000 alpha:0.600]];
    [self.dropView addSubview:lineBreakView_2];
    
    UIButton *restartBtn = [self dropDownButtonWithTitle:@"Restart"];
    [restartBtn setTag:DMSoloGameDropDownButtonRestartType];
    CGRect restartBtnFrame = CGRectMake(0, 80.5, self.dropView.frame.size.width, btnHeight);
    [restartBtn setFrame:restartBtnFrame];
    [self.dropView addSubview:restartBtn];
    
    UIImageView *lineBreakView_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 129.5, self.dropView.frame.size.width, 0.5)];
    [lineBreakView_1 setBackgroundColor:[UIColor colorWithWhite:1.000 alpha:0.600]];
    [self.dropView addSubview:lineBreakView_1];
    
    UIButton *exitBtn = [self dropDownButtonWithTitle:@"Exit"];
    [exitBtn setTag:DMSoloGameDropDownButtonExitType];
    CGRect exitBtnFrame = CGRectMake(0, 130, self.dropView.frame.size.width, btnHeight);
    [exitBtn setFrame:exitBtnFrame];
    [self.dropView addSubview:exitBtn];
    
    
}

- (UIButton *)dropDownButtonWithTitle:(NSString *)btnTitle
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIColor *btnNormalColor = DMTabBarViewController_TabBarView_TabBarColor;
    UIColor *btnHighlightedColor = [UIColor colorWithRed:0.297 green:0.878 blue:0.744 alpha:1.000];
    
    [btn setBackgroundImage:[UIImage imageWithColor:btnNormalColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:btnHighlightedColor] forState:UIControlStateHighlighted];
    
    
    UIFont *font = [UIFont fontWithName:DMFont_Detail_Type size:20.0f];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:btnTitle attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [btn setAttributedTitle:attrString forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(dropDownBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


- (void)dropDownBtnAction:(UIButton *)btn
{
    [self removeShadowCoverView];
    [self hideDropDownView];
    self.menuBtn.showMenu = !self.menuBtn.showMenu;
    
    DMSoloGameDropDownButtonType type = (DMSoloGameDropDownButtonType)btn.tag;
    switch (type)
    {
        case DMSoloGameDropDownButtonResumeType:
        {
            [self resumeGame];
            break;
        }
        case DMSoloGameDropDownButtonRestartType:
        {
            [self restartGame];
            break;
        }
        case DMSoloGameDropDownButtonExitType:
        {
            // 为了让下拉视图弹回去，给了一个延时
            CGFloat delay = 0.5;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self stopGame];
            });
            break;
        }
        default:
            break;
    }
}


- (void)showDropDownView
{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:!self.menuBtn.showMenu ? 0.0 : 0.6
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         CGRect frame = self.dropView.frame;
                         frame.origin.y = -30;
                         [self.dropView setFrame:frame];
                         
                     } completion:nil];
}

- (void)hideDropDownView
{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:!self.menuBtn.showMenu ? 0.0 : 0.6
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         CGRect frame = self.dropView.frame;
                         frame.origin.y = -180;
                         [self.dropView setFrame:frame];
                         
                     } completion:nil];
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


#pragma mark - 移动次数相关的水波视图
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
    
    // 加分
    self.currentScore += score;
    [self updateScore:self.currentScore];
    
    self.movingNumber --;
    if (self.movingNumber == 0)
    {
        [self gameOver];
    }
}

#pragma mark - DMGameOverViewDelegate
- (void)didGameOverViewSelectPlayAgain:(DMGameOverView *)gameOverView
{
    self.menuBtn.enabled = YES;
    __weak __typeof(&*self)weakSelf = self;
    [self.gameOverView hideGameOverViewWithBlock:^{
        [weakSelf restartGame];
    }];
}

- (void)didGameOverViewSelectExit:(DMGameOverView *)gameOverView
{
    __weak __typeof(&*self)weakSelf = self;
    [self.gameOverView hideGameOverViewWithBlock:^{
        [weakSelf stopGame];
    }];
}


@end
