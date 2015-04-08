//
//  DMSwitchCell.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/6.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMSwitchCell.h"
#import "SevenSwitch.h"

@interface DMSwitchCell ()

/**
 *  选择开关
 */
@property (nonatomic, strong) SevenSwitch *switcher;

@end

@implementation DMSwitchCell

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupSwitcherView];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupSwitcherView];
    }
    return self;
}

#pragma mark - Setter

- (void)setSwitcherOn:(BOOL)switcherOn
{
    _switcherOn = switcherOn;
    self.switcher.on = _switcherOn;
}

#pragma mark - 
- (void)setupSwitcherView
{
    CGSize switcherSize = CGSizeMake(90, 45);
    CGFloat x = ScreenRect.size.width - DM_Setting_ViewController_Cell_Margin - switcherSize.width;
    CGFloat y = (DM_Setting_ViewController_Cell_Height - switcherSize.height) / 2;
    CGRect switcherRect = CGRectMake(x, y, switcherSize.width, switcherSize.height);
    self.switcher = [[SevenSwitch alloc] initWithFrame:switcherRect];
    [self.switcher addTarget:self action:@selector(switcherValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.switcher.offImage = [UIImage imageNamed:@"cross.png"];
    self.switcher.onImage = [UIImage imageNamed:@"check.png"];
    self.switcher.onTintColor = [UIColor colorWithHue:0.08f saturation:0.74f brightness:1.00f alpha:1.00f];
    // Sets the background color when the switch is off, white
    self.switcher.inactiveColor = DMTabBarViewController_TabBarView_TabBarColor;
    self.switcher.isRounded = NO;
    [self addSubview:self.switcher];
}

- (void)switcherValueChanged:(SevenSwitch *)switcher
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(switherCell:switchValueChange:)])
    {
        [self.delegate switherCell:self switchValueChange:switcher.on];
    }
}


@end
