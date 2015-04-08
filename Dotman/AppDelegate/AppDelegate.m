//
//  AppDelegate.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/5.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "AppDelegate.h"
#import "YALTabBarItem.h"

#import "DMIntroViewController.h"
#import "DMSettingViewController.h"

#import "YALSecondTestViewController.h"
#import "YALThirdTestViewController.h"
#import "YALFourthTestViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.tabBarViewController = [[YALFoldingTabBarController alloc] init];
    
    DMIntroViewController *vc1 = [[DMIntroViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc1];
    [navi setNavigationBarHidden:YES];

    YALSecondTestViewController *vc2 = [[YALSecondTestViewController alloc] init];
    YALThirdTestViewController *vc3 = [[YALThirdTestViewController alloc] init];
    
    DMSettingViewController *vc4 = [[DMSettingViewController alloc] init];
    UINavigationController *navi4 = [[UINavigationController alloc] initWithRootViewController:vc4];

    [self.tabBarViewController setViewControllers:@[navi, vc2, vc3, navi4]];

    [self setupFoldingTabBarController];

    self.window = [[UIWindow alloc] initWithFrame:ScreenRect];
    self.window.rootViewController = self.tabBarViewController;
    [self.window makeKeyAndVisible];
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -
- (void)setupFoldingTabBarController
{
    //prepare leftBarItems
    YALTabBarItem *item1 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"nearby_icon"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];
    
    YALTabBarItem *item2 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"profile_icon"]
                                                      leftItemImage:[UIImage imageNamed:@"edit_icon"]
                                                     rightItemImage:nil];
    
    self.tabBarViewController.leftBarItems = @[item1, item2];
    
    //prepare rightBarItems
    YALTabBarItem *item3 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"chats_icon"]
                                                      leftItemImage:[UIImage imageNamed:@"search_icon"]
                                                     rightItemImage:[UIImage imageNamed:@"new_chat_icon"]];
    
    
    YALTabBarItem *item4 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"settings_icon"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];
    
    self.tabBarViewController.rightBarItems = @[item3, item4];
    
    self.tabBarViewController.centerButtonImage = [UIImage imageNamed:@"plus_icon"];
    
    self.tabBarViewController.selectedIndex = DMTabBarViewController_Default_Selected_Index;
    
    //customize tabBarView
    self.tabBarViewController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;
    self.tabBarViewController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset;
    self.tabBarViewController.tabBarView.backgroundColor = DMTabBarViewController_TabBarView_BackgroundColor;
    self.tabBarViewController.tabBarView.tabBarColor = DMTabBarViewController_TabBarView_TabBarColor;
    self.tabBarViewController.tabBarViewHeight = YALTabBarViewDefaultHeight;
    self.tabBarViewController.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets;
    self.tabBarViewController.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets;
    
    
}


@end
