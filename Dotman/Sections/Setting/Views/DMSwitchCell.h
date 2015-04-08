//
//  DMSwitchCell.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/6.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMSettingBaseCell.h"

@protocol DMSwitchCellDelegate;

@interface DMSwitchCell : DMSettingBaseCell

@property (nonatomic, assign) BOOL switcherOn;

@property (nonatomic, weak) id<DMSwitchCellDelegate> delegate;

@end


@protocol DMSwitchCellDelegate <NSObject>

- (void)switherCell:(DMSwitchCell *)cell switchValueChange:(BOOL)isOn;

@end