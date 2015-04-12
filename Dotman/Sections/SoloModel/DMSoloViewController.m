//
//  DMSoloViewController.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/9.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMSoloViewController.h"
#import "UIImage+Additions.h"
#import "DWBubbleMenuButton.h"

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


@interface DMSoloViewController () <DWBubbleMenuViewDelegate>

/**
 *  大标题提示
 */
@property (nonatomic, strong) UILabel *tipLabel;


@property (nonatomic, strong) DWBubbleMenuButton *menuBtn;

@property (nonatomic, strong) NSArray *subBtnTipLabelArray;

/**
 *  选择的单机游戏模式
 */
@property (nonatomic, assign) DMSoloGameType selectedType;

@end

@implementation DMSoloViewController
{
    DWBubbleMenuButton *menutButton;
}

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
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 如果 menu btn 打开，则将其关闭
    if (!self.menuBtn.isCollapsed)
    {
        [self.menuBtn dismissButtons];
    }
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect tipLabelFrame = self.tipLabel.frame;
    tipLabelFrame.origin.y = self.view.bounds.size.height * 0.05f;
    tipLabelFrame.size.height = self.view.bounds.size.height * 0.1f;
    [self.tipLabel setFrame:tipLabelFrame];

    CGRect menuBtnFrame = self.menuBtn.frame;
    menuBtnFrame.origin.x = self.view.bounds.size.width * 0.1f;
    menuBtnFrame.origin.y = tipLabelFrame.origin.y + tipLabelFrame.size.height + self.view.bounds.size.height * 0.02f;
    [self.menuBtn setFrame:menuBtnFrame];
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
    CGRect rect = CGRectMake(0, 0, 60, 60);
    self.menuBtn = [[DWBubbleMenuButton alloc] initWithFrame:rect expansionDirection:DirectionDown];
    self.menuBtn.homeButtonView = [self createMenuButtonViewWithSize:rect.size];
    self.menuBtn.delegate = self;
    CGSize btnSize = CGSizeMake(rect.size.width  * 0.85, rect.size.height * 0.85);
    UIButton *timingBtn = [self generateBtnWithSize:btnSize withType:DMSoloGameTimingType];
    UIButton *movingBtn = [self generateBtnWithSize:btnSize withType:DMSoloGameMovingType];
    UIButton *infiniteBtn = [self generateBtnWithSize:btnSize withType:DMSoloGameInfiniteType];
    [self.menuBtn addButtons:@[timingBtn, movingBtn, infiniteBtn]];
    [self.view addSubview:self.menuBtn];
}


- (void)setupMenuSubBtnTipLabel
{
    NSArray *btnArray = self.menuBtn.buttons;
    NSArray *tipLabelStringArray = @[DMSoloGameTimingButtonTitle, DMSoloGameMovingButtonTitle, DMSoloGameInfiniteButtonTitle];
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:3];
    NSInteger index = 0;
    for (UIButton *btn in btnArray)
    {
        CGRect btnFrame = btn.frame;
        CGFloat x = CGRectGetMaxX(self.menuBtn.frame) + DMSoloViewController_SubViews_Margins - 10;
        CGFloat y = CGRectGetMaxY(self.menuBtn.frame) + (index + 1) * self.menuBtn.buttonSpacing + index * btnFrame.size.height;
        CGFloat width = ScreenRect.size.width - x - DMSoloViewController_SubViews_Margins;
        CGFloat height = btnFrame.size.height;
        CGRect btnTipFrame = CGRectMake(x, y, width, height);
        
        UILabel *btnTipLabel = [self createMenuSubBtnTipLabelWithFrame:btnTipFrame withText:tipLabelStringArray[index]];
        [self.view addSubview:btnTipLabel];
        
        index ++;
        [tmpArray addObject:btnTipLabel];
    }
    self.subBtnTipLabelArray = [tmpArray copy];
}

// 生成 menu 的 sub btn
- (UIButton *)generateBtnWithSize:(CGSize)size withType:(DMSoloGameType)type
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBounds:(CGRect){0, 0, size.width, size.height}];
    [btn setBackgroundImage:[UIImage imageWithColor:DMTabBarViewController_TabBarView_TabBarColor] forState:UIControlStateNormal];
    [btn setTag:type];
    
    NSString *title = [NSString stringWithFormat:@"%@", @(type)];
    NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithString:title];
    [titleAttributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:25] range:NSMakeRange(0, 1)];
    [titleAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 1)];
    [btn setAttributedTitle:titleAttributeString forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(modeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:btn.frame.size.height / 2];
    return btn;
}



- (UILabel *)createMenuButtonViewWithSize:(CGSize)size
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, size.width, size.height)];
    label.backgroundColor = DMTabBarViewController_TabBarView_TabBarColor;
    label.text = @"Tap";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.clipsToBounds = YES;
    return label;
}


- (void)modeBtnPressed:(UIButton *)btn
{
    self.selectedType = (DMSoloGameType)btn.tag;
}


#pragma mark - DWBubbleMenuViewDelegate
- (void)bubbleMenuButtonWillExpand:(DWBubbleMenuButton *)expandableView
{
    // 创建 sub btn labels
    if (self.subBtnTipLabelArray == nil)
    {
        [self setupMenuSubBtnTipLabel];
    }

    NSInteger index = 0;
    for (UILabel *label in self.subBtnTipLabelArray)
    {
        // label 显示动画
        [self showMenuSubBtnLabelAnimation:label withDelay:(index + 1) * 0.2];
        index ++;
    }
    
}


- (void)bubbleMenuButtonDidExpand:(DWBubbleMenuButton *)expandableView
{

}

- (void)bubbleMenuButtonWillCollapse:(DWBubbleMenuButton *)expandableView
{
    NSInteger index = 0;
    for (UILabel *label in self.subBtnTipLabelArray)
    {
        // label 隐藏动画
        [self hideMenuSubBtnLabelAnimation:label withDelay:fabsf(index - 2) * 0.2];
        index ++;
    }
}

- (void)bubbleMenuButtonDidCollapse:(DWBubbleMenuButton *)expandableView
{
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


#pragma mark -
// 生成 menu button 的 sub button 的 tip Label
- (UILabel *)createMenuSubBtnTipLabelWithFrame:(CGRect)frame withText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25.0]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:text];
    label.alpha = 0.0f;
    return label;
}

- (void)showMenuSubBtnLabelAnimation:(UILabel *)label withDelay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:0.2 delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        label.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideMenuSubBtnLabelAnimation:(UILabel *)label withDelay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:0.2 delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        label.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
