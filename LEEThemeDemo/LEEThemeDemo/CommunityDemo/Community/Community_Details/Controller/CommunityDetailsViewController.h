//
//  CommunityDetailsViewController.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/27.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "BaseViewController.h"

#import "CommunityListModel.h"

@interface CommunityDetailsViewController : BaseViewController

@property (nonatomic , copy ) NSString *postId;

@property (nonatomic , copy ) NSString *circleId;

@property (nonatomic , copy ) void (^deleteBlock)(NSString *postId); //删除Block

@end
