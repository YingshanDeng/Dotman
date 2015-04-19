//
//  DMGameOverView.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/19.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMGameOverView.h"
#import "DMCoverView.h"
#import "SCLAlertViewStyleKit.h"
#import "UIImage+Additions.h"

typedef NS_ENUM(NSInteger, DMGameOverViewButtonType)
{
    DMGameOverViewButtonAgainType, // 再来一局
    DMGameOverViewButtonExitType // 退出
};

@interface DMGameOverView ()

@property (nonatomic, strong) DMCoverView *coverView;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation DMGameOverView
{
    UIView *_blurView;
}


- (id)initWithFrame:(CGRect)frame withBlurView:(UIView *)blurView withScore:(NSInteger)score
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _blurView = blurView;
        [self setupCoverViewWithFrame:frame];
        [self setupContentViewWithScore:score];
    }
    return self;
}

- (void)showGameOverViewWithBlock:(void (^)(void))block
{
    self.hidden = NO;
    
    self.coverView.hidden = NO;
    __weak __typeof(&*self)weakSelf = self;
    [self.coverView fadeInToShowWithBlock:^{
        
        weakSelf.contentView.alpha = 0.0;
        CGRect originFrame = weakSelf.contentView.frame;
        CGRect preFrame = originFrame;
        preFrame.origin.y -= 120;
        weakSelf.contentView.frame = preFrame;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.contentView.alpha = 1.0f;
            weakSelf.contentView.frame = originFrame;
            if (block) {
                block();
            }
        }];

    }];
}

- (void)hideGameOverViewWithBlock:(void (^)(void))block
{
    __weak __typeof(&*self)weakSelf = self;
    
    CGRect originFrame = weakSelf.contentView.frame;
    CGRect animFrame = originFrame;
    animFrame.origin.y += 120;
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.alpha = 0.0f;
        [weakSelf.contentView setFrame:animFrame];
        
    } completion:^(BOOL finished) {
        
        [weakSelf.contentView setFrame:originFrame];
        [self.coverView fadeOutToHideWithBlock:^{
            
            self.hidden = YES;
            if (block) {
                block();
            }
        }];
        
    }];
}

#pragma mark -
- (void)setupCoverViewWithFrame:(CGRect)frame
{
    self.coverView = [[DMCoverView alloc] initCoverViewWithFrame:frame withType:DMCoverViewBlurType withBlurView:_blurView];
    [self addSubview:self.coverView];
}

