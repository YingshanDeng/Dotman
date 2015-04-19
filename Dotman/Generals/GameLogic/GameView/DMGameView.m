//
//  DMGameView.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/8.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMGameView.h"
#import "DMDotSprite.h"
#import "UIImage+Additions.h"
#import "DMSettingHandler.h"
#import "SoundManager.h"



@implementation DMGameView
{
    /**
     *  屏幕中显示的dot
     */
    NSMutableArray *_dotsArray;
    
    /**
     *  选中的dot集合
     */
    NSMutableArray *_selectedStack;
    
    /**
     *  消除dot之上的所有dots
     */
    NSMutableArray *_dropDownArray;
    
    /**
     *  绘制线条颜色（和选中dot颜色相同）
     */
    UIColor *_lineColor;
    
    /**
     *  touch point
     */
    CGPoint _touchPoint;
    
    /**
     *  是否选中的dots中有回环
     */
    BOOL _isLoop;
    
    /**
     *  loop animation是否已经执行过
     */
    BOOL _loopAnimationDone;
    
    /**
     *  在出现loop时，显示的覆盖层
     */
    UIView *_coverLayer;
}

// 说明：关于游戏界面的宽和高约束: 高度不能小于高度
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:223.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];

        [self setupDots];
        [self initProperties];
    }
    return self;
}



- (void)startGame
{
    for (int i = 0; i < DMGameView_Number_Of_Dots_Y; i ++) // y轴
    {
        for (int j = 0; j < DMGameView_Number_Of_Dots_X; j ++) // x轴
        {
            DMDotSprite *dot = (DMDotSprite *)[_dotsArray objectAtIndex:i * DMGameView_Number_Of_Dots_X + j];
            [dot runStartDropDownAnimationWithBlock:^(int index) {
                // 所有的dot掉落动画执行完成才可以开始进行游戏
                if (index == DMGameView_Number_Of_Dots_X * DMGameView_Number_Of_Dots_Y - 1)
                {
                    self.canPlaying = [self playabilityDetection];
                    if (!self.canPlaying)
                    {
                        [self playabilityAdjust];
                    }
                    
                }
            }];
        }
    }
}

- (void)restartGame
{
    //TODO: 重启游戏暂时用这个处理
    [self playabilityAdjust];
}

- (void)resumeGame
{
    self.canPlaying = YES;
}

- (void)pauseGame
{
    self.canPlaying = NO;
}

- (void)stopGameWithCompletion:(void (^)(void))block
{
    self.canPlaying = NO;
    NSInteger index = 0;
    for (DMDotSprite *dotSprite in _dotsArray)
    {
        index ++;
        [dotSprite runStopGameAnimationWithBlock:^{
            if (index == DMGameView_Number_Of_Dots_X * DMGameView_Number_Of_Dots_Y)
            {
                block();
            }
        }];
    }
}

#pragma mark -
- (void)setupDots
{
    _dotsArray = [[NSMutableArray alloc] initWithCapacity:DMGameView_Number_Of_Dots_X * DMGameView_Number_Of_Dots_Y];
    for (int i = 0; i < DMGameView_Number_Of_Dots_Y; i ++) // y轴
    {
        for (int j = 0; j < DMGameView_Number_Of_Dots_X; j ++) // x轴
        {
            DMDotSprite *dot = [[DMDotSprite alloc] initWithFrame:CGRectMake(0, 0, DMSelectingDotRadius, DMSelectingDotRadius)];
            [dot generateDotWithCoordinate:CGPointMake(j, i) withSuperViewFrame:self.frame];
            [_dotsArray addObject:dot];
            [self addSubview:dot];
        }
    }
}

