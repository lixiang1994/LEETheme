//
//  ContentImageCacheManager.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/4.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WKWebView+CrashHandle.h"

@interface ContentImageCacheManager : NSObject

+ (void)initData;

+ (NSString *)getCachePath;

+ (NSString *)getCachePath:(NSString *)folder;

+ (NSString *)getImageCachePath;

- (void)loadImage:(NSURL *)url ResultBlock:(void (^)(NSString * ,BOOL))resultBlock;

@end
