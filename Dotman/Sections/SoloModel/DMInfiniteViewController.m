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

#import "DMHamburgerButton.h"
#import "JTNumberScrollAnimatedView.h"

@interface DMInfiniteViewController () <DMGameViewDelegate>

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


@end

@implementation DMInfiniteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.310 green:1.000 blue:0.308 alpha:1.000]];
    
    [self setupCustomNavigationItem];
    [self setupGameView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    self.currentScore = 0;
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
    self.menuBtn.showMenu = !self.menuBtn.showMenu;
}


// 设置当前的分数
- (void)updateScore:(NSInteger)score
{
    self.scoreView.value = @(score);
    [self.scoreView startAnimation];
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
    self.currentScore += score;
    [self updateScore:self.currentScore];
}


@end
