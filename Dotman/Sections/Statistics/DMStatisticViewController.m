//
//  DMStatisticViewController.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/25.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMStatisticViewController.h"
#import "UIImage+Additions.h"

@interface DMStatisticViewController ()

@end

@implementation DMStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:DMTabBarViewController_TabBarView_BackgroundColor];
    [self setupNavigationItemTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



@end
