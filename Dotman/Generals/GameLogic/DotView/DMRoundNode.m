//
//  DMRoundNode.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/8.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMRoundNode.h"
#import "UIImage+Additions.h"

@implementation DMRoundNode

- (id)init
{
    if (self = [super init])
    {
        // 背景透明
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 背景透明
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setNodeColor:(UIColor *)nodeColor
{
    _nodeColor = nodeColor;
    [self setNeedsDisplay]; // 颜色变化
}

- (void)setNodeImage:(UIImage *)nodeImage
{
    _nodeImage = nodeImage;
    [self setNeedsDisplay]; // 图片变化
}

/**
 *  定制 Dot 形状和颜色
 *
 *  @param rect rect
 */
- (void)drawRect:(CGRect)rect
{
    // 设置背景为透明
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context,rect);
    
    CGRect bounds = self.bounds;
    // 裁剪成圆形
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:bounds.size.width / 2] addClip];
    // 绘制颜色
    [[UIImage imageWithColor:self.nodeColor] drawInRect:bounds];
    // 绘制图片
    if (self.nodeImage)
    {
        CGSize imgSize = [self resizeNodeImageSizeIfNeed];
        CGFloat x = (self.bounds.size.width - imgSize.width) / 2;
        CGFloat y = (self.bounds.size.height - imgSize.height) / 2;
        CGRect imgRect = CGRectMake(x, y, imgSize.width, imgSize.height);
        [self.nodeImage drawInRect:imgRect];
    }
}

#pragma mark - Private

- (CGSize)resizeNodeImageSizeIfNeed
{
    CGSize size = self.nodeImage.size;
    CGFloat maxLen = self.bounds.size.width / sqrtf(2.0);
    if (size.width > maxLen || size.height > maxLen)
    {
        CGFloat radioW = size.width / maxLen;
        CGFloat radioH = size.height / maxLen;
        CGFloat maxRadio = radioW >= radioH ? radioW : radioH;
        size.width = size.width / maxRadio;
        size.height = size.height / maxRadio;
    }
    return size;
}

@end
