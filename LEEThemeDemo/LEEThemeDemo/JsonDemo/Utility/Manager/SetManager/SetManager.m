//
//  SetManager.m
//  LEEThemeDemo
//
//  Created by 李响 on 2017/3/16.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "SetManager.h"

@implementation SetManager

+ (SetManager *)shareManager{
    
    static SetManager *manager;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[SetManager alloc] init];
    });
    
    return manager;
}
#pragma mark - 设置字号

- (void)setFontSizeLevel:(NSInteger)fontSizeLevel{
    
    [[NSUserDefaults standardUserDefaults] setInteger:fontSizeLevel forKey:@"ud_fontSizeLevel"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //发送通知 修改字号
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FONTSIZE object:nil];
}

- (NSInteger)fontSizeLevel{
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ud_fontSizeLevel"];
}

@end
