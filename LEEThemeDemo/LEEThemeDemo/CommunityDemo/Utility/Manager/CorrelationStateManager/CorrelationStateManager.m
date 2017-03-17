//
//  CorrelationStateManager.m
//  MierMilitaryNews
//
//  Created by 李响 on 16/8/2.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CorrelationStateManager.h"

#import "CorrelationStateDataBase.h"

@implementation CorrelationStateManager

#pragma mark - 添加

+ (void)addType:(CorrelationType)type State:(CorrelationState)state Identifier:(NSString *)identifier{
    
    //异步添加
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *userId = [self getUserIdWithType:type State:state];
        
        //添加数据
        
        [[CorrelationStateDataBase shareDataBase] addDataWithType:type State:state UserId:userId Identifier:identifier];
        
        //移除当前类型状态下一周前的数据
        
        [[CorrelationStateDataBase shareDataBase] removeDataWithType:type State:state UserId:userId Day:7];
    });
    
}

#pragma mark - 检查

+ (BOOL)checkType:(CorrelationType)type State:(CorrelationState)state Identifier:(NSString *)identifier{
    
    NSString *userId = [self getUserIdWithType:type State:state];
    
    return [[CorrelationStateDataBase shareDataBase] checkDataWithType:type State:state UserId:userId Identifier:identifier];
}

#pragma mark - 移除

+ (void)removeType:(CorrelationType)type State:(CorrelationState)state Identifier:(NSString *)identifier{
    
    //异步移除
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *userId = [self getUserIdWithType:type State:state];
        
        [[CorrelationStateDataBase shareDataBase] removeDataWithType:type State:state UserId:userId Identifier:identifier];
    });
    
}

#pragma mark - 根据类型和状态获取用户ID

+ (NSString *)getUserIdWithType:(CorrelationType)type State:(CorrelationState)state{
    
    NSString *userId = nil;
    
    //判断类型
    
    switch (type) {
            
        case CorrelationTypeNewsDetails:
            
            //资讯详情类型
            
            switch (state) {
                    
                case CorrelationStateRead:
                    
                    //已读状态
                    
                    userId = @"0";
                    
                    break;
                    
                default:
                    
                    userId = @"0"; //当前登录用户Id
                    
                    break;
            }
            
            break;
            
        default:
            
            userId = @"0"; //当前登录用户Id
            
            break;
    }
    
    return userId;
}

@end
