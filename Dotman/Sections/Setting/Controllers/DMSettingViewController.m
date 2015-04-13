//
//  DMSettingViewController.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/5.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMSettingViewController.h"
#import "UIImage+Additions.h"
#import "DMSettingHandler.h"
#import "DMSwitchCell.h"
#import "DMPlayNameCell.h"
#import "DMDropDownCell.h"
#import "AppDelegate.h"

// 设置页面标题
NSString * const DM_Setting_ViewController_Title    = @"Setting";
// cell Mark Key 用于标记当前cell显示的内容
NSString * const DMSettingViewControllerCellMarkKey = @"DMSettingViewControllerCellMarkKey";

// 标识cell显示的内容
typedef NS_ENUM(NSInteger, DMSettingViewControllerCellMarkType)
{
    DMSettingViewControllerCellMarkPlayerNameType,
    DMSettingViewControllerCellMarkSoundEffectType,
    DMSettingViewControllerCellMarkVibrateEffectType,
    DMSettingViewControllerCellMarkDotsColorType,
    DMSettingViewControllerCellMarkThemeColorType
};


@interface DMSettingViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, DMPlayNameCellDelegate, DMSwitchCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

/**
 *  设置页面的数据
 */
@property (nonatomic, strong) NSDictionary *settingDic;

/**
 *  Cell 类型标记: 为每一个cell设置一个dic,用于标识cell类型
 */
@property (nonatomic, strong) NSMutableArray *cellMarkArray;

@end


@implementation DMSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = DMTabBarViewController_TabBarView_BackgroundColor;
    
    [self setupNavigationItemTitle];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setupSettingData];
    [self setupTableView];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self animateVisibleCells];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}

#pragma mark -
// 加载设置页面的数据
- (void)setupSettingData
{
    DMSettingHandler *handler = [DMSettingHandler defaultSettingHandle];
    self.settingDic = [handler readSettingDictionaryData]; // 设置数据
    
    NSMutableArray *tmpMtbArr = [NSMutableArray arrayWithCapacity:self.settingDic.count];
    for (NSString *key in self.settingDic.allKeys)
    {
        if ([key isEqualToString:DMSettingHandler_Persistence_PlayerName_Key])
        {
            [tmpMtbArr addObject:@{DMSettingViewControllerCellMarkKey : @(DMSettingViewControllerCellMarkPlayerNameType)}];
        }
        else if ([key isEqualToString:DMSettingHandler_Persistence_SoundEffect_Key])
        {
            [tmpMtbArr addObject:@{DMSettingViewControllerCellMarkKey : @(DMSettingViewControllerCellMarkSoundEffectType)}];
        }
        else if ([key isEqualToString:DMSettingHandler_Persistence_VibrateEffect_Key])
        {
            [tmpMtbArr addObject:@{DMSettingViewControllerCellMarkKey : @(DMSettingViewControllerCellMarkVibrateEffectType)}];
        }
        else if ([key isEqualToString:DMSettingHandler_Persistence_Dots_Color_Key])
        {
            [tmpMtbArr addObject:@{DMSettingViewControllerCellMarkKey : @(DMSettingViewControllerCellMarkDotsColorType)}];
        }
        else if ([key isEqualToString:DMSettingHandler_Persistence_Theme_Color_Key])
        {
            [tmpMtbArr addObject:@{DMSettingViewControllerCellMarkKey : @(DMSettingViewControllerCellMarkDotsColorType)}];
        }
    }
    // sort array
    NSArray *sortedArr = [tmpMtbArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger index1 = [[obj1 objectForKey:DMSettingViewControllerCellMarkKey] integerValue];
        NSInteger index2 = [[obj2 objectForKey:DMSettingViewControllerCellMarkKey] integerValue];
        if (index1 == index2)
        {
            return NSOrderedSame;
        }
        else if (index1 > index2)
        {
            return NSOrderedDescending;
        }
        else
            return NSOrderedAscending;
    }];
    self.cellMarkArray = [sortedArr mutableCopy];
}


