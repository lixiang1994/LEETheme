//
//  CommunityCommentModel.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/1.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityCommentModel : NSObject<YYModel>

/**
 *  评论ID
 */
@property (nonatomic , copy ) NSString *commentId;

/**
 *  评论内容
 */
@property (nonatomic , copy ) NSString *commentContent;

/**
 *  评论人Id
 */
@property (nonatomic , copy ) NSString *userId;

/**
 *  评论人昵称
 */
@property (nonatomic , copy ) NSString *userName;

/**
 *  评论人头像Url
 */
@property (nonatomic , copy ) NSString *userImg;

/**
 *  评论人等级
 */
@property (nonatomic , assign ) NSInteger userLevel;

/**
 *  点赞数
 */
@property (nonatomic , assign ) NSInteger praiseCount;

/**
 *  楼层
 */
@property (nonatomic , copy ) NSString *floor;

/**
 *  发表时间 (时间字符串)
 */
@property (nonatomic , copy ) NSString *publishTime;

/**
 *  回复数组
 */
@property (nonatomic , strong ) NSArray *replysArray;

/**
 审核状态
 
 0 审核不通过，如果是自己的评论，则显示，不是自己的评论则不显示
 1 通过，显示
 2 删除，有子评论显示，无子评论则不显示
 */
@property (nonatomic , assign ) NSInteger checkState;

#pragma mark - 扩展属性

/**
 *  是否赞
 */
@property (nonatomic , assign ) BOOL isPraise;

/**
 *  是否显示全部回复
 */
@property (nonatomic , assign ) BOOL isShowAllReply;

/**
 *  是否显示全部内容
 */
@property (nonatomic , assign ) BOOL isShowAllContent;

@end
