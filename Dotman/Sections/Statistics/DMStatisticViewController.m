//
//  DMStatisticViewController.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/25.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMStatisticViewController.h"
#import "UIImage+Additions.h"
#import "PNChart.h"
#import "DMStatisticHandler.h"

@interface DMStatisticViewController ()

@property (nonatomic, strong) PNPieChart *pieChart;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation DMStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:DMTabBarViewController_TabBarView_BackgroundColor];
    [self setupNavigationItemTitle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupPieChart];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.pieChart removeFromSuperview];
    self.pieChart = nil;
}


#pragma mark -
- (void)setupNavigationItemTitle
{
    // 设置 navi bar 背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:DMTabBarViewController_TabBarView_BackgroundColor] forBarMetrics:UIBarMetricsDefault];
    // 设置 navi bar title 的样式
    NSDictionary *attributes =@{NSFontAttributeName: [UIFont fontWithName:DMFont_Title_Type size:22.0f],
                                NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    // 设置标题
    self.navigationItem.title = @"Statistic";
}


- (void)setupPieChart
{
    NSInteger timing = [[DMStatisticHandler defaultStatisticHandler] getPlayCount:DMPlayTimingMode];
    NSInteger monving=  [[DMStatisticHandler defaultStatisticHandler] getPlayCount:DMPlayMovingMode];
    NSInteger infinite = [[DMStatisticHandler defaultStatisticHandler] getPlayCount:DMPlayInfiniteMode];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:timing color:PNLightGreen description:@"Timing"],
                       [PNPieChartDataItem dataItemWithValue:monving color:PNFreshGreen description:@"Moving"],
                       [PNPieChartDataItem dataItemWithValue:infinite color:PNDeepGreen description:@"Infinite"],
                       ];
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 135, 200.0, 200.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = YES;
    self.pieChart.showOnlyValues = NO;
    [self.view addSubview:self.pieChart];
    [self.pieChart strokeChart];
}

//TODO: 
- (void)setupTipLabel
{
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.adjustsFontSizeToFitWidth = YES;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.tipLabel];
}

#pragma mark - Others

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
