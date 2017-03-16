//
//  CommunityUserPostCell.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/15.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommunityListModel.h"

@interface CommunityUserPostCell : UITableViewCell

@property (nonatomic , strong ) CommunityListModel *model;

@property (nonatomic , copy ) void (^deleteBlock)(CommunityListModel *model);

@end
