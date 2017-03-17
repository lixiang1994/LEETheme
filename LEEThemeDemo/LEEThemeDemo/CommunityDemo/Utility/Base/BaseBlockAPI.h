//
//  BaseBlockAPI.h
//  MierMilitaryNews
//
//  Created by liuxin on 15/9/23.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

/**
 * 网络请求结果类型
 */
typedef enum : NSUInteger  {
    
    /**
        无网络
     */
    
    RequestResultTypeNetWorkStatusNone,
    
    /**
        无数据
     */
    
    RequestResultTypeNoData,
    
    /**
        请求错误
     */
    
    RequestResultTypeError,
    
    /**
        请求成功
     */
    
    RequestResultTypeSuccess,
    
} RequestResultType;

typedef void (^APIRequestResultBlock)(RequestResultType requestResultType , id responseObject);

@interface BaseBlockAPI : NSObject

/** 加载API POST请求 无缓存 */
- (void)loadAPIPOSTRequestNoCacheWithURL:(NSString *)url Body:(id)body resultBlock:(APIRequestResultBlock)resultBlock;

/** 加载API GET请求 无缓存 */
- (void)loadAPIGETRequestNoCacheWithURL:(NSString *)url resultBlock:(APIRequestResultBlock)resultBlock;

/** 加载上传API POST请求 没有缓存 */
- (void)loadAPIPOSTRequestUploadWithURL:(NSString *)url Body:(id)body UploadParams:(id)upParams resultBlock:(APIRequestResultBlock)resultBlock;

@end
