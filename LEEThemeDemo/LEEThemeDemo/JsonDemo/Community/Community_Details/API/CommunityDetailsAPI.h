//
//  CommunityDetailsAPI.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/28.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "BaseBlockAPI.h"

#import "CommunityDetailsModel.h"

@interface CommunityDetailsAPI : BaseBlockAPI

/**
 加载帖子详情数据
 
 @param postId      帖子Id
 @param circleId    圈子Id
 @param resultBlock 结果回调Block
 */
- (void)loadPostDetailsDataWithPostId:(NSString *)postId
                             CircleId:(NSString *)circleId
                          ResultBlock:(APIRequestResultBlock)resultBlock;

/**
 解析数据
 
 @param resultBlock 结果回调Block
 */
- (void)analyticalDataWithData:(id)data ResultBlock:(void(^)(id))resultBlock;

/**
 点赞帖子
 
 @param postId      帖子Id
 @param circleId    圈子Id
 @param authorId    作者Id
 @param authorName  作者名称
 @param title       帖子标题
 @param resultBlock 结果回调Block
 */
- (void)praisePostWithPostId:(NSString *)postId
                    CircleId:(NSString *)circleId
                    AuthorId:(NSString *)authorId
                  AuthorName:(NSString *)authorName
                       Title:(NSString *)title
                 ResultBlock:(APIRequestResultBlock)resultBlock;

/**
 删除帖子

 @param postId      帖子Id
 @param circleId    圈子Id
 @param resultBlock 结果回调Block
 */
- (void)deletePostWithPostId:(NSString *)postId
                    CircleId:(NSString *)circleId
                 ResultBlock:(APIRequestResultBlock)resultBlock;

@end
