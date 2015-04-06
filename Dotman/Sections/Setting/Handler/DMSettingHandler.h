//
//  DMSettingHandler.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/6.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const DMSettingHandler_Persistence_PlayerName_Key;
extern NSString * const DMSettingHandler_Persistence_SoundEffect_Key;
extern NSString * const DMSettingHandler_Persistence_Shock_Effect_Key;


/**
 *  设置页面数据-持久化管理类
 */
@interface DMSettingHandler : NSObject


+ (id)defaultSettingHandle;

/**
 *  读取数据
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

@end
