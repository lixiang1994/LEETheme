//
//  CommunityCircleAPI.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/26.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityCircleAPI.h"

@implementation CommunityCircleAPI

- (void)loadCircleListDataResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"CommunityCircle" forKey:@"controller"];
    
    [params setValue:@"List" forKey:@"action"];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

- (void)analyticalCircleListDataWithData:(id)data ResultBlock:(void(^)(NSMutableArray *))resultBlock{
    
    if (!data) return;
    
    NSMutableArray *tempDataArray = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[CommunityCircleModel class] json:data[@"data"]]];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    //循环遍历 将分组ID相同的模型放到同一个数组中
    
    for (NSInteger i = 0; i < tempDataArray.count; i ++) {
        
        CommunityCircleModel *item = tempDataArray[i];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        [tempArray addObject:item];
        
        for (NSInteger j = i + 1 ; j < tempDataArray.count; j ++) {
            
            CommunityCircleModel *itemX = tempDataArray[j];
            
            if([item.circleGroupId isEqualToString: itemX.circleGroupId]){
                
                [tempArray addObject:itemX];
                
                [tempDataArray removeObjectAtIndex:j];
                
                j -- ;
            }
            
        }
        
        [dataArray addObject:tempArray];
    }

    if (resultBlock) resultBlock(dataArray);
}

- (void)loadCircleDetailsDataWithCircleId:(NSString *)circleId Page:(NSInteger)page Type:(NSString *)type ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"CommunityCircle" forKey:@"controller"];
    
    [params setValue:@"Details" forKey:@"action"];
    
    [params setValue:circleId forKey:@"id"];
    
//    [params setValue:@(page) forKey:@"page"]; // 模拟数据 只为了演示 不考虑分页了
    
    [params setValue:@10 forKey:@"limit"];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

- (void)analyticalCircleDetailsDataWithData:(id)data ResultBlock:(void(^)(NSDictionary *))resultBlock{
    
    CommunityCircleModel *model = [CommunityCircleModel modelWithJSON:data[@"data"][@"circleInfo"]];
    
    NSArray *postArray = [NSArray modelArrayWithClass:[CommunityListModel class] json:data[@"data"][@"newsList"]];
    
    if (resultBlock) resultBlock(model ? @{@"circleInfo" : model, @"postArray" : postArray} : nil);
}

@end
