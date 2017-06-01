//
//  NewThemeTableViewCell.h
//  LEEThemeDemo
//
//  Created by 李响 on 2017/6/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NewThemeState) {
    
    NewThemeStateDownload,
    
    NewThemeStateStart,
    
    NewThemeStateRemove
};

@interface NewThemeTableViewCell : UITableViewCell

@property (nonatomic , strong ) NSDictionary *info;

@property (nonatomic , copy ) void (^clickBlock)(NewThemeTableViewCell * ,NewThemeState);

// 检查主题状态

- (void)checkThemeState;

@end