- (void)setupContentViewWithScore:(NSInteger)score
{
    self.contentView = [[UIView alloc] init];
    [self.contentView setBounds:(CGRect){0, 0, 240, 250}];
    [self.contentView setCenter:self.center];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.contentView];
    self.contentView.alpha = 0.0f;
    
    UIView *mainView = [[UIView alloc] init];
    [mainView setFrame:(CGRect){0, 35, 240, 210}];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    [mainView.layer setMasksToBounds:YES];
    [mainView.layer setCornerRadius:5.0f];
    [self.contentView addSubview:mainView];
    
    
    UIView *roundBg_1 = [[UIImageView alloc] init];
    roundBg_1.bounds = CGRectMake(0, 0, 70, 70);
    roundBg_1.center = CGPointMake(self.contentView.bounds.size.width / 2, roundBg_1.bounds.size.height / 2);
    roundBg_1.backgroundColor = [UIColor whiteColor];
    roundBg_1.layer.masksToBounds = YES;
    roundBg_1.layer.cornerRadius = roundBg_1.bounds.size.height / 2;
    [self.contentView addSubview:roundBg_1];
    
    UIView *roundBg_2 = [[UIImageView alloc] init];
    roundBg_2.bounds = CGRectMake(0, 0, 65, 65);
    roundBg_2.center = CGPointMake(self.contentView.bounds.size.width / 2, roundBg_1.bounds.size.height / 2);
    roundBg_2.backgroundColor = DMTabBarViewController_TabBarView_TabBarColor;
    roundBg_2.layer.masksToBounds = YES;
    roundBg_2.layer.cornerRadius = roundBg_2.bounds.size.height / 2;
    [self.contentView addSubview:roundBg_2];
    
    
    
    UIImage *checkMarkImg = [SCLAlertViewStyleKit imageOfCheckmark];
    UIImageView *checkMarkImgView = [[UIImageView alloc] initWithFrame:roundBg_2.frame];
    [checkMarkImgView setImage:checkMarkImg];
    checkMarkImgView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [self.contentView addSubview:checkMarkImgView];
    
    NSString *tipString = @"Game Over!";
    CGRect tipFrarm = CGRectMake(0, CGRectGetMaxY(checkMarkImgView.frame) + 10, CGRectGetWidth(self.contentView.frame), 50);
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:tipFrarm];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.font = [UIFont fontWithName:DMFont_Detail_Type size:30.0f];
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.text = tipString;
    [self.contentView addSubview:tipLabel];


    NSString *scoreString = [NSString stringWithFormat:@"Your Score:%@",@(score)];
    CGRect scoreFrame = CGRectMake(0, CGRectGetMaxY(tipLabel.frame) - 5, CGRectGetWidth(self.contentView.frame), 30);
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:scoreFrame];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.adjustsFontSizeToFitWidth = YES;
    scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20.0f];
    scoreLabel.textColor = [UIColor blackColor];
    scoreLabel.text = scoreString;
    [self.contentView addSubview:scoreLabel];
    
    
    CGFloat interval = 8.0;
    UIButton *againBtn = [self generateGameOverViewBtnWithTitle:@"Play Again" withType:DMGameOverViewButtonAgainType];
    
    CGRect againBtnFrame = CGRectMake(interval, CGRectGetMaxY(scoreLabel.frame) + interval, CGRectGetWidth(self.contentView.frame) - interval * 2, 40);
    [againBtn setFrame:againBtnFrame];
    [self.contentView addSubview:againBtn];
    
  
    UIButton *exitBtn = [self generateGameOverViewBtnWithTitle:@"Exit" withType:DMGameOverViewButtonExitType];
    
    CGRect exitBtnFrame = CGRectMake(interval, CGRectGetMaxY(againBtn.frame) + interval, CGRectGetWidth(self.contentView.frame) - interval * 2, 40);
    [exitBtn setFrame:exitBtnFrame];
    [self.contentView addSubview:exitBtn];
    

}

- (UIButton *)generateGameOverViewBtnWithTitle:(NSString *)title withType:(DMGameOverViewButtonType)type
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIColor *btnNormalColor = DMTabBarViewController_TabBarView_TabBarColor;
    UIColor *btnHighlightedColor = [UIColor colorWithRed:0.297 green:0.878 blue:0.744 alpha:1.000];
    
    [btn setBackgroundImage:[UIImage imageWithColor:btnNormalColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:btnHighlightedColor] forState:UIControlStateHighlighted];
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5.0f;
    
    [btn setTag:type];
    
    UIFont *btnFont = [UIFont fontWithName:DMFont_Detail_Type size:18.0];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title
                                                                     attributes:@{NSFontAttributeName : btnFont,
                                                                                  NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [btn setAttributedTitle:attrString forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gameOverViewBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


- (void)gameOverViewBtnAciton:(UIButton *)btn
{
    DMGameOverViewButtonType type = (DMGameOverViewButtonType)btn.tag;
    switch (type) {
        case DMGameOverViewButtonAgainType:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didGameOverViewSelectPlayAgain:)])
            {
                [self.delegate didGameOverViewSelectPlayAgain:self];
            }
            break;
        }
            
        case DMGameOverViewButtonExitType:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didGameOverViewSelectExit:)])
            {
                [self.delegate didGameOverViewSelectExit:self];
            }
            break;
        }
        default:
            break;
    }
}


@end
