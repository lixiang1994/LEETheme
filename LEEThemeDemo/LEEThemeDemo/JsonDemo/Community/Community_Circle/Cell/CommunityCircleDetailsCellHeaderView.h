//
//  CommunityCircleDetailsCellHeaderView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/27.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityCircleDetailsCellHeaderView : UITableViewHeaderFooterView

@property (nonatomic , copy ) void (^selectedNewestBlock)();

@property (nonatomic , copy ) void (^selectedLastReplyBlock)();

/**
 *  设置数据
 *
 *  @param postCount  帖子数量
 *  @param isShowSort 是否显示排序按钮
 */
- (void)configPostCount:(NSInteger)postCount WithIsShowSort:(BOOL)isShowSort;

/**
 *  选中最新发表
 */
- (void)selectedNewest;

/**
 *  选中最后回复
 */
- (void)selectedLastReply;

@end

@interface CommunityCircleDetailsCellHeaderSortView : UIView

- (void)selectedNewest;

- (void)selectedLastReply;

@property (nonatomic , copy ) void (^selectedNewestBlock)();

@property (nonatomic , copy ) void (^selectedLastReplyBlock)();

@end
