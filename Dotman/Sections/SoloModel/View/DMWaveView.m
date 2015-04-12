//
//  DMWaveView.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/11.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMWaveView.h"

@interface DMWaveView ()

/**
 *  绘制层
 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

/**
 *  重绘定时器
 */
@property (nonatomic, strong) CADisplayLink *displayLink;


/**
 *  Y 轴方向的缩放
 */
@property (nonatomic, assign) CGFloat zoomY;

/**
 *  X 轴方向的平移
 */
@property (nonatomic, assign) CGFloat translateX;


@property (nonatomic, assign) BOOL flag;



@end

@implementation DMWaveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commitInit];
        [self addShapeLayer];
    }
    return self;
}


- (void)setWaveHeight:(CGFloat)waveHeight
{
    _waveHeight = waveHeight;
}

- (void)setWaveColor:(UIColor *)waveColor
{
    _waveColor = waveColor;
    
    self.shapeLayer.fillColor = waveColor.CGColor;
    self.shapeLayer.strokeColor = waveColor.CGColor;
}

- (void)pauseWateWave
{
    [self.displayLink invalidate];
}

- (void)resumeWaterWave
{
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

}

- (void)startWaterWave
{
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

#pragma mark -
// 初始化数据
- (void)commitInit
{
    self.zoomY = 1.0f;
    self.translateX = 0.0f;
    self.flag = NO;
}

- (void)addShapeLayer
{
    self.shapeLayer = [CAShapeLayer layer];
    
    // 绘制的路径
    self.shapeLayer.path = [self waterWavePath];
    
    // 填充的颜色
    self.shapeLayer.fillColor = [[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1] CGColor];
    // 路径线条的颜色
    self.shapeLayer.lineWidth = 0.1;
    // 路径线条的颜色
    self.shapeLayer.strokeColor = [[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1] CGColor];
    
    [self.layer addSublayer:self.shapeLayer];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
}

- (CGPathRef)waterWavePath
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, 0, self.waveHeight);
    
    CGFloat y = 0.0f;
    for (float x = 0; x <= ScreenRect.size.width; x ++)
    {
        y= self.zoomY * sin( x / 180 * M_PI - 4 * self.translateX / M_PI ) * 5 + self.waveHeight;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, ScreenRect.size.width, ScreenRect.size.height);
    CGPathAddLineToPoint(path, nil, 0, ScreenRect.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.waveHeight);
    
    return (CGPathRef)path;
}


- (void)stopDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    
    self.translateX += 0.1;// 平移
    if (!self.flag)
    {
        self.zoomY += 0.02;
        if (self.zoomY >= 1.5)
        {
            self.flag = YES;
        }
    }
    else
    {
        self.zoomY -= 0.02;
        if (self.zoomY <= 1.0)
        {
            self.flag = NO;
        }
    }
    
    // 内存释放问题 -- 重要
    CGPathRelease(self.shapeLayer.path);
    self.shapeLayer.path = [self waterWavePath];
}


@end
