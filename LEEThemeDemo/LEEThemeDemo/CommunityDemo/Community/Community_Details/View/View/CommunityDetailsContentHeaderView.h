//
//  CommunityDetailsContentHeaderView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/7.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommunityDetailsModel.h"

@interface CommunityDetailsContentHeaderView : UIView

@property (nonatomic , copy ) void (^openUserHomeBlock)();

@property (nonatomic , strong ) CommunityDetailsModel *model;

@end
