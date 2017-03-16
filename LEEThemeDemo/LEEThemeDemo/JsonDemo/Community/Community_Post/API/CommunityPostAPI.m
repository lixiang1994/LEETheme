//
//  CommunityPostAPI.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/11.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityPostAPI.h"

@implementation CommunityPostAPI

- (void)uploadImage:(UIImage *)image ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"Thread" forKey:@"controller"];
    
    [params setValue:@"imgUpload" forKey:@"action"];
    
    [self loadAPIPOSTRequestUploadWithURL:@"CommunityPostAPI" Body:params UploadParams:@{@"img" : [image imageDataRepresentation]} resultBlock:resultBlock];
}

- (void)sendPostDataWithCircleId:(NSString *)circleId
                           Title:(NSString *)title
                         Content:(NSString *)content
                         Address:(NSString *)address
                       Longitude:(CGFloat)longitude
                        Latitude:(CGFloat)latitude
                     ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"Thread" forKey:@"controller"];
    
    [params setValue:@"postThread" forKey:@"action"];
    
    [params setValue:circleId forKey:@"fid"];
    
    [params setValue:title forKey:@"subject"];
    
    [params setValue:content forKey:@"message"];
    
    [params setValue:address forKey:@"address"];
    
    [params setValue:@(longitude) forKey:@"longitude"];
    
    [params setValue:@(latitude) forKey:@"latitude"];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

#pragma mark - 地址

- (void)loadProvinceDataWithResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"Address" forKey:@"controller"];
    
    [params setValue:@"province" forKey:@"action"];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

- (void)loadCityDataWithProvinceId:(NSString *)provinceId ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"Address" forKey:@"controller"];
    
    [params setValue:@"city" forKey:@"action"];
    
    [params setValue:provinceId forKey:@"province_id"];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

- (void)loadAreaDataWithCityId:(NSString *)cityId ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"Address" forKey:@"controller"];
    
    [params setValue:@"county" forKey:@"action"];
    
    [params setValue:cityId forKey:@"city_id"];
    
    [self loadAPIPOSTRequestNoCacheWithURL:@"" Body:params resultBlock:resultBlock];
}

@end
