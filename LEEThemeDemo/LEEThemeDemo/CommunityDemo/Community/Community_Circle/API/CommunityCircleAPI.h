//
//  CommunityCircleAPI.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/26.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "BaseBlockAPI.h"

#import "CommunityCircleModel.h"

#import "CommunityListModel.h"

@interface CommunityCircleAPI : BaseBlockAPI

/**
 加载圈子列表数据

 @param resultBlock 结果回调Block
 */
- (void)loadCircleListDataResultBlock:(APIRequestResultBlock)resultBlock;

/**
 解析圈子列表数据
 
 @param resultBlock 结果回调Block
 */
- (void)analyticalCircleListDataWithData:(id)data ResultBlock:(void(^)(NSMutableArray *))resultBlock;

/**
 加载圈子详情数据

 @param circleId    圈子Id
 @param resultBlock 结果回调Block
 */
- (void)loadCircleDetailsDataWithCircleId:(NSString *)circleId Page:(NSInteger)page Type:(NSString *)type ResultBlock:(APIRequestResultBlock)resultBlock;

/**
 解析圈子详情数据
 
 @param resultBlock 结果回调Block
 */
- (void)analyticalCircleDetailsDataWithData:(id)data ResultBlock:(void(^)(NSDictionary *))resultBlock;

@end
