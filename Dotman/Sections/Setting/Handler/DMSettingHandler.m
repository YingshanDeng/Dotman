//
//  DMSettingHandler.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/6.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMSettingHandler.h"


#define DMSettingHandler_Persistentce_Document_Name @"DM-Setting"
#define DMSettingHandler_Persistentce_Plist_Name    @"DM-Setting-File.plist"


NSString * const DMSettingHandler_Persistence_PlayerName_Key    = @"DM-PlayerName";
NSString * const DMSettingHandler_Persistence_SoundEffect_Key   = @"DM-SoundEffect";
NSString * const DMSettingHandler_Persistence_VibrateEffect_Key = @"DM-VibrateEffect";
NSString * const DMSettingHandler_Persistence_Dots_Color_Key    = @"DM-DotsColor";
NSString * const DMSettingHandler_Persistence_Theme_Color_Key   = @"DM-ThemeColor";


@implementation DMSettingHandler

+ (id)defaultSettingHandle
{
    static DMSettingHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
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

- (NSDictionary *)readSettingDictionaryData
{
    NSString *filePath = [self getSettingPersistenceFilePath];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

- (void)persistObject:(id)obj forKey:(NSString *)key
{
    NSString *filePath = [self getSettingPersistenceFilePath];
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
    NSString *settingPath = [libraryPath stringByAppendingPathComponent:DMSettingHandler_Persistentce_Document_Name];
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
    NSString *settingPlistPath = [settingPath stringByAppendingPathComponent:DMSettingHandler_Persistentce_Plist_Name];
    // 生成函数默认数据的 plist 文件
    if (![fileManager fileExistsAtPath:settingPlistPath])
    {
        [fileManager createFileAtPath:settingPlistPath contents:nil attributes:nil];
        
        // default
        NSDictionary *defaultSettingDic = @{DMSettingHandler_Persistence_PlayerName_Key : @"Default",
                                            DMSettingHandler_Persistence_SoundEffect_Key : @(YES),
                                            DMSettingHandler_Persistence_VibrateEffect_Key : @(YES),
                                            /*DMSettingHandler_Persistence_Dots_Color_Key : @"",
                                            DMSettingHandler_Persistence_Theme_Color_Key : @""*/};
        [defaultSettingDic writeToFile:settingPlistPath atomically:YES];
    }
}

/**
 *  plist 文件路径
 */
- (NSString *)getSettingPersistenceFilePath
{
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [[libraryPath stringByAppendingPathComponent:DMSettingHandler_Persistentce_Document_Name]
                          stringByAppendingPathComponent:DMSettingHandler_Persistentce_Plist_Name];
    return filePath;
}

@end
