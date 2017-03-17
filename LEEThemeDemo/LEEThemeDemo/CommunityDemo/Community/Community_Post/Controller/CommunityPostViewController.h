//
//  CommunityPostViewController.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "BaseViewController.h"

#import "CommunityCircleModel.h"

@interface CommunityPostViewController : BaseViewController

@property (nonatomic , strong ) CommunityCircleModel *circleModel; //圈子数据模型

@property (nonatomic , copy ) void (^postSuccessBlock)(); //发帖成功Block

@end
