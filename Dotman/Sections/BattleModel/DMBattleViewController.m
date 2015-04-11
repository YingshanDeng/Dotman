//
//  DMBattleViewController.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/9.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMBattleViewController.h"
#import "YALTabBarInteracting.h"

@interface DMBattleViewController () <YALTabBarInteracting>

@end

@implementation DMBattleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:1.000 green:0.837 blue:0.532 alpha:1.000]];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - YALTabBarInteracting

- (void)extraLeftItemDidPressed
{
    NSLog(@"LEFT-- 发起游戏");
}

- (void)extraRightItemDidPressed
{
    NSLog(@"RIGHT -- 加入游戏");
}


@end
