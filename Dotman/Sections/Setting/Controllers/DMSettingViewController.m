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


#define DMSettingViewController_Cell_DropDownViewEnable_Key @"DropDownViewEnable"
#define DMSettingViewController_Cell_HasDropDownView_Key    @"HasDropDownView"



@interface DMSettingViewController () <UITableViewDelegate, UITableViewDataSource, DMPlayNameCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

/**
 *  对于cell下弹视图，每一个cell都用一个字典进行标记 
 *  @{@"DropDownViewEnable" : @(YES), @"HasDropDownView" : @(YES)}
 *  这个数组用于保存这些字典数据
 */
@property (nonatomic, strong) NSMutableArray *cellMarkArray;

@end


@implementation DMSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = DMTabBarViewController_TabBarView_BackgroundColor;
    
    
    [self setupNavigationItemTitle];
    [self setupTableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self animateVisibleCells];
}

#pragma mark -
// 加载设置页面的数据
- (void)setupSettingData
{
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
/*
    NSIndexPath *path = nil;

    if ([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"MainCell"]) {
        path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
    }else{
        path = indexPath;
    }
    
    if ([[self.dataArray[indexPath.row] objectForKey:@"isAttached"] boolValue]) {
        // 关闭附加cell
        NSDictionary * dic = @{@"Cell": @"MainCell",@"isAttached":@(NO)};
        self.dataArray[(path.row-1)] = dic;
        [self.dataArray removeObjectAtIndex:path.row];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    }else{
        // 打开附加cell
        NSDictionary * dic = @{@"Cell": @"MainCell",@"isAttached":@(YES)};
        self.dataArray[(path.row-1)] = dic;
        NSDictionary * addDic = @{@"Cell": @"AttachedCell",@"isAttached":@(YES)};
        [self.dataArray insertObject:addDic atIndex:path.row];
        
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    }
*/
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    DMPlayNameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[DMPlayNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //TODO: cell 重用问题啊！！
//    if (indexPath.row % 2 == 0)
//    {
//        cell.switcherOn = NO;
//        cell.promptString = @"PlayerNasdfadfame";
//    }
//    else
//    {
//        cell.switcherOn = YES;
//        cell.promptString = @"Player";
//    }

    cell.promptString = @"Player Name : ";
    cell.playerNameString = @"Objcer";
    [cell setCellIndicatorShow:NO];
    

    return cell;
    
    /*
    if ([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"MainCell"])
    {
        
        static NSString *CellIdentifier = @"MainCell";
        
        MainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if (cell == nil) {
            cell = [[MainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        cell.Headerphoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",indexPath.row%4+1]];
        
        return cell;
        
    }else if([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"AttachedCell"]){
        
        static NSString *CellIdentifier = @"AttachedCell";
        
        AttachedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if (cell == nil) {
            cell = [[AttachedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
        
    }*/
}

#pragma mark - DMPlayNameCellDelegate
- (void)didPressedPlayNameCellEditBtn:(DMPlayNameCell *)cell
{
//    NSIndexPath *path = nil;
//    
//    if ([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"MainCell"]) {
//        path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
//    }else{
//        path = indexPath;
//    }
//    
//    if ([[self.dataArray[indexPath.row] objectForKey:@"isAttached"] boolValue]) {
//        // 关闭附加cell
//        NSDictionary * dic = @{@"Cell": @"MainCell",@"isAttached":@(NO)};
//        self.dataArray[(path.row-1)] = dic;
//        [self.dataArray removeObjectAtIndex:path.row];
//        
//        [self.tableView beginUpdates];
//        [self.tableView deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationTop];
//        [self.tableView endUpdates];
//        
//    }else{
//        // 打开附加cell
//        NSDictionary * dic = @{@"Cell": @"MainCell",@"isAttached":@(YES)};
//        self.dataArray[(path.row-1)] = dic;
//        NSDictionary * addDic = @{@"Cell": @"AttachedCell",@"isAttached":@(YES)};
//        [self.dataArray insertObject:addDic atIndex:path.row];
//        
//        
//        [self.tableView beginUpdates];
//        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
//        [self.tableView endUpdates];
//        
//    }
}


@end
