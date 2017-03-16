//
//  CommunityDetailsModel.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/28.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommunityCircleModel.h"

@interface CommunityDetailsModel : NSObject

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
 圈子模型
 */
@property (nonatomic , copy ) CommunityCircleModel *circleModel;

/**
 帖子Id
 */
@property (nonatomic , copy ) NSString *postId;

/**
 帖子标题
 */
@property (nonatomic , copy ) NSString *title;

/**
 位置
 */
@property (nonatomic , copy ) NSString *location;

/**
 时间戳
 */
@property (nonatomic , copy ) NSString *time;

/**
 图片集合 (兼容旧版本图片处理使用)
 */
@property (nonatomic , copy ) NSArray *photoArray;

/**
 点赞数量
 */
@property (nonatomic , assign ) NSInteger praiseCount;

/**
 帖子内容
 */
@property (nonatomic , copy ) NSString *content;

/**
 分享图片Url
 */
@property (nonatomic , copy ) NSString *shareImageUrl;

/**
 分享Url
 */
@property (nonatomic , copy ) NSString *shareUrl;

/**
 分享微信Url
 */
@property (nonatomic , copy ) NSString *shareWeChatUrl;

/**
 是否为新版本帖子
 */
@property (nonatomic , copy ) NSString *isNewVersion;

/**
 关注状态 0 不存在关注关系 , 1 已关注 , 2 未关注(对方关注了自己 自己没关注他) , 3 相互关注 , 4 是自己
 */
@property (nonatomic , assign ) NSInteger followState;

@end
