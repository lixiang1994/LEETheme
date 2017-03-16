//
//  CommunityDetailsCommentCellHeaderView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/2.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityDetailsCommentCellHeaderView : UITableViewHeaderFooterView

/**
 *  设置标题
 *
 *  @param title      标题
 *  @param count      数量
 */
- (void)configTitle:(NSString *)title Count:(NSInteger)count;

@end
