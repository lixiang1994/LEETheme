//
//  CommunityEssenceTableView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunityCircleModel , CommunityListModel;

@interface CommunityEssenceTableView : UITableView

/**
 打开圈子列表
 */
@property (nonatomic , copy ) void (^openCircleListBlock)();

/**
 打开圈子详情
 */
@property (nonatomic , copy ) void (^openCircleDetailsBlock)(CommunityCircleModel *);

/**
 打开帖子详情
 */
@property (nonatomic , copy ) void (^openPostDetailsBlock)(CommunityListModel *);

- (void)loadData;

- (void)deletePost:(NSString *)postId;

@end
