//
//  DMPlayNameCell.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/6.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMPlayNameCell.h"

@interface DMPlayNameCell ()

/**
 *  Playername Label
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 *  修改名称按键
 */
@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation DMPlayNameCell


- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupEditBtn];
        [self setupNameLabel];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupEditBtn];
        [self setupNameLabel];
    }
    return self;
}


#pragma mark - Setter
- (void)setPlayerNameString:(NSString *)playerNameString
{
    _playerNameString = playerNameString;
    if (_playerNameString)
    {
        NSAttributedString *promptAttriStr = [self customNameAttributedString:_playerNameString];
        CGSize labelSize = [self adaptiveSizeWithAttributedString:promptAttriStr];
        [self.nameLabel setFrame:(CGRect){
            self.editBtn.frame.origin.x - DM_Setting_ViewController_Cell_Margin - labelSize.width,
            (DM_Setting_ViewController_Cell_Height - labelSize.height) / 2,
            labelSize}];
        [self.nameLabel setAttributedText:promptAttriStr];
    }
}

#pragma mark -

- (void)setupNameLabel
{
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;//TODO: ? left ?
    [self addSubview:self.nameLabel];
}

- (void)setupEditBtn
{
    CGSize btnSize = CGSizeMake(35, 35);
    CGFloat x = ScreenRect.size.width - DM_Setting_ViewController_Cell_Margin - btnSize.width;
    CGFloat y = (DM_Setting_ViewController_Cell_Height - btnSize.height) / 2;
    self.editBtn = [[UIButton alloc] initWithFrame:(CGRect){x, y, btnSize}];
    [self.editBtn.layer setMasksToBounds:YES];
    [self.editBtn.layer setCornerRadius:btnSize.width / 2];
    [self.editBtn setBackgroundColor:[UIColor colorWithRed:0.467 green:0.587 blue:0.949 alpha:1.000]];
    [self.editBtn setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(editBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.editBtn];
}

- (NSAttributedString *)customNameAttributedString:(NSString *)string
{
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithString:string];
    
    UIColor *color = RGB(226, 227, 248);
    UIFont *font = [UIFont fontWithName:DMFont_Detail_Type size:18.0f];
    [mutableAttributeString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [string length])];
    [mutableAttributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [string length])];
    return [mutableAttributeString copy];
}

- (CGSize)adaptiveSizeWithAttributedString:(NSAttributedString *)attributedString
{
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    return rect.size;
}


- (void)editBtnPressed:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressedPlayNameCellEditBtn:)])
    {
        [self.delegate didPressedPlayNameCellEditBtn:self];
    }
}

@end