- (void)initProperties
{
    self.multipleTouchEnabled = NO;
    self.canPlaying = NO;
    self.canDrawLine = NO;
    
    _selectedStack = [[NSMutableArray alloc] initWithCapacity:DMGameView_Number_Of_Dots_X * DMGameView_Number_Of_Dots_Y];
    _dropDownArray = [[NSMutableArray alloc] initWithCapacity:DMGameView_Number_Of_Dots_X * DMGameView_Number_Of_Dots_Y];
    _touchPoint = CGPointZero;
    _isLoop = NO;
    _loopAnimationDone = NO;
    _coverLayer = [[UIView alloc] initWithFrame:self.bounds];
}




#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.canPlaying)
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        _touchPoint = point;
        
        if (_selectedStack.count != 0)
        {
            [_selectedStack removeAllObjects];
        }
        
        DMDotSprite *dot = [self getCurrentSelectDotWithCurrentPostion:point];
        
        if (dot && dot.animating == NO)
        {
            [dot runSelectingAnimation];
            
            _lineColor = dot.dotColor;
            self.canDrawLine = YES;
            [_selectedStack addObject:dot];
            [self playEffectSound];
        }
        
        [self setNeedsDisplay];
    }
    else
    {
        [super touchesBegan:touches withEvent:event];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.canPlaying)
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        _touchPoint = point;
        
        
        DMDotSprite *dot = [self getCurrentSelectDotWithCurrentPostion:point];
        
        if (dot && CGColorEqualToColor(_lineColor.CGColor, dot.dotColor.CGColor))
        {
            // 选中的 dot 已经在选中dot集合中，返回
            if (dot == _selectedStack.lastObject)
            {
                [self setNeedsDisplay];
                return;
            }
            
            // 退一格处理
            if (_selectedStack.count >=2 && dot == [_selectedStack objectAtIndex:_selectedStack.count - 2])
            {
                [_selectedStack removeLastObject];
                _isLoop = [self loopDetetion];
                if (_isLoop == NO)
                {
                    _loopAnimationDone = NO;
                    [self removeCoverLayer];
                }
                if (dot.animating == NO)
                {
                    [dot runSelectingAnimation];
                    [self playEffectSound];
                }
                [self setNeedsDisplay];
                return;
            }
            
            
            DMDotSprite *lastDot = [_selectedStack lastObject];
            int absValue = abs(dot.coordinate.x - lastDot.coordinate.x) + abs(dot.coordinate.y - lastDot.coordinate.y);
            if (absValue == 1)
            {
                if (dot.animating == NO)
                {
                    [dot runSelectingAnimation];
                }
                [_selectedStack addObject:dot];
                _isLoop = [self loopDetetion];
                
                if (_isLoop && !_loopAnimationDone)
                {
                    _loopAnimationDone = YES;
                    [self runLoopAnimation];
                    [self addCoverLayerWhenLoop];
                }
                
                [self playEffectSound];
            }
        }
        [self setNeedsDisplay];
        
    }
    else
    {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.canPlaying)
    {
        [self touchEndProcesss];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.canPlaying)
    {
        [self touchEndProcesss];
    }
}

- (void)touchEndProcesss
{
    if (_selectedStack.count >= 2)
    {
        self.canPlaying = NO;
        if (_isLoop) // 存在回环，消除所有同颜色的dot
        {
            [self disappearAllSameColorDots];
        }
        [self processDisappear];
    }
    [self setNeedsDisplay];
    self.canDrawLine = NO;
}

#pragma mark - Game Logic

// 更加触摸位置坐标获取dot
- (DMDotSprite *)getCurrentSelectDotWithCurrentPostion:(CGPoint)pos
{
    if (_dotsArray.count)
    {
        for (DMDotSprite *dot in _dotsArray)
        {
            if (CGRectContainsPoint([dot getDetetionAreaRect], pos))
            {
                return dot;
            }
        }
        return nil;
    }
    return nil;
}

- (void)processDisappear
{
    // 需要判断是否有覆盖层，若有，则移除。
    [self removeCoverLayer];
    
    // 去除重复元素
    NSSet *dotSet = [NSSet setWithArray:_selectedStack];
    __block NSInteger nCount = dotSet.count;
    
    for (DMDotSprite *dot in dotSet)
    {
        // 消除点执行动画
        [dot runDisappearDotAnimationWithBlock:^{
            nCount --;
            if (nCount == 0) //消除动画结束后
            {
                [self processDisappearEnd];
            }
        }];
    }
}

