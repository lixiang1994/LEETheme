//
//  CommunityCommentListAPI.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/1.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityCommentListAPI.h"

@implementation CommunityCommentListAPI

#pragma mark - 加载评论数据

- (void)loadCommentListDataWithID:(NSString *)postId CircleId:(NSString *)circleId Page:(NSInteger)page ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setValue:@"Comment" forKey:@"controller"];
    
    [params setValue:@"index" forKey:@"action"];
    
    [params setValue:postId forKey:@"tid"];
    
    [params setValue:circleId forKey:@"fid"];
    
    [params setValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

#pragma mark - 解析数据

- (void)analyticalCommentListDataWithData:(id)data ResultBlock:(void(^)(NSDictionary *))resultBlock{
    
    NSDictionary *info = data[@"data"];
    
    NSArray *hotCommentArray = [NSArray modelArrayWithClass:[CommunityCommentModel class] json:info[@"hotCommentList"]];
    
    NSArray *allCommentArray = [NSArray modelArrayWithClass:[CommunityCommentModel class] json:info[@"allCommentList"]];
    
    if (resultBlock) resultBlock(@{@"totalCommentCount" : @([info[@"commentSum"] integerValue]) ,
                                   @"hotCommentArray" : hotCommentArray ,
                                   @"allCommentArray" : allCommentArray});
}

@end
