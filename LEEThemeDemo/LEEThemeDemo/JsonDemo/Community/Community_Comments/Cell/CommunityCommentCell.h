//
//  CommunityCommentCell.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/1.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunityCommentModel , CommunityCommentCell;

typedef void(^OpenUserHomeBlock)(CommunityCommentModel *commentModel);

typedef void(^PraiseBlock)(CommunityCommentModel *model , CommunityCommentCell *);

typedef void(^DeleteBlock)(CommunityCommentModel *model);

typedef void(^reloadCellBlock)();

@interface CommunityCommentCell : UITableViewCell

@property (nonatomic , copy ) reloadCellBlock reloadCellBlock; //刷新CellBlock

@property (nonatomic , copy ) OpenUserHomeBlock openUserHomeBlock; //打开用户主页

@property (nonatomic , copy ) PraiseBlock praiseBlock; //赞评论

@property (nonatomic , copy ) DeleteBlock deleteBlock; //删除评论

@property (nonatomic , strong ) CommunityCommentModel *model; //数据模型

@property (nonatomic , assign ) BOOL isMaster; //是否为楼主

/**
 *  检测点赞状态
 */
- (void)checkPraise;

/**
 *  点赞
 */
- (void)praiseClick;

/**
 *  更新赞数
 */
-(void)updatePraiseCount;

@end
