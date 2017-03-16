//
//  CommunityCircleListViewController.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "BaseViewController.h"

#import "CommunityCircleModel.h"

@interface CommunityCircleListViewController : BaseViewController

/**
 选择Block
 */
@property (nonatomic , copy ) void (^selectedBlock)(CommunityCircleModel *);

/**
 是否选择
 */
@property (nonatomic , assign ) BOOL isSelect;

@end
