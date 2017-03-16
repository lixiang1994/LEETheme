//
//  CommunityAPI.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "BaseBlockAPI.h"

#import "CommunityListModel.h"

#import "CommunityCircleModel.h"

/**
 社区列表类型
 */
typedef NS_ENUM(NSInteger, CommunityListType) {
    
    /** 社区类型精华 */
    CommunityListTypeEssence,
    
    /** 社区类型最新 */
    CommunityListTypeNewest,
    
    /** 社区类型附近 */
    CommunityListTypeNearby,
};

@interface CommunityAPI : BaseBlockAPI

/**
 加载指定页数数据
 
 @param page        页数
 @param resultBlock 结果回调Block
 */
- (void)loadDataWithPage:(NSInteger)page Type:(CommunityListType)type ResultBlock:(APIRequestResultBlock)resultBlock;

/**
 解析数据
 
 @param resultBlock 结果回调Block
 */
- (void)analyticalDataWithData:(id)data ResultBlock:(void(^)(NSDictionary *))resultBlock;

@end
