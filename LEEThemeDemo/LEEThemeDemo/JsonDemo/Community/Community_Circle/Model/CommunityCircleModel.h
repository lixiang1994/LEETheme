//
//  CommunityCircleModel.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/26.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityCircleModel : NSObject<YYModel>

/**
 圈子Id
 */
@property (nonatomic , copy ) NSString *circleId;

/**
 圈子名称
 */
@property (nonatomic , copy ) NSString *circleName;

/**
 圈子描述
 */
@property (nonatomic , copy ) NSString *circleDescription;

/**
 圈子图标Url
 */
@property (nonatomic , copy ) NSString *circleImageUrl;

/**
 圈子头部图标Url
 */
@property (nonatomic , copy ) NSString *circleHeadImageUrl;

/**
 圈子分组Id
 */
@property (nonatomic , copy ) NSString *circleGroupId;

/**
 圈子分组名称
 */
@property (nonatomic , copy ) NSString *circleGroupName;

/**
 帖子数量
 */
@property (nonatomic , assign ) NSInteger postCount;

@end
