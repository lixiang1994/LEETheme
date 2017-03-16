//
//  CommunityDetailsContentFooterView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/7.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommunityDetailsModel.h"

@interface CommunityDetailsContentFooterView : UIView

@property (nonatomic , copy ) void (^praiseBlock)();

@property (nonatomic , copy ) void (^deleteBlock)();

@property (nonatomic , strong ) CommunityDetailsModel *model;

/**
 *  点赞状态
 *
 *  @param success 成功 or 失败
 */
- (void)praiseState:(BOOL)success;

@end
