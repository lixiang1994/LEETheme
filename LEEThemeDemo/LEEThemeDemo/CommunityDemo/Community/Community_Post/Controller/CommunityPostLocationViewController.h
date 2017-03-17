//
//  CommunityPostLocationViewController.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/11.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface CommunityPostLocationViewController : BaseViewController

@property (nonatomic , strong ) void (^currentLocationBlock)();

@property (nonatomic , strong ) void (^selectedBlock)(NSString * , NSString * , NSString *);

@end
