/*
 *  @header LEEThemeImageCache.m
 *
 *  ┌─┐      ┌───────┐ ┌───────┐
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ │      │ └─────┐ │ └─────┐
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ └─────┐│ └─────┐ │ └─────┐
 *  └───────┘└───────┘ └───────┘
 *
 *  @brief  LEE主题管理
 *
 *  @author LEE
 *  @copyright    Copyright © 2016 - 2024年 lee. All rights reserved.
 *  @version    V1.2.2
 */

#import "LEEThemeImageCache.h"

@interface LEEThemeImageCache ()

@property (nonatomic , strong ) NSMutableDictionary *cache;

@end

@implementation LEEThemeImageCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (UIImage *)getImageWithKey:(NSString *)key {
    return self.cache[key];
}

- (void)setImage:(UIImage *)image withKey:(NSString *)key {
    self.cache[key] = image;
}

- (void)clean {
    [self.cache removeAllObjects];
}

@end
