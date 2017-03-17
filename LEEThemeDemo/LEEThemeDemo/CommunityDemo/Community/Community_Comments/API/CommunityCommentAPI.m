//
//  CommunityCommentAPI.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/1.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityCommentAPI.h"

@implementation CommunityCommentAPI

- (void)sendCommentDataWithPostId:(NSString *)postId
                     PostAuthorId:(NSString *)postAuthorId
                          Content:(NSString *)content
                    RootCommentId:(NSString *)rootCommentId
                RootCommentUserId:(NSString *)rootCommentUserId
                      ResultBlock:(APIRequestResultBlock)resultBlock{
    
    // 模拟请求成功
    
    if (resultBlock) resultBlock(RequestResultTypeSuccess , nil);
}

- (void)analyticalDataWithData:(id)data ResultBlock:(void(^)(id))resultBlock{
    
}

//赞评论

- (void)praiseCommentDataWithCommentId:(NSString *)commentId
                                PostId:(NSString *)postId
                              CircleId:(NSString *)circleId
                              AuthorId:(NSString *)authorId
                            AuthorName:(NSString *)authorName
                                 Title:(NSString *)title
                           ResultBlock:(APIRequestResultBlock)resultBlock{
    
    // 模拟请求成功
    
    if (resultBlock) resultBlock(RequestResultTypeSuccess , nil);
}

//删除评论

- (void)deleteCommentDataWithCommentId:(NSString *)commentId
                           ResultBlock:(APIRequestResultBlock)resultBlock{
    
    // 模拟请求成功
    
    if (resultBlock) resultBlock(RequestResultTypeSuccess , nil);
}

//举报评论

- (void)reportCommentDataWithCommentId:(NSString *)commentId
                           ResultBlock:(APIRequestResultBlock)resultBlock{
    
    // 模拟请求成功
    
    if (resultBlock) resultBlock(RequestResultTypeSuccess , nil);
}

@end