// 处理一次消除过程
- (void)processDisappearEnd
{
    // 用于去除重复元素
    NSSet *dotSet = [NSSet setWithArray:_selectedStack];
    
    // 计分
    NSLog(@"count = %@",@(dotSet.count));
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishOnceDisappearWithScore:)])
    {
        [self.delegate didFinishOnceDisappearWithScore:dotSet.count];
    }
    
    
    // 选中的dot至少要有一个
    if (_selectedStack.count == 0)
    {
        return;
    }
    // 获取掉落的dots
    [self getDropdownArray];
    
    // 执行掉落动画
    if (_dropDownArray.count)
    {
        for (DMDotSprite *dot in _dropDownArray)
        {
            [dot runDropDownAnimation];
        }
    }
    
    // 将那些被消除的dots重新生产利用
    //    __block NSInteger nCount = _selectedStack.count;
    //    for (DMDotSprite *dot in _selectedStack)
    //    {
    //        // 重新生成
    //        [dot reGenerateDotWithBlock:^{
    //            nCount --;
    //            if (nCount == 0)
    //            {
    //                [self newGameLoopStart];
    //            }
    //        }];
    //    }
    
    __block NSInteger nCount = dotSet.count;
    for (DMDotSprite *dot in dotSet)
    {
        // 重新生成
        [dot reGenerateDotWithBlock:^{
            nCount --;
            if (nCount == 0)
            {
                [self newGameLoopStart];
            }
        }];
    }
}

// 获取选中消除dot之上的所有dots
- (void)getDropdownArray
{
    // 获取消除dot之上的所有dot
    if (_dropDownArray.count)
    {
        [_dropDownArray removeAllObjects];
    }
    
    for (int i = 0; i < DMGameView_Number_Of_Dots_X * DMGameView_Number_Of_Dots_Y; i ++)
    {
        DMDotSprite *dot = (DMDotSprite *)[_dotsArray objectAtIndex:i];
        [self getDotsAboveSelectedDot:dot toArray:_dropDownArray];
    }
}

- (void)getDotsAboveSelectedDot:(DMDotSprite *)dot toArray:(NSMutableArray *)aboveArray
{
    if(!dot)
        return;
    
    while (true)
    {
        CGPoint coordinate = dot.coordinate;
        int curIndex = coordinate.y * DMGameView_Number_Of_Dots_X + coordinate.x;
        int downIndex = (coordinate.y - 1) * DMGameView_Number_Of_Dots_X + coordinate.x;
        if (downIndex < 0)
        {
            return;
        }
        
        DMDotSprite *downDot = (DMDotSprite *)[_dotsArray objectAtIndex:downIndex];
        
        /**
         *  注：如果当前dot的下方dot是需要消除的，那么二者进行进行交换coordinate；
         *  同时，如果当前dot是不需要消除的，那么添加入aboveArray中
         */
        if (downDot && downDot.disappear)
        {
            // 交换coordinate
            dot.coordinate = downDot.coordinate;
            downDot.coordinate = coordinate;
            [_dotsArray exchangeObjectAtIndex:curIndex withObjectAtIndex:downIndex];
            if (![aboveArray containsObject:dot] && !dot.disappear)
            {
                [aboveArray addObject:dot];
            }
        }
        
        if (downDot && !downDot.disappear)
        {
            break;
        }
    }
    
}

- (void)newGameLoopStart
{
    // 清除
    if (_selectedStack.count != 0)
    {
        [_selectedStack removeAllObjects];
    }
    if (_dropDownArray.count != 0)
    {
        [_dropDownArray removeAllObjects];
    }
    
    // 当前的棋盘是否可以进行游戏判断
    self.canPlaying = [self playabilityDetection];
    if (!self.canPlaying)
    {
        [self playabilityAdjust];
    }
    _loopAnimationDone = NO;
}


