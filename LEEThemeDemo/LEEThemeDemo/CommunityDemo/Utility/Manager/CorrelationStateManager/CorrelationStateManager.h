//
//  CorrelationStateManager.h
//  MierMilitaryNews
//
//  Created by 李响 on 16/8/2.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 相关类型 (常用于 资讯 评论 社区等)
 */
typedef enum {
    
    CorrelationTypeNewsDetails = 0, //资讯详情
    
    CorrelationTypeNewsComment, //资讯评论
    
    CorrelationTypeCommunityDetails, //社区详情
    
    CorrelationTypeCommunityComment, //社区评论
    
    CorrelationTypeSystemMessage, //系统消息
    
    CorrelationTypeUserHome, //用户主页
    
} CorrelationType;

/**
 相关状态类型 (常用于 资讯 评论 社区等)
 */
typedef enum {
    
    CorrelationStateNormal = 0,
    
    CorrelationStatePraise, //点赞状态
    
    CorrelationStateRead, //已读状态
    
    CorrelationStateReport, //举报状态
    
    CorrelationStateReward, //已打赏状态
    
    CorrelationStateDislike, //不喜欢状态
    
} CorrelationState;

@interface CorrelationStateManager : NSObject

/**
 *  添加
 *
 *  @param type       相关类型
 *  @param state      相关状态
 *  @param identifier 标识 (一般为资讯ID或者评论ID之类)
 */
+ (void)addType:(CorrelationType)type State:(CorrelationState)state Identifier:(NSString *)identifier;

/**
 *  检查
 *
 *  @param type       相关类型
 *  @param state      相关状态
 *  @param identifier 标识 (一般为资讯ID或者评论ID之类)
 *
 *  @return YES 存在 or NO 不存在
 */
+ (BOOL)checkType:(CorrelationType)type State:(CorrelationState)state Identifier:(NSString *)identifier;

/**
 *  移除
 *
 *  @param type       相关类型
 *  @param state      相关状态
 *  @param identifier 标识 (一般为资讯ID或者评论ID之类)
 */
+ (void)removeType:(CorrelationType)type State:(CorrelationState)state Identifier:(NSString *)identifier;

@end
