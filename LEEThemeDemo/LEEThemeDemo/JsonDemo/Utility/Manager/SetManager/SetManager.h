//
//  SetManager.h
//  LEEThemeDemo
//
//  Created by 李响 on 2017/3/16.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTIFICATION_FONTSIZE @"NOTIFICATION_FONTSIZE" //通知 - 字体尺寸更改

@interface SetManager : NSObject

+ (SetManager *)shareManager;

/**
 正文字号等级
 */
@property (nonatomic , assign ) NSInteger fontSizeLevel;

@end
