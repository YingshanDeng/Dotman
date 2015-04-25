//
//  DMConstants.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/5.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#ifndef Dotman_DMConstants_h
#define Dotman_DMConstants_h

/**
 *  TabBar 背景颜色
 */
#define DMTabBarViewController_TabBarView_BackgroundColor [UIColor colorWithRed:94.0/255.0 green:91.0/255.0 blue:149.0/255.0 alpha:1]

/**
 *  TabBar 颜色
 */
#define DMTabBarViewController_TabBarView_TabBarColor [UIColor colorWithRed:72.0/255.0 green:211.0/255.0 blue:178.0/255.0 alpha:1]

/**
 *  默认情况下 tab bar 选中 index
 */
#define DMTabBarViewController_Default_Selected_Index 0


/**
 *  字体相关
 */
#define DMFont_Title_Type   @"Code Pro LC"
#define DMFont_Detail_Type  @"Proxima Nova"


/**
 *  设置页面
 */
// 设置页面cell高度
#define DM_Setting_ViewController_Cell_Height 80.0f

// 设置页面cell中内容的左右距离边距
#define DM_Setting_ViewController_Cell_Margin 20.0f


/**
 *  Dot 相关
 */
// 显示状态的dot直径
#define DMShowingDotRadius          25.0f
// 选中状态覆盖层dot直径
#define DMSelectingDotRadius        50.0f

// 游戏中 X Y 方向的dot数量
#define DMGameView_Number_Of_Dots_X 6
#define DMGameView_Number_Of_Dots_Y 6



//TODO: 颜色 tmp
#define TOTAL_DOT_COLOR_TYPE 6
#define ShowingBlue    RGBA(0.549,0.7412,0.9921,1)
#define ShowingOrange  RGBA(1,0.6745,0,1)
#define ShowingRed     RGBA(0.9137,0.3686,0.298,1)
#define ShowingPurple  RGBA(0.6,0.3765,0.7019,1)
#define ShowingGreen   RGBA(0.5529,0.9098,0.5803,1)
#define ShowingYellow  RGBA(0.902,0.851,0.2391,1)


/**
 *  单人游戏模式相关
 */
// 定时60秒
#define DM_Solo_Timing_Game_Duration   10.0f

// 移动30次
#define DM_Solo_Moving_Game_Number     5



/**
 *  下拉按键的类型
 */
typedef NS_ENUM(NSInteger, DMSoloGameDropDownButtonType)
{
    DMSoloGameDropDownButtonResumeType = 0,
    DMSoloGameDropDownButtonRestartType,
    DMSoloGameDropDownButtonExitType
};

#endif
