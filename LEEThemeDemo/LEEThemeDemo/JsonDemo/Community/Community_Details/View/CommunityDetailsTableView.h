//
//  CommunityDetailsTableView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/28.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommunityDetailsModel.h"

@class CommunityCommentModel;

typedef void(^OpenUserHomeVCBlock)(NSString *uid , NSString *userName);

typedef void(^OpenReplyBlock)(CommunityCommentModel *commentModel , NSString *placeholder);

@interface CommunityDetailsTableView : UITableView

@property (nonatomic , copy ) OpenReplyBlock openReplyBlock;//打开回复Block

@property (nonatomic , copy ) OpenUserHomeVCBlock openUserHomeBlock; //打开用户主页Block

@property (nonatomic , strong ) CommunityDetailsModel *model; //社区详情数据模型

@property (nonatomic , copy ) void (^scrollBlock)(CGPoint contentOffset); //列表滑动Block

/**
 发送评论

 @param comment     评论内容
 @param rootComment 所属评论
 @param resultBlock 结果回调Block
 */
- (void)sendComment:(NSString *)comment RootComment:(CommunityCommentModel *)rootComment ResultBlock:(void (^)(BOOL))resultBlock;

@end