#pragma mark -- 回环处理

// 消除所有同颜色的dot
- (void)disappearAllSameColorDots
{
    _isLoop = NO;
    for (DMDotSprite *dot in _dotsArray)
    {
        if (dot && CGColorEqualToColor(_lineColor.CGColor, dot.dotColor.CGColor))
        {
            if (![_selectedStack containsObject:dot])
            {
                [_selectedStack addObject:dot];
            }
        }
    }
}

// 是否出现回环检测
- (BOOL)loopDetetion
{
    // 判断是否存在重复元素，即可以知道是否存在重复元素
    NSSet *dotSet = [NSSet setWithArray:_selectedStack];
    return (dotSet.count == _selectedStack.count) ? NO : YES;
}

/**
 *  出现回环后执行的动画效果：一次消除过程中只执行一次
 */
- (void)runLoopAnimation
{
    // 震动效果
    [self playVibrateEffect];
    
    for (DMDotSprite *dot in _dotsArray)
    {
        if (dot && CGColorEqualToColor(dot.dotColor.CGColor, _lineColor.CGColor) && ![_selectedStack containsObject:dot])
        {
            [dot runSelectingAnimation];
        }
    }
}


/**
 *  在出现回环的时候，显示一个覆盖层
 */
- (void)addCoverLayerWhenLoop
{
    if ([self.subviews containsObject:_coverLayer])
    {
        return;
    }
    // bg color
    const CGFloat* colors = CGColorGetComponents(_lineColor.CGColor);
    _coverLayer.layer.backgroundColor = [UIColor colorWithRed:colors[0] green:colors[1] blue:colors[2] alpha:0.200].CGColor;
    // border
    _coverLayer.layer.borderColor = _lineColor.CGColor;
    _coverLayer.layer.borderWidth = 6.0f;
    [self addSubview:_coverLayer];
    _coverLayer.alpha = 0.0f;
    [UIView animateWithDuration:0.2 animations:^{
        _coverLayer.alpha = 1.0f;
    }];
}

/**
 *  移除覆盖层
 */
- (void)removeCoverLayer
{
    if ([self.subviews containsObject:_coverLayer])
    {
        [UIView animateWithDuration:0.15 animations:^{
            _coverLayer.alpha = 0.1;
        } completion:^(BOOL finished) {
            [_coverLayer removeFromSuperview];
            _coverLayer.alpha = 1.0f;
        }];
    }
}

#pragma mark -- 可玩检测及处理

/**
 *  检测当前的游戏棋盘能否继续
 *
 *  @return bool
 */
- (BOOL)playabilityDetection
{
    // 假如当前棋盘无法继续进行消除，那么要重置棋盘
    int left = -1;
    int right = -1;
    int bottom = -1;
    int up = -1;
    
    for (DMDotSprite *dot in _dotsArray)
    {
        CGPoint coor = dot.coordinate;
        
        left = coor.y * DMGameView_Number_Of_Dots_X + (coor.x - 1);
        right = coor.y * DMGameView_Number_Of_Dots_X + (coor.x + 1);
        bottom = (coor.y - 1) * DMGameView_Number_Of_Dots_X + coor.x;
        up = (coor.y + 1) *DMGameView_Number_Of_Dots_X + coor.x;
        
        if (left >= 0 && left <= (DMGameView_Number_Of_Dots_X * DMGameView_Number_Of_Dots_Y - 1))
        {
            DMDotSprite *tmpDot = (DMDotSprite *)[_dotsArray objectAtIndex:left];
            if (CGColorEqualToColor(tmpDot.dotColor.CGColor, dot.dotColor.CGColor))
            {
                return YES;
            }
        }
        if (right >= 0 && right <= (DMGameView_Number_Of_Dots_X * DMGameView_Number_Of_Dots_Y - 1))
        {
            DMDotSprite *tmpDot = (DMDotSprite *)[_dotsArray objectAtIndex:right];
            if (CGColorEqualToColor(tmpDot.dotColor.CGColor, dot.dotColor.CGColor))
            {
                return YES;
            }
        }
        if (bottom >= 0 && bottom <= (DMGameView_Number_Of_Dots_X * DMGameView_Number_Of_Dots_Y - 1))
        {
            DMDotSprite *tmpDot = (DMDotSprite *)[_dotsArray objectAtIndex:bottom];
            if (CGColorEqualToColor(tmpDot.dotColor.CGColor, dot.dotColor.CGColor))
            {
                return YES;
            }
        }
        if (up >= 0 && up <= (DMGameView_Number_Of_Dots_X * DMGameView_Number_Of_Dots_Y - 1))
        {
            DMDotSprite *tmpDot = (DMDotSprite *)[_dotsArray objectAtIndex:up];
            if (CGColorEqualToColor(tmpDot.dotColor.CGColor, dot.dotColor.CGColor))
            {
                return YES;
            }
        }
    }
    return NO;
}

