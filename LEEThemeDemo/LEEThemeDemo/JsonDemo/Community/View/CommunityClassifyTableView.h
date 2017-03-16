//
//  CommunityClassifyTableView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommunityAPI.h"

@class CommunityListModel;

@interface CommunityClassifyTableView : UITableView

/**
 打开帖子详情
 */
@property (nonatomic , copy ) void (^openPostDetailsBlock)(CommunityListModel *);

@property (nonatomic , assign ) CommunityListType type;

- (void)loadData;

- (void)deletePost:(NSString *)postId;

@end
