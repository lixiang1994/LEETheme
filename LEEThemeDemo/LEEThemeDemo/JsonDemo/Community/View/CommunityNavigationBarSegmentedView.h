//
//  CommunityNavigationBarSegmentedView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/24.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityNavigationBarSegmentedView : UIView

@property (nonatomic , strong ) NSArray *dataArray; //数据源数组

@property (nonatomic , assign ) NSInteger selectIndex; //选中按钮下标

@property (nonatomic , copy ) void (^didSelectItemBlock)(NSInteger index); //已经选中选项Block

@end
