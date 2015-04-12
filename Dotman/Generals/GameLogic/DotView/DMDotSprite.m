//
//  DMDotSprite.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/8.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMDotSprite.h"

@implementation DMDotSprite

{
    /**
     *  dot 编号
     */
    int _dotIndex;
    
    /**
     *  super view frame
     */
    CGRect _superViewFrame;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 随机产生dot颜色
        [self randomDotColor];
        
        self.showingDot = [[DMRoundNode alloc] initWithFrame:CGRectMake(0, 0, DMShowingDotRadius, DMShowingDotRadius)];
        self.showingDot.nodeColor = self.dotColor;
        self.showingDot.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        
        self.selectingDot = [[DMRoundNode alloc] initWithFrame:CGRectMake(0, 0, DMSelectingDotRadius, DMSelectingDotRadius)];
        self.selectingDot.nodeColor = self.dotColor;
        self.selectingDot.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        
        [self addSubview:self.selectingDot];
        [self addSubview:self.showingDot];
        self.selectingDot.hidden = YES;
        
    }
    return self;
}


- (void)generateDotWithCoordinate:(CGPoint)coordinate withSuperViewFrame:(CGRect)superViewFrame
{
    self.coordinate = coordinate;
    _superViewFrame = superViewFrame;
    
    [self settingDotPosition];
    
    self.center = self.originPosition;
    self.hidden = YES;
    self.animating = NO;
    self.disappear = NO;
}

- (CGRect)getDetetionAreaRect
{
    // dot 接收触摸的区域
    CGSize detetionAreaSize = CGSizeMake(50, 50);
    CGFloat x = self.frame.origin.x + (self.frame.size.width - detetionAreaSize.width) / 2;
    CGFloat y = self.frame.origin.y + (self.frame.size.height - detetionAreaSize.height) / 2;
    return (CGRect){x, y, detetionAreaSize};
}

- (void)setCoordinate:(CGPoint)coordinate
{
    _coordinate = coordinate;
    _dotIndex = self.coordinate.y * DMGameView_Number_Of_Dots_X + self.coordinate.x;
}

#pragma mark - Dot Animation
- (void)runStartDropDownAnimationWithBlock:(void (^)(int))block
{
    self.hidden = NO;
    self.center = self.originPosition;
    
    CGFloat delta = 50 - self.coordinate.y * 6;
    CGPoint jumpUpPoint = CGPointMake(self.showingPosition.x, self.showingPosition.y - delta);
    
    CGFloat duration = 0.2;
    CGFloat delay = self.coordinate.y * 0.05;
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.center = self.showingPosition;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.05 animations:^{
            
            self.center = jumpUpPoint;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.05 animations:^{
                
                self.center = self.showingPosition;
                
            } completion:^(BOOL finished) {
                
                // 回调传递 当前dot的index，判断当是最后一个dot时，就可以开始游戏了
                block(_dotIndex);
            }];
            
        }];
        
    }];
}


- (void)runDisappearDotAnimationWithBlock:(void (^)(void))block
{
    // disappear 属性为YES
    self.disappear = YES;
    
    [UIView animateWithDuration:0.15 animations:^{
        if (self.animating == YES)
        {
            self.showingDot.transform = CGAffineTransformMakeScale(1.18, 1.18);
        }
        else
        {
            self.showingDot.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.showingDot.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            
        } completion:^(BOOL finished) {
            
            self.hidden = YES;
            self.showingDot.transform = CGAffineTransformIdentity;
            
            block();
        }];
    }];
}


- (void)runSelectingAnimation
{
    // init
    self.selectingDot.hidden = NO;
    self.selectingDot.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.selectingDot.alpha = 1.0;
    
    if (self.animating == NO)
    {
        self.animating = YES;
        [UIView animateWithDuration:0.7 animations:^{
            
            self.selectingDot.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
            [UIView animateWithDuration:0.7 animations:^{
                self.selectingDot.alpha = 0.0f;
            }];
            
        } completion:^(BOOL finished) {
            
            self.selectingDot.alpha = 1.0f;
            self.selectingDot.transform = CGAffineTransformIdentity;
            self.selectingDot.hidden = YES;
            self.animating = NO;
        }];
    }
}

- (void)runDropDownAnimation
{
    CGPoint prePoint = self.showingPosition;
    [self settingDotPosition];
    CGPoint curPoint = self.showingPosition;
    int delta = (int)(fabsf(prePoint.y - curPoint.y) / 57);
    
    CGFloat duration = 0.08 * delta;
    [UIView animateWithDuration:duration animations:^{
        
        self.center = self.showingPosition;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.05 animations:^{
            
            self.center = CGPointMake(self.showingPosition.x, self.showingPosition.y - 18);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.05 animations:^{
                
                self.center = self.showingPosition;
            }];
        }];
        
    }];
}

