//
//  DMSettingBaseCell.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/6.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMSettingBaseCell : UITableViewCell

/**
 *  提示 string
 */
@property (nonatomic, strong) NSString *promptString;


/**
 *  设置 cell indicator 是否显示
 */
@property (nonatomic, assign) BOOL cellIndicatorShow;

@end
