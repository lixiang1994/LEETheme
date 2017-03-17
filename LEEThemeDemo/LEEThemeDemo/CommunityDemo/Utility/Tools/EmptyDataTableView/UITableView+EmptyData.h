//
//  UITableView+EmptyData.h
//  MierMilitaryNews
//
//  Created by 李响 on 2017/2/13.
//  Copyright © 2017年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIScrollView+EmptyDataSet.h"

@interface UITableView (EmptyData)<DZNEmptyDataSetSource , DZNEmptyDataSetDelegate>

@property (nonatomic , copy ) NSString *emptyDataPrompt;

@property (nonatomic , strong ) UIImage *emptyDataImage;

@end
