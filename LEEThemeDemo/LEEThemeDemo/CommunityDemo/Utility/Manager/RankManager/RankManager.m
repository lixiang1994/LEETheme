//
//  RankManager.m
//  LEEThemeDemo
//
//  Created by 李响 on 2017/3/16.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "RankManager.h"

@implementation RankManager

+ (NSArray *)rankImageArray{

    static NSArray *rankImageArray;
    
    if (!rankImageArray) {
        
        NSArray *objArray = @[@"biz_military_rank1",@"biz_military_rank2",@"biz_military_rank3",@"biz_military_rank4",@"biz_military_rank5",@"biz_military_rank6",@"biz_military_rank7",@"biz_military_rank8",@"biz_military_rank9",@"biz_military_rank10",@"biz_military_rank11",@"biz_military_rank12",@"biz_military_rank13",@"biz_military_rank14",@"biz_military_rank15",@"biz_military_rank16",@"biz_military_rank17",@"biz_military_rank18",@"biz_military_rank19"];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (int i = 1; i <= objArray.count; i ++) {
            
            [tempArray addObject:[NSString stringWithFormat:@"%@%d.png", @"http://pic.wap.miercn.com/api/images/rank/biz_military_rank", i]];
        }
        
        rankImageArray = [NSArray arrayWithArray:tempArray];
    }

    return rankImageArray;
}

+ (NSArray *)rankNameArray{
    
    static NSArray *rankNameArray;
    
    if (!rankNameArray) {
        
        rankNameArray = @[@"列兵",@"下士",@"中士",@"上士",@"四级军士长",@"三级军士长",@"二级军士长",@"一级军士长",@"少尉",@"中尉",@"上尉",@"少校",@"中校",@"上校",@"大校",@"少将",@"中将",@"上将",@"元帅"];
    }
    
    return rankNameArray;
}

+ (NSArray *)rankIntegralArray{
    
    static NSArray *rankIntegralArray;
    
    if (!rankIntegralArray) {
        
        rankIntegralArray = @[@"0",@"30",@"70",@"200",@"400",@"1000",@"1600",@"2400",@"3200",@"4200",@"5200",@"6400",@"8000",@"9600",@"11200",@"14600",@"21900",@"29200",@"36500"];
    }
    
    return rankIntegralArray;
}

@end
