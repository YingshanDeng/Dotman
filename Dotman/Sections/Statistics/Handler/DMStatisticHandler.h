//
//  DMStatisticHandler.h
//  Dotman
//
//  Created by YingshanDeng on 15/5/8.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DMPlayMode)
{
    DMPlayTimingMode,
    DMPlayMovingMode,
    DMPlayInfiniteMode
};


@interface DMStatisticHandler : NSObject

+ (id)defaultStatisticHandler;

- (void)increasePlayCount:(DMPlayMode)playMode;
- (NSInteger)getPlayCount:(DMPlayMode)playMode;


@end
