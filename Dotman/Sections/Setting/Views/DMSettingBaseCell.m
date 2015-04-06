//
//  DMSettingBaseCell.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/6.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMSettingBaseCell.h"

@interface DMSettingBaseCell ()

/**
 *  cell 提示label
 */
@property (nonatomic, strong) UILabel *promptLabel;


//TODO: 可以增加一个 detail label

/**
 *  cell 右侧指标
 */
@property (nonatomic, strong) UIImageView *indicator;

@end

@implementation DMSettingBaseCell

- (id)init
{
    self = [super init];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupPromptLabel];
        [self setupCellIndication];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupPromptLabel];
        [self setupCellIndication];
    }
    return self;
}


#pragma mark - Setter
- (void)setPromptString:(NSString *)promptString
{
    _promptString = promptString;
    if (_promptString)
    {
        NSAttributedString *promptAttriStr = [self customPromptAttributedString:_promptString];
        CGSize labelSize = [self adaptiveSizeWithAttributedString:promptAttriStr];
        [self.promptLabel setFrame:(CGRect){20, (DM_Setting_ViewController_Cell_Height - labelSize.height) / 2, labelSize}];
        [self.promptLabel setAttributedText:promptAttriStr];
    }
}

- (void)setCellIndicatorShow:(BOOL)cellIndicatorShow
{
    _cellIndicatorShow = cellIndicatorShow;
    self.indicator.hidden = !_cellIndicatorShow;
}

#pragma mark -

- (void)setupPromptLabel
{
    self.promptLabel = [[UILabel alloc] init];
    self.promptLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.promptLabel];
}

- (NSAttributedString *)customPromptAttributedString:(NSString *)string
{
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithString:string];
    
    UIColor *color = RGB(157, 215, 246);
    UIFont *font = [UIFont fontWithName:DMFont_Title_Type size:18.0f];
    [mutableAttributeString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [string length])];
    [mutableAttributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [string length])];
    return [mutableAttributeString copy];
}

- (CGSize)adaptiveSizeWithAttributedString:(NSAttributedString *)attributedString
{
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    return rect.size;
}


- (void)setupCellIndication
{
    UIImage *img = [UIImage imageNamed:@"cell-indicator"];
    UIImageView *indicator = [[UIImageView alloc] initWithImage:img];
    CGSize imgSize = img.size;
    
    CGRect indicatorRect = CGRectMake(ScreenRect.size.width - imgSize.width,
                                      (DM_Setting_ViewController_Cell_Height - imgSize.height) / 2,
                                      imgSize.width,
                                      imgSize.height);
    [indicator setFrame:indicatorRect];
    self.indicator = indicator;
    [self addSubview:self.indicator];
}

#pragma mark - 
// 设置点击效果
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (self.cellIndicatorShow)
    {
        self.indicator.hidden = !selected;
    }
    
    if (selected)
    {
        self.backgroundColor = [UIColor colorWithRed:0.424 green:0.412 blue:0.643 alpha:0.900];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithRed:102.f/255.f green:99.f/255.f blue:157.f/255.f alpha:1.0];
    }
}


@end
