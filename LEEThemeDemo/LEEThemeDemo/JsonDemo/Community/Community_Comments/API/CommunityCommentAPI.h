//
//  CommunityCommentAPI.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/1.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "BaseBlockAPI.h"

#import "CommunityCommentModel.h"

@interface CommunityCommentAPI : BaseBlockAPI

/**
 发送评论

 @param postId  帖子Id
 @param postAuthorId 帖子作者Id
 @param content 内容
 @param rootCommentId 所属评论Id
 @param rootCommentUserId 所属评论用户Id
 @param resultBlock 结果回调Block
 */
- (void)sendCommentDataWithPostId:(NSString *)postId
                     PostAuthorId:(NSString *)postAuthorId
                          Content:(NSString *)content
                    RootCommentId:(NSString *)rootCommentId
                RootCommentUserId:(NSString *)rootCommentUserId
                      ResultBlock:(APIRequestResultBlock)resultBlock;

/**
 解析数据
 
 @param resultBlock 结果回调Block
 */
- (void)analyticalDataWithData:(id)data ResultBlock:(void(^)(id))resultBlock;

//赞评论

- (void)praiseCommentDataWithCommentId:(NSString *)commentId
                                PostId:(NSString *)postId
                              CircleId:(NSString *)circleId
                              AuthorId:(NSString *)authorId
                            AuthorName:(NSString *)authorName
                                 Title:(NSString *)title
                           ResultBlock:(APIRequestResultBlock)resultBlock;

//删除评论

- (void)deleteCommentDataWithCommentId:(NSString *)commentId
                           ResultBlock:(APIRequestResultBlock)resultBlock;

//举报评论

- (void)reportCommentDataWithCommentId:(NSString *)commentId
                           ResultBlock:(APIRequestResultBlock)resultBlock;

@end
