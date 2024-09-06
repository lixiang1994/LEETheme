/*
 *  @header LEEThemeImageCache.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEEThemeImageCache : NSObject

- (UIImage *)getImageWithKey:(NSString *)key;

- (void)setImage:(UIImage *)image withKey:(NSString *)key;

- (void)clean;

@end

NS_ASSUME_NONNULL_END
