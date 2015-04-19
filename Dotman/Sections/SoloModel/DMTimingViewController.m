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
#import "UIImage+Additions.h"
#import "DMCoverView.h"
#import "DMHamburgerButton.h"
#import "JTNumberScrollAnimatedView.h"


/**
 *  下拉按键的类型
 */
typedef NS_ENUM(NSInteger, DMSoloGameDropDownButtonType)
{
    DMSoloGameDropDownButtonResumeType = 0,
    DMSoloGameDropDownButtonRestartType,
    DMSoloGameDropDownButtonExitType
};


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

@end


@implementation DMTimingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    

    [self setupCustomNavigationItem];
    
    
    [self setupGameView];
    [self setupTimerView];
    
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
}


#pragma mark - 阴影覆盖层
// 添加阴影覆盖层
- (void)addShadowCoverView
{
    if (self.coverView == nil)
    {
        self.coverView = [[DMCoverView alloc] initCoverViewWithFrame:self.gameView.bounds withType:DMCoverViewShadowType withBlurView:nil];
    }
    [self.view insertSubview:self.coverView belowSubview:self.dropView];
    [self.coverView fadeInToShow];
}

// 移除阴影覆盖层
- (void)removeShadowCoverView
{
    [self.coverView fadeOutToHide];
}

#pragma mark - 游戏控制
/**
 *  暂停游戏
 */
- (void)pauseGame
{
    [self.gameView pauseGame];
    [self pauseProgress];
}

/**
 *  恢复游戏
 */
- (void)resumeGame
{
    [self.gameView resumeGame];
    [self resumeProgress];
}

/**
 *  停止游戏
 */
- (void)stopGame
{
    CGFloat delay = 0.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.gameView stopGameWithCompletion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    });
}

/**
 *  重启游戏
 */
- (void)restartGame
{
    [self.gameView restartGame];
    self.currentScore = 0;
    [self updateScore:self.currentScore];
    [self restartProgress];
}

/**
 *  游戏结束
 */
- (void)gameOver
{
 
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
            [self stopGame];
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

// 重启定时器
- (void)restartProgress
{
    self.timerProgressView.progress = 0;
    self.pauseFlag = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self progress];
    });
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
            // 游戏结束
            [self gameOver];
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
    self.currentScore += score;
    [self updateScore:self.currentScore];
}

#pragma mark - Other
- (void)dealloc
{
    _pauseFlag = YES;
}


@end
