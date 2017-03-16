//
//  BaseBlockAPI.m
//  MierMilitaryNews
//
//  Created by liuxin on 15/9/23.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import "BaseBlockAPI.h"

@implementation BaseBlockAPI

#pragma mark - 获取伪造数据

- (NSData *)getFakeDataWithCollection:(id)collection Action:(id)action Attribute:(id)attribute{
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@" , collection , action];
    
    if (attribute) {
        
        fileName = [NSString stringWithFormat:@"%@_%@" , fileName , attribute];
    }
    
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    
    return [NSData dataWithContentsOfFile:filePath];
}

#pragma mark - 加载API POST请求 无缓存

- (void)loadAPIPOSTRequestNoCacheWithURL:(NSString *)url Body:(id)body resultBlock:(APIRequestResultBlock)resultBlock{
    
    // 模拟请求 根据参数获取假数据Json
    
    NSString *collection = body[@"controller"];
    
    NSString *action = body[@"action"];
    
    NSData *fileData = [self getFakeDataWithCollection:collection Action:action Attribute:body[@"page"] ? : body[@"id"]];
    
    if (!fileData) {
        
        fileData = [self getFakeDataWithCollection:collection Action:action Attribute:@"no"];
        
        if (!fileData) {
         
            // 调用Block 传递请求参数 (无数据)
            
            if (resultBlock) resultBlock(RequestResultTypeNoData , nil);
            
            return;
        }
        
    }
    
    // 解析JSON
    
    NSError *jsonError = nil;
    
    id json = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (!jsonError) {
        
        // 调用Block 传递请求参数 (成功)
        
        if (resultBlock) resultBlock(RequestResultTypeSuccess , json);
        
    } else {
        
        // 调用Block 传递请求参数 (错误)
        
        if (resultBlock) resultBlock(RequestResultTypeError , jsonError);
    }

}

#pragma mark - 加载上传API POST请求 没有缓存

- (void)loadAPIPOSTRequestUploadWithURL:(NSString *)url Body:(id)body UploadParams:(id)upParams resultBlock:(APIRequestResultBlock)resultBlock{
    
    // 模拟上传请求成功
    
    return resultBlock(RequestResultTypeSuccess , @"");
}

#pragma mark ---加载API GET请求 无缓存

- (void)loadAPIGETRequestNoCacheWithURL:(NSString *)url resultBlock:(APIRequestResultBlock)resultBlock{
    
    // 解析JSON
    
    NSError *jsonError = nil;
    
    id json = [NSJSONSerialization JSONObjectWithData:[NSData data] options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (!jsonError) {
        
        // 调用Block 传递请求参数 (成功)
        
        if (resultBlock) resultBlock(RequestResultTypeSuccess , json);
        
    } else {
        
        // 调用Block 传递请求参数 (错误)
        
        if (resultBlock) resultBlock(RequestResultTypeError , jsonError);
    }
    
}

@end
