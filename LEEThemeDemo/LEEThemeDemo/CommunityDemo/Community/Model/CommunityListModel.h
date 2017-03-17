//
//  CommunityListModel.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityListModel : NSObject<YYModel>

/**
 作者Id
 */
@property (nonatomic , copy ) NSString *authorId;

/**
 作者名
 */
@property (nonatomic , copy ) NSString *authorName;

/**
 作者头像
 */
@property (nonatomic , copy ) NSString *authorHeadImage;

/**
 作者等级
 */
@property (nonatomic , copy ) NSString *authorLevel;

/**
 圈子Id
 */
@property (nonatomic , copy ) NSString *circleId;

/**
 圈子名字
 */
@property (nonatomic , copy ) NSString *circleName;

/**
 圈子分组Id
 */
@property (nonatomic , copy ) NSString *circleGroupId;

/**
 帖子Id
 */
@property (nonatomic , copy ) NSString *postId;

/**
 帖子标题
 */
@property (nonatomic , copy ) NSString *title;

/**
 帖子摘要
 */
@property (nonatomic , copy ) NSString *abstract;

/**
 位置
 */
@property (nonatomic , copy ) NSString *location;

/**
 时间戳
 */
@property (nonatomic , copy ) NSString *time;

/**
 时间字符串
 */
@property (nonatomic , copy ) NSString *timeString;

/**
 回复数量
 */
@property (nonatomic , assign ) NSInteger commentCount;

/**
 浏览数量
 */
@property (nonatomic , assign ) NSInteger lookCount;

/**
 图片数量
 */
@property (nonatomic , assign ) NSInteger photoCount;

/**
 图片集合
 */
@property (nonatomic , copy ) NSArray *photoList;

#pragma mark - 相关属性

/** 
 收藏时间
 */
@property (nonatomic, strong) NSString *collectTime;

@end