// 调整，使之可玩
- (void)playabilityAdjust
{
    __weak __typeof(&*self)weakSelf = self;
    int delay = 1;
    for (int y = DMGameView_Number_Of_Dots_Y - 1; y >= 0; y --)
    {
        for (int x = 0; x < DMGameView_Number_Of_Dots_X; x ++)
        {
            int i = y * DMGameView_Number_Of_Dots_X + x;
            DMDotSprite *dot = (DMDotSprite *)[_dotsArray objectAtIndex:i];
            // 为了解决BUG: 某些dot不执行动画
            dot.animating = NO;
            [dot runPlayabilityAdjustAnimationWithDelay:delay withBlock:^(int index) {
                // 最后一个完成的时：右下角那一个（dotIndex = 5）
                if (index == 5)
                {
                    weakSelf.canPlaying = [weakSelf playabilityDetection];
                    if (!weakSelf.canPlaying)
                    {
                        [weakSelf playabilityAdjust];
                    }
                }
            }];
            delay ++;
        }
    }
}

#pragma mark -- 音效和震动

// 播放音效
- (void)playEffectSound
{
    BOOL flag = [[DMSettingHandler defaultSettingHandle] supportSoundEffect];
    if (!flag) {
        return;
    }
    NSInteger nCount = _selectedStack.count;
    NSInteger soundIndex = nCount;
    if (nCount == 0)
    {
        return;
    }
    else if (nCount >= 13)
    {
        soundIndex = 13;
    }
    
    [[SoundManager sharedManager] playSound:[NSString stringWithFormat:@"%ld",(long)soundIndex] looping:NO fadeIn:NO];
}

// 震动效果 -- 出现回环，消除同种颜色
- (void)playVibrateEffect
{
    BOOL flag = [[DMSettingHandler defaultSettingHandle] supportVibrateEffect];
    if (!flag) {
        return;
    }
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

#pragma mark - Draw Line
- (void)drawRect:(CGRect)rect
{
    
    if(!_selectedStack.count || !self.canPlaying || !self.canDrawLine)
    {
        return;
    }
    // context setting
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColor(context, CGColorGetComponents(_lineColor.CGColor));
    CGContextSetLineWidth(context, 7);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    
    if (_selectedStack.count >= 2)
    {
        DMDotSprite *tmpDot = [_selectedStack firstObject];
        
        CGPoint prePoint = tmpDot.center;
        CGPoint nextPoint = CGPointZero;
        for (int index = 1; index < _selectedStack.count; index ++)
        {
            tmpDot = [_selectedStack objectAtIndex:index];
            nextPoint = tmpDot.center;
            
            CGContextMoveToPoint(context, prePoint.x, prePoint.y);
            CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
            
            prePoint = nextPoint;
        }
    }
    DMDotSprite *lastDot = [_selectedStack lastObject];
    CGPoint lastPoint = lastDot.center;
    
    CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(context, _touchPoint.x, _touchPoint.y);
    CGContextStrokePath(context);
}


@end