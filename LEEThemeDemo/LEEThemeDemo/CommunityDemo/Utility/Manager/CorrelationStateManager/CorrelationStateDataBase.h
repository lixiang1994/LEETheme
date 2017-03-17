//
//  CorrelationStateDataBase.h
//  MierMilitaryNews
//
//  Created by 李响 on 16/8/2.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CorrelationStateDataBase : NSObject

+(CorrelationStateDataBase *)shareDataBase;

/**
 *  添加数据
 *
 *  @param type       相关类型
 *  @param state      相关状态
 *  @param identifier 唯一标识
 *  @param userId     用户ID
 *
 *  @return YES or NO
 */
-(BOOL)addDataWithType:(NSInteger)type
                 State:(NSInteger)state
                UserId:(NSString *)userId
            Identifier:(NSString *)identifier;

/**
 *  移除数据
 *
 *  @param type       相关类型
 *  @param state      相关状态
 *  @param userId     用户ID
 *  @param identifier 唯一标识
 *
 *  @return YES or NO
 */
-(BOOL)removeDataWithType:(NSInteger)type
                    State:(NSInteger)state
                   UserId:(NSString *)userId
               Identifier:(NSString *)identifier;

/**
 *  移除数据
 *
 *  @param type  相关类型
 *  @param state 相关状态
 *  @param userId用户ID
 *  @param day   天数 (几天前的数据)
 */
- (void)removeDataWithType:(NSInteger)type
                     State:(NSInteger)state
                    UserId:(NSString *)userId
                       Day:(NSInteger)day;

/**
 *  移除数据
 *
 *  @param day 天数 (几天前的数据)
 */
- (void)removeDataWithDay:(NSInteger)day;

/**
 *  移除全部数据
 *
 *  @return YES or NO
 */
-(BOOL)removeAllData;

/**
 *  检查数据是否存在
 *
 *  @param type       相关类型
 *  @param state      相关状态
 *  @param identifier 唯一标识
 *  @param userId     用户ID
 *
 *  @return YES or NO
 */
- (BOOL)checkDataWithType:(NSInteger)type
                    State:(NSInteger)state
                   UserId:(NSString *)userId
               Identifier:(NSString *)identifier;


@end
