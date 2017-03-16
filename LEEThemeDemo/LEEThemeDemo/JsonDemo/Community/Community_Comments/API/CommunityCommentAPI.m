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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"comment" forKey:@"controller"];
    
    [params setValue:@"postComment" forKey:@"action"];
    
    [params setValue:postId forKey:@"tid"];
    
    [params setValue:postAuthorId forKey:@"author_id"];
    
    [params setValue:content forKey:@"message"];
    
    [params setValue:rootCommentId ? @(2) : @(1) forKey:@"comment_type"];
    
    [params setValue:rootCommentId forKey:@"original_pid"];
    
    [params setValue:rootCommentUserId forKey:@"fuid"];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

//删除评论

- (void)deleteCommentDataWithCommentId:(NSString *)commentId
                           ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

//举报评论

- (void)reportCommentDataWithCommentId:(NSString *)commentId
                           ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

@end
