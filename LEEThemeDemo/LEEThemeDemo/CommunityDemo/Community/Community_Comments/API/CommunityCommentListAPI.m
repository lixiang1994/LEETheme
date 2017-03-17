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
    
    NSString *url = [NSString stringWithFormat:@"http://api.bbs.miercn.com/api/index.php?controller=comment&action=index&tid=%@&fid=%@&page=%@&app_version=2.5.2&versioncode=20170303" , postId , circleId , @(page)];
    
    [self loadAPIGETRequestNoCacheWithURL:url resultBlock:resultBlock];
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
