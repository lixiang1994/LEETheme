//
//  CommunityPostCell.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommunityListModel.h"

@interface CommunityPostCell : UITableViewCell

@property (nonatomic , strong ) CommunityListModel *model;

@property (nonatomic , assign ) BOOL isShowCircle;

@end