- (void)setupNavigationItemTitle
{
    // 设置 navi bar 背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:DMTabBarViewController_TabBarView_BackgroundColor] forBarMetrics:UIBarMetricsDefault];
    // 设置 navi bar title 的样式
    NSDictionary *attributes =@{NSFontAttributeName: [UIFont fontWithName:DMFont_Title_Type size:22.0f],
                                NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    // 设置标题
    self.navigationItem.title = DM_Setting_ViewController_Title;
}

- (void)setupTableView
{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    CGFloat tabBarHeight = delegate.tabBarViewController.tabBar.frame.size.height;
    CGRect rect = (CGRect){self.view.bounds.origin, self.view.bounds.size.width, self.view.bounds.size.height - tabBarHeight + 10};
    //TODO: 高度 + 10 ？？
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}


- (void)prepareVisibleCellsForAnimation
{
    for (int index = 0; index < [self.tableView.visibleCells count]; index ++)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.frame = CGRectMake(-CGRectGetWidth(cell.bounds), cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
        cell.alpha = 0.0f;
    }
}

- (void)animateVisibleCells
{
    [self prepareVisibleCellsForAnimation];
    for (int index = 0; index < [self.tableView.visibleCells count]; index ++)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [UIView animateWithDuration:0.25f
                              delay:index * 0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.frame = CGRectMake(0.f, cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
                             cell.alpha = 1.f;
                         }
                         completion:nil];

    }
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DM_Setting_ViewController_Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellMarkArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMSettingViewControllerCellMarkType curCellMarkType = [[[self.cellMarkArray objectAtIndex:indexPath.row] objectForKey:DMSettingViewControllerCellMarkKey] integerValue] ;
    if (curCellMarkType == DMSettingViewControllerCellMarkPlayerNameType)
    {
        DMPlayNameCell *cell = [[DMPlayNameCell alloc] init];
        cell.delegate = self;
        [cell setTag:DMSettingViewControllerCellMarkPlayerNameType];
        [cell setCellIndicatorShow:NO];
        cell.promptString = @"Player Name:";
        cell.playerNameString = [self.settingDic objectForKey:DMSettingHandler_Persistence_PlayerName_Key];
        return cell;
    }
    else if (curCellMarkType == DMSettingViewControllerCellMarkSoundEffectType)
    {
        DMSwitchCell *cell = [[DMSwitchCell alloc] init];
        cell.delegate = self;
        [cell setTag:DMSettingViewControllerCellMarkSoundEffectType];
        [cell setCellIndicatorShow:NO];
        cell.promptString = @"Sound Effect :";
        cell.switcherOn = [[self.settingDic objectForKey:DMSettingHandler_Persistence_SoundEffect_Key] boolValue];
        return cell;
    }
    else if (curCellMarkType == DMSettingViewControllerCellMarkVibrateEffectType)
    {
        DMSwitchCell *cell = [[DMSwitchCell alloc] init];
        cell.delegate = self;
        [cell setTag:DMSettingViewControllerCellMarkVibrateEffectType];
        [cell setCellIndicatorShow:NO];
        cell.promptString = @"Vibrate Effect :";
        cell.switcherOn = [[self.settingDic objectForKey:DMSettingHandler_Persistence_VibrateEffect_Key] boolValue];
        return cell;
    }

    return nil;

}

#pragma mark - DMPlayNameCellDelegate
- (void)didPressedPlayNameCellEditBtn:(DMPlayNameCell *)cell
{
    if (cell == nil)
    {
        return;
    }
    //TODO: 直接弹出一个 alert view 算了，哎！
    
    UIAlertView *inputAlertView = [[UIAlertView alloc] initWithTitle:@"Modify Player Name" message:@"Please input your custom player name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    [inputAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [inputAlertView show];
    
    //TODO: 暂时未实现
    /*
    NSIndexPath *curCellPath = [self.tableView indexPathForCell:cell];
    NSIndexPath *dropCellPath = [NSIndexPath indexPathForRow:(curCellPath.row + 1) inSection:curCellPath.section];
    [self.cellMarkArray addObject:@{DMSettingViewController_Cell_DropDownViewEnable_Key : @(NO),
                                    DMSettingViewController_Cell_HasDropDownView_Key : @(NO)}];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[dropCellPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    */
}
#pragma mark - DMSwitchCellDelegate
- (void)switherCell:(DMSwitchCell *)cell switchValueChange:(BOOL)isOn
{
    NSInteger tag = cell.tag;
    if (tag == DMSettingViewControllerCellMarkSoundEffectType)
    {
        [[DMSettingHandler defaultSettingHandle] persistObject:@(isOn) forKey:DMSettingHandler_Persistence_SoundEffect_Key];
    }
    else if (tag == DMSettingViewControllerCellMarkVibrateEffectType)
    {
        [[DMSettingHandler defaultSettingHandle] persistObject:@(isOn) forKey:DMSettingHandler_Persistence_VibrateEffect_Key];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Done"])
    {
        NSString *nameStr = [[alertView textFieldAtIndex:0] text];
        if (nameStr && ![nameStr isEqualToString:@""])
        {
            [[DMSettingHandler defaultSettingHandle] persistObject:nameStr forKey:DMSettingHandler_Persistence_PlayerName_Key];
            
            DMPlayNameCell *cell = (DMPlayNameCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.playerNameString = nameStr;
        }
    }
}

@end
