//
//  CommunityDetailsAPI.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/28.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityDetailsAPI.h"

@implementation CommunityDetailsAPI

- (void)loadPostDetailsDataWithPostId:(NSString *)postId CircleId:(NSString *)circleId ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"Community" forKey:@"controller"];
    
    [params setValue:@"Details" forKey:@"action"];
    
    [params setValue:postId forKey:@"id"];
    
    [params setValue:circleId forKey:@"cid"];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

- (void)analyticalDataWithData:(id)data ResultBlock:(void(^)(id))resultBlock{
    
    id model = [CommunityDetailsModel modelWithJSON:data[@"data"]];
    
    if (resultBlock) resultBlock(model);
}

- (void)praisePostWithPostId:(NSString *)postId
                    CircleId:(NSString *)circleId
                    AuthorId:(NSString *)authorId
                  AuthorName:(NSString *)authorName
                       Title:(NSString *)title
                 ResultBlock:(APIRequestResultBlock)resultBlock;{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

- (void)deletePostWithPostId:(NSString *)postId CircleId:(NSString *)circleId ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"Thread" forKey:@"controller"];
    
    [params setValue:@"deleteThread" forKey:@"action"];
    
    [params setValue:postId forKey:@"tid"];
    
    [params setValue:circleId forKey:@"fid"];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

@end
