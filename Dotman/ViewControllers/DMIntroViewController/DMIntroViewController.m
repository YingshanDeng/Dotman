//
//  DMIntroViewController.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/5.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMIntroViewController.h"

#import "YALFirstTestViewController.h"

#import "SevenSwitch.h"

@interface DMIntroViewController ()

@end

@implementation DMIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:DMTabBarViewController_TabBarView_BackgroundColor];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:(CGRect){120, 100, 100, 50}];
    [btn setTitle:@"go" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    SevenSwitch *mySwitch2 = [[SevenSwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    mySwitch2.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5 - 80);
    [mySwitch2 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    mySwitch2.offImage = [UIImage imageNamed:@"cross.png"];
    mySwitch2.onImage = [UIImage imageNamed:@"check.png"];
    mySwitch2.onTintColor = [UIColor colorWithHue:0.08f saturation:0.74f brightness:1.00f alpha:1.00f];
    mySwitch2.inactiveColor = [UIColor whiteColor]; // Sets the background color when the switch is off, white
    mySwitch2.isRounded = NO;
    [self.view addSubview:mySwitch2];
}

- (void)switchChanged:(SevenSwitch *)sender {
    NSLog(@"Changed value to: %@", sender.on ? @"ON" : @"OFF");
}


- (void)goAction:(UIButton *)btn
{
    YALFirstTestViewController *vc = [[YALFirstTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
