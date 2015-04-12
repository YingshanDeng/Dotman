//
//  DMSettingHandler.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/6.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

// 玩家昵称
extern NSString * const DMSettingHandler_Persistence_PlayerName_Key;
// 音效
extern NSString * const DMSettingHandler_Persistence_SoundEffect_Key;
// 震动效果
extern NSString * const DMSettingHandler_Persistence_VibrateEffect_Key;
// Dots 颜色
extern NSString * const DMSettingHandler_Persistence_Dots_Color_Key;
// 游戏背景颜色
extern NSString * const DMSettingHandler_Persistence_Theme_Color_Key;


/**
 *  设置页面数据-持久化管理类
 */
@interface DMSettingHandler : NSObject

/**
 *  单例类方法
 *
 *  @return 单例对象
 */
+ (id)defaultSettingHandle;

/**
 *  读取所有setting数据
 *
 *  @return 字典数据
 */
- (NSDictionary *)readSettingDictionaryData;

/**
 *  持久化保存一项数据
 *
 *  @param obj 数据内容
 *  @param key 键值
 */
- (void)persistObject:(id)obj forKey:(NSString *)key;

/**
 *  是否支持声音效果
 *
 *  @return 布尔值
 */
- (BOOL)supportSoundEffect;

/**
 *  是否支持震动效果
 *
 *  @return 布尔值
 */
- (BOOL)supportVibrateEffect;

@end
