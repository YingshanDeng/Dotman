//
//  DMPlayNameCell.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/6.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMSettingBaseCell.h"

@protocol DMPlayNameCellDelegate;

@interface DMPlayNameCell : DMSettingBaseCell

/**
 *  Playername String
 */
@property (nonatomic, strong) NSString *playerNameString;


@property (nonatomic, weak) id<DMPlayNameCellDelegate> delegate;

@end

@protocol DMPlayNameCellDelegate <NSObject>

- (void)didPressedPlayNameCellEditBtn:(DMPlayNameCell *)cell ;

@end
