//
//  DMIntroViewController.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/5.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMIntroViewController.h"
#import "FBShimmeringView.h"
#import "RQShineLabel.h"


// 欢迎 label 文字
NSString * const DMIntroViewController_Welcome_String = @"Welcome to Dotman";
// 提示 label 文字
NSString * const DMIntroViewController_Tip_String     = @"Colorful World Colorful Game";

@interface DMIntroViewController ()

@end

@implementation DMIntroViewController
{
    // "Welcome to Dotman"
    RQShineLabel *_welcomeLabel;
    
    // "Colorful World Colorful Game"
    FBShimmeringView *_shimmeringView;
    UILabel *_colorfulLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:DMTabBarViewController_TabBarView_BackgroundColor];
}


// 设置位置
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    CGRect welcomeLabelFrame = self.view.bounds;
    welcomeLabelFrame.origin.y = welcomeLabelFrame.size.height * 0.1f;
    welcomeLabelFrame.size.height = welcomeLabelFrame.size.height * 0.3;
    _welcomeLabel.frame = welcomeLabelFrame;
    
    CGRect shimmeringFrame = self.view.bounds;
    shimmeringFrame.origin.y = shimmeringFrame.size.height * 0.65;
    shimmeringFrame.size.height = shimmeringFrame.size.height * 0.15;
    _shimmeringView.frame = shimmeringFrame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupWelcomeLabel];
    
    
    //TODO: 添加 dots
    
    
    [self setupShimmeringView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_welcomeLabel shineWithCompletion:^{
        
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_welcomeLabel removeFromSuperview];
    _welcomeLabel = nil;
    [_colorfulLabel removeFromSuperview];
    _colorfulLabel = nil;
}

#pragma mark - 
- (void)setupWelcomeLabel
{
    // "Welcome to Dotman"
    _welcomeLabel = [[RQShineLabel alloc] initWithFrame:self.view.bounds];
    _welcomeLabel.text = DMIntroViewController_Welcome_String;
    _welcomeLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:60.0];
    _welcomeLabel.fadeoutDuration = 0.5f;
    _welcomeLabel.textColor = [UIColor whiteColor];
    _welcomeLabel.textAlignment = NSTextAlignmentCenter;
    _welcomeLabel.backgroundColor = [UIColor clearColor];
    _welcomeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _welcomeLabel.numberOfLines = 0;
    [self.view addSubview:_welcomeLabel];
}

- (void)setupShimmeringView
{
    // "Colorful World Colorful Game"
    _shimmeringView = [[FBShimmeringView alloc] init];
    _shimmeringView.shimmering = YES;
    _shimmeringView.shimmeringBeginFadeDuration = 2.5f;
    _shimmeringView.shimmeringOpacity = .3f;
    [self.view addSubview:_shimmeringView];
    
    _colorfulLabel = [[UILabel alloc] initWithFrame:_shimmeringView.bounds];
    _colorfulLabel.text = DMIntroViewController_Tip_String;
    _colorfulLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25.0];
    _colorfulLabel.textColor = [UIColor whiteColor];
    _colorfulLabel.textAlignment = NSTextAlignmentCenter;
    _colorfulLabel.backgroundColor = [UIColor clearColor];
    _colorfulLabel.adjustsFontSizeToFitWidth = YES;
    _shimmeringView.contentView = _colorfulLabel;
}

#pragma mark - 

- (void)prepareForAnimation
{
    
}

- (void)performAnimation
{
    
}

@end
