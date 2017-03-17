//
//  CommunityCommentListAPI.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/1.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "BaseBlockAPI.h"

#import "CommunityCommentModel.h"

@interface CommunityCommentListAPI : BaseBlockAPI

//加载列表

- (void)loadCommentListDataWithID:(NSString *)postId CircleId:(NSString *)circleId Page:(NSInteger)page ResultBlock:(APIRequestResultBlock)resultBlock;

/**
 解析数据
 
 @param resultBlock 结果回调Block
 */
- (void)analyticalCommentListDataWithData:(id)data ResultBlock:(void(^)(NSDictionary *))resultBlock;

@end
