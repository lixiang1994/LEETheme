//
//  CommunityMyPostTableView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/9.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommunityUserPostAPI.h"

@interface CommunityUserPostTableView : UITableView

@property (nonatomic , copy ) void (^openPostDetailsBlock)(CommunityListModel *); //打开帖子详情

@property (nonatomic , copy ) void (^scrollBlock)(CGPoint contentOffset); //列表滑动Block

@property (nonatomic , strong ) NSString *userId;

@property (nonatomic , assign ) BOOL isHeaderRefresh; //是否头部刷新

- (void)loadData;

- (void)deletePost:(NSString *)postId;

@end