- (void)reGenerateDotWithBlock:(void (^)(void))block
{
    // dot 属性重置
    self.hidden = YES;
    [self randomDotColor]; // 随机颜色
    self.selectingDot.nodeColor = self.dotColor;
    self.showingDot.nodeColor = self.dotColor;
    
    [self settingDotPosition]; // 重新计算位置
    self.center = self.originPosition;
    self.animating = NO;
    self.disappear = NO;
    
    self.showingDot.transform = CGAffineTransformIdentity;
    self.showingDot.alpha = 1.0f;
    self.selectingDot.transform = CGAffineTransformIdentity;
    self.selectingDot.alpha = 1.0f;
    self.selectingDot.hidden = YES;
    
    // 重置后，执行掉落动画
    [self runDropDownAnimationAfterRegenerateWithBlock:block];
}


-(void)runDropDownAnimationAfterRegenerateWithBlock:(void (^)(void))block
{
    self.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.center = self.showingPosition;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.05 animations:^{
            
            self.center = CGPointMake(self.showingPosition.x, self.showingPosition.y - 25);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.05 animations:^{
                
                self.center = self.showingPosition;
                
            } completion:^(BOOL finished) {
                block();
            }];
            
        }];
        
    }];
}


#pragma mark - Private Method

/**
 *  随机生成dot颜色
 */
- (void)randomDotColor
{
    //    int index = arc4random() % TOTAL_DOT_COLOR_TYPE;
    int index = arc4random() % 5;
    
    
    NSArray *colorArray_1 = @[
                              RGB(105, 3, 136),
                              RGB(126, 206, 51),
                              RGB(221, 75, 26),
                              RGB(94, 165, 163),
                              RGB(241, 198, 47)
                              ];
    NSArray *colorArray_2 = @[
                              RGB(238, 185, 219),
                              RGB(58, 102, 148),
                              RGB(222, 84, 18),
                              RGB(43, 75, 68),
                              RGB(240, 237, 61)
                              ];
    NSArray *colorArray_3 = @[
                              RGB(106, 185, 187),
                              RGB(244, 213, 56),
                              RGB(132, 113, 106),
                              RGB(154, 38, 38),
                              RGB(254, 250, 215)
                              ];
    
    
    NSArray *colorArray = @[ShowingBlue, ShowingGreen, ShowingRed, ShowingOrange, ShowingPurple, ShowingYellow];
    self.dotColor = [colorArray_1 objectAtIndex:index];
//        self.dotColor = [colorArray_1 objectAtIndex:2];
}


- (UIColor *)selectingColor
{
    const CGFloat* colors = CGColorGetComponents(self.dotColor.CGColor);
    return [UIColor colorWithRed:colors[0] green:colors[1] blue:colors[2] alpha:colors[3] * 0.7f];
}


/**
 *  设置 Dot 的初始位置和最终显示位置
 */
- (void)settingDotPosition
{
    CGFloat interval = (ScreenRect.size.width - 6 * DMShowingDotRadius) / 7;
    CGFloat offsetX = interval;
    CGFloat offset = DMShowingDotRadius / 2;
    
    CGPoint pos = CGPointZero;
    
    pos = CGPointMake(offsetX + (interval + DMShowingDotRadius) * self.coordinate.x + offset
                      , -_superViewFrame.origin.y - self.bounds.size.height / 2 - (interval + DMShowingDotRadius) * fabsf(self.coordinate.y));
    
    self.originPosition = pos;
    
    
    CGFloat offsetY = (_superViewFrame.size.height - _superViewFrame.size.width) / 2;
    
    pos = CGPointMake(offsetX + (interval + DMShowingDotRadius) * self.coordinate.x + offset,
                      offsetY + (interval + DMShowingDotRadius) * fabsf(self.coordinate.y - 5) + offset + interval);
    self.showingPosition = pos;
}

- (void)runPlayabilityAdjustAnimationWithDelay:(int)delay withBlock:(void (^)(int index))block;
{
    if (self.animating == NO)
    {
        self.animating = YES;
        __weak __typeof(&*self)weakSelf = self;
        [UIView animateWithDuration:0.18 delay:delay * 0.008 options:UIViewAnimationOptionCurveLinear animations:^{
            
            weakSelf.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            weakSelf.alpha = 0.1f;
            
        } completion:^(BOOL finished) {
            
            [weakSelf randomDotColor];
            weakSelf.selectingDot.nodeColor = weakSelf.dotColor;
            weakSelf.showingDot.nodeColor = weakSelf.dotColor;
            
            [UIView animateWithDuration:0.18 delay:delay * 0.008 options:UIViewAnimationOptionCurveLinear animations:^{
                
                weakSelf.transform = CGAffineTransformIdentity;
                weakSelf.alpha = 1.0f;
                
            } completion:^(BOOL finished) {
                
                weakSelf.animating = NO;
                block(_dotIndex);
                
            }];
        }];
    }
}

@end
