//
//  CommunityHotCircleListView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/27.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommunityCircleModel.h"

@interface CommunityHotCircleListView : UIView

@property (nonatomic , copy ) void (^moreBlock)();

@property (nonatomic , copy ) void (^selectedBlock)(CommunityCircleModel *);

/**
 设置数据

 @param dataArray 数据源数组
 */
- (void)configDataArray:(NSArray<CommunityCircleModel *> *)dataArray;

@end
    
@interface HotCircleItemView : UIView

@property (nonatomic , strong ) CommunityCircleModel *model;

@end
