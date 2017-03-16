//
//  CommunityMyPostAPI.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/9.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityUserPostAPI.h"

@implementation CommunityUserPostAPI

- (void)loadDataWithPage:(NSInteger)page UserId:(NSString *)userId ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"ThreadList" forKey:@"controller"];
    
    [params setValue:@"getUserThreads" forKey:@"action"];
    
    [params setValue:userId ? userId : params[@"user_id"] forKey:@"to_uid"];
    
    [params setValue:@(page) forKey:@"page"];
    
    [params setValue:@(10) forKey:@"limit"];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

- (void)analyticalDataWithData:(id)data ResultBlock:(void(^)(NSArray *))resultBlock{
    
    NSArray *postArray = [NSArray modelArrayWithClass:[CommunityListModel class] json:data[@"data"]];
    
    if (resultBlock) resultBlock(postArray);
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
