//
//  CommunityAPI.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityAPI.h"

@implementation CommunityAPI

- (void)loadDataWithPage:(NSInteger)page Type:(CommunityListType)type ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"CommunityList" forKey:@"controller"];
    
    NSString *action = nil;
    
    switch (type) {
            
        case CommunityListTypeEssence:
            
            action = @"Essence";
            
            break;
            
        case CommunityListTypeNewest:
            
            action = @"Newest";
            
            break;
            
        case CommunityListTypeNearby:
            
            action = @"Nearby";
            
            break;
            
        default:
            
            action = @"Newest";
            
            break;
    }
    
    [params setValue:action forKey:@"action"];
    
    [params setValue:@(page) forKey:@"page"];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

- (void)analyticalDataWithData:(id)data ResultBlock:(void(^)(NSDictionary *))resultBlock{
    
    if (data) {
        
        NSArray *circleArray = [NSArray modelArrayWithClass:[CommunityCircleModel class] json:data[@"data"][@"boardList"]];
        
        NSArray *postArray = [NSArray modelArrayWithClass:[CommunityListModel class] json:data[@"data"][@"newsList"]];
        
        NSDictionary *result;
        
        if (circleArray) {
            
            result = @{@"circleArray" : circleArray , @"postArray" : postArray};
            
        } else {
            
            result = @{@"postArray" : postArray};
        }
        
        if (resultBlock) resultBlock(result);
    }
    
}

@end
