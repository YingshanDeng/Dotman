//
//  DMStatisticHandler.m
//  Dotman
//
//  Created by YingshanDeng on 15/5/8.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMStatisticHandler.h"

#define DMStatisticHandler_Document_Name           @"DM-Statistic"
#define DMStatisticHandler_Persistentce_Plist_Name @"DM-Statistic-File.plist"

#define DMStatisticHandler_Timing_PlayCount_Key    @"DM-Statistic-Timing"
#define DMStatisticHandler_Moving_PlayCount_Key    @"DM-Statistic-Moving"
#define DMStatisticHandler_Infinite_PlayCount_Key  @"DM-Statistic-Infinite"

@implementation DMStatisticHandler

+ (id)defaultStatisticHandler
{
    static DMStatisticHandler *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc] init];
    });
    return shareInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self generatePersistenceFile];
    }
    return self;
}

- (void)increasePlayCount:(DMPlayMode)playMode
{
    NSDictionary *statisticDic = [self readStatisticDictionaryData];
    switch (playMode) {
        case DMPlayTimingMode:
        {
            NSInteger count = [[statisticDic objectForKey:DMStatisticHandler_Timing_PlayCount_Key] integerValue];
            count ++;
            [self persistObject:@(count) forKey:DMStatisticHandler_Timing_PlayCount_Key];
            break;
        }
        case DMPlayMovingMode:
        {
            NSInteger count = [[statisticDic objectForKey:DMStatisticHandler_Moving_PlayCount_Key] integerValue];
            count ++;
            [self persistObject:@(count) forKey:DMStatisticHandler_Moving_PlayCount_Key];
            break;
        }
        case DMPlayInfiniteMode:
        {
            NSInteger count = [[statisticDic objectForKey:DMStatisticHandler_Infinite_PlayCount_Key] integerValue];
            count ++;
            [self persistObject:@(count) forKey:DMStatisticHandler_Infinite_PlayCount_Key];
            break;
        }
        default:
            break;
    }
}


- (NSInteger)getPlayCount:(DMPlayMode)playMode
{
    NSDictionary *statisticDic = [self readStatisticDictionaryData];
    switch (playMode) {
        case DMPlayTimingMode:
        {
            return [[statisticDic objectForKey:DMStatisticHandler_Timing_PlayCount_Key] integerValue];
        }
        case DMPlayMovingMode:
        {
            return [[statisticDic objectForKey:DMStatisticHandler_Moving_PlayCount_Key] integerValue];
        }
        case DMPlayInfiniteMode:
        {
            return [[statisticDic objectForKey:DMStatisticHandler_Infinite_PlayCount_Key] integerValue];
        }
        default:
            break;
    }
    return 0;
}

#pragma mark - 
- (NSDictionary *)readStatisticDictionaryData
{
    NSString *filePath = [self getStatisticPersistenceFilePath];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

- (void)persistObject:(id)obj forKey:(NSString *)key
{
    NSString *filePath = [self getStatisticPersistenceFilePath];
    NSMutableDictionary *curDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [curDic setObject:obj forKey:key];
    [curDic writeToFile:filePath atomically:YES];
}

#pragma mark -
/**
 *  生成 plist 文件
 */
- (void)generatePersistenceFile
{
    // library 目录
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    // 在 library 目录下创建一个 setting 子目录
    NSString *settingPath = [libraryPath stringByAppendingPathComponent:DMStatisticHandler_Document_Name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManager fileExistsAtPath:settingPath isDirectory:&isDir];
    
    // 存在同名的非目录文件，先删除
    if (isDir == NO && isExist == YES)
    {
        [fileManager removeItemAtPath:settingPath error:nil];
        [fileManager createDirectoryAtPath:settingPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 如果不存在，则先创建一个
    else if (isDir == NO && isExist == NO)
    {
        [fileManager createDirectoryAtPath:settingPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 创建 plist 文件
    NSString *settingPlistPath = [settingPath stringByAppendingPathComponent:DMStatisticHandler_Persistentce_Plist_Name];
    // 生成函数默认数据的 plist 文件
    if (![fileManager fileExistsAtPath:settingPlistPath])
    {
        [fileManager createFileAtPath:settingPlistPath contents:nil attributes:nil];
        
        // default
        NSDictionary *defaultSettingDic = @{DMStatisticHandler_Timing_PlayCount_Key : @(0),
                                            DMStatisticHandler_Moving_PlayCount_Key : @(0),
                                            DMStatisticHandler_Infinite_PlayCount_Key : @(0)};
        [defaultSettingDic writeToFile:settingPlistPath atomically:YES];
    }
}

/**
 *  plist 文件路径
 */
- (NSString *)getStatisticPersistenceFilePath
{
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [[libraryPath stringByAppendingPathComponent:DMStatisticHandler_Document_Name]
                          stringByAppendingPathComponent:DMStatisticHandler_Persistentce_Plist_Name];
    return filePath;
}


@end
