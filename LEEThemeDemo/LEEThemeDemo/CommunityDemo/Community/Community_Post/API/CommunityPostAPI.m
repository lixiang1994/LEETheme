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
    
    // 模拟请求成功
    
    if (resultBlock) resultBlock(RequestResultTypeSuccess , nil);
}

#pragma mark - 地址

- (void)loadProvinceDataWithResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"http://api.wap.miercn.com/shop/index.php?controller=address&action=province&app_version=2.5.2&versioncode=20170303"];
    
    [self loadAPIGETRequestNoCacheWithURL:url resultBlock:resultBlock];
}

- (void)loadCityDataWithProvinceId:(NSString *)provinceId ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"http://api.wap.miercn.com/shop/index.php?controller=address&action=city&province_id=%@&app_version=2.5.2&versioncode=20170303" , provinceId];
    
    [self loadAPIGETRequestNoCacheWithURL:url resultBlock:resultBlock];
}

- (void)loadAreaDataWithCityId:(NSString *)cityId ResultBlock:(APIRequestResultBlock)resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"http://api.wap.miercn.com/shop/index.php?controller=address&action=county&city_id=%@&app_version=2.5.2&versioncode=20170303" , cityId];
    
    [self loadAPIGETRequestNoCacheWithURL:url resultBlock:resultBlock];
}

@end
