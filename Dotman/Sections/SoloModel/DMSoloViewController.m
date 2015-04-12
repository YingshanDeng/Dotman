//
//  DMSoloViewController.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/9.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMSoloViewController.h"
#import "UIImage+Additions.h"
#import "SphereMenu.h"

#import "MultiplePulsingHaloLayer.h"

#import "DMTimingViewController.h"
#import "DMMovingViewController.h"
#import "DMInfiniteViewController.h"


// button title
#define DMSoloGameTimingButtonTitle   @"Timing"
#define DMSoloGameMovingButtonTitle   @"Moving"
#define DMSoloGameInfiniteButtonTitle @"Infinite"

#define DMSoloViewController_Tip_Label_Text @"Tap to Select Mode"

// 间隔距离
#define DMSoloViewController_SubViews_Margins 20.0f


// 单人模式下的三种类型
typedef NS_ENUM(NSInteger, DMSoloGameType)
{
    DMSoloGameTimingType,
    DMSoloGameMovingType,
    DMSoloGameInfiniteType
};


@interface DMSoloViewController () <SphereMenuDelegate>
/**
 *  大标题提示
 */
@property (nonatomic, strong) UILabel *tipLabel;

/**
 *  Menu Button
 */
@property (nonatomic, strong) SphereMenu *menuBtn;

/**
 *  MultiplePulsingHaloLayer
 */
@property (nonatomic, strong) MultiplePulsingHaloLayer *haloLayer;

/**
 *  选择的单机游戏模式
 */
@property (nonatomic, assign) DMSoloGameType selectedType;

@end

@implementation DMSoloViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:DMTabBarViewController_TabBarView_BackgroundColor];
    [self setupNavigationItemTitle];
    
    
    [self setupTipLabel];
    [self setupMenuButton];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupHaloLayer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.menuBtn collapseSphereMenu];
    ç
    [self.haloLayer removeFromSuperlayer];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect tipLabelFrame = self.tipLabel.frame;
    tipLabelFrame.origin.y = self.view.bounds.size.height * 0.05f;
    tipLabelFrame.size.height = self.view.bounds.size.height * 0.1f;
    [self.tipLabel setFrame:tipLabelFrame];

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
    self.navigationItem.title = @"Solo Game Mode";
}


- (void)setupTipLabel
{
    self.tipLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.tipLabel.text = DMSoloViewController_Tip_Label_Text;
    self.tipLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:38.0];
    self.tipLabel.adjustsFontSizeToFitWidth = YES;
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tipLabel];
}

- (void)setupMenuButton
{
    UIImage *image1 = [UIImage imageNamed:@"icon-twitter"];
    UIImage *image2 = [UIImage imageNamed:@"icon-email"];
    UIImage *image3 = [UIImage imageNamed:@"icon-facebook"];
    NSArray *images = @[image1, image2, image3];
    
    NSArray *subMenuLabelTextArray = @[DMSoloGameTimingButtonTitle, DMSoloGameMovingButtonTitle, DMSoloGameInfiniteButtonTitle];
    
    CGPoint startPoint = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, self.view.bounds.size.height * 0.5);
    self.menuBtn = [[SphereMenu alloc] initWithSize:CGSizeMake(60, 60) withCenterPoint:startPoint withStartBtnColor:DMTabBarViewController_TabBarView_TabBarColor withStartBtnTitle:@"Tap" withSubMenuImages:images withSubMenuLabelTexts:subMenuLabelTextArray];
    
    self.menuBtn.angle = 1.1f;
    self.menuBtn.sphereDamping = 0.4;
    self.menuBtn.sphereLength = 100;
    self.menuBtn.delegate = self;
    [self.view addSubview:self.menuBtn];
    
}

- (void)setupHaloLayer
{
    self.haloLayer = [[MultiplePulsingHaloLayer alloc] initWithHaloLayerNum:3 andStartInterval:1];
    self.haloLayer.animationRepeatCount = 1;
    self.haloLayer.position = self.menuBtn.center;
    self.haloLayer.haloLayerColor = DMTabBarViewController_TabBarView_TabBarColor.CGColor;
    self.haloLayer.radius = YALTabBarViewDefaultHeight * 1.5;
    self.haloLayer.useTimingFunction = NO;
    [self.haloLayer buildSublayers];
    [self.view.layer insertSublayer:self.haloLayer below:self.menuBtn.layer];
}



#pragma mark - SphereMenuDelegate


- (void)sphereMenuDidCollapse:(SphereMenu *)sphereMenu withSelected:(int)index
{
    self.selectedType = (DMSoloGameType)index;
    switch (self.selectedType)
    {
        case DMSoloGameTimingType:
        {
            DMTimingViewController *timingVC = [[DMTimingViewController alloc] init];
            [self.navigationController pushViewController:timingVC animated:YES];
            break;
        }
        case DMSoloGameMovingType:
        {
            DMMovingViewController *movingVC = [[DMMovingViewController alloc] init];
            [self.navigationController pushViewController:movingVC animated:YES];
            break;
        }
        case DMSoloGameInfiniteType:
        {
            DMInfiniteViewController *infiniteVC = [[DMInfiniteViewController alloc] init];
            [self.navigationController pushViewController:infiniteVC animated:YES];
            break;
        }
        default:
            break;
    }

}

- (void)sphereMenuDidExpand:(SphereMenu *)sphereMenu
{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
