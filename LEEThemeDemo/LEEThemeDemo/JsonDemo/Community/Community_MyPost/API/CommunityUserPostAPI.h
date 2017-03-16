//
//  CommunityMyPostAPI.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/9.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "BaseBlockAPI.h"

#import "CommunityListModel.h"

@interface CommunityUserPostAPI : BaseBlockAPI

/**
 加载指定页数数据
 
 @param page        页数
 @param userId      用户Id
 @param resultBlock 结果回调Block
 */
- (void)loadDataWithPage:(NSInteger)page UserId:(NSString *)userId ResultBlock:(APIRequestResultBlock)resultBlock;

/**
 解析数据
 
 @param resultBlock 结果回调Block
 */
- (void)analyticalDataWithData:(id)data ResultBlock:(void(^)(NSArray *))resultBlock;

/**
 删除帖子

 @param postId 帖子Id
 @param resultBlock 结果回调Block
 */
- (void)deletePostWithPostId:(NSString *)postId CircleId:(NSString *)circleId ResultBlock:(APIRequestResultBlock)resultBlock;

@end
