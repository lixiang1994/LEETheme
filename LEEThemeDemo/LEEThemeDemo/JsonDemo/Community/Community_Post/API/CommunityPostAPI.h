//
//  CommunityPostAPI.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/11.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "BaseBlockAPI.h"

@interface CommunityPostAPI : BaseBlockAPI

- (void)uploadImage:(UIImage *)image ResultBlock:(APIRequestResultBlock)resultBlock;

- (void)sendPostDataWithCircleId:(NSString *)circleId
                           Title:(NSString *)title
                         Content:(NSString *)content
                         Address:(NSString *)address
                       Longitude:(CGFloat)longitude
                       Latitude:(CGFloat)latitude
                     ResultBlock:(APIRequestResultBlock)resultBlock;


- (void)loadProvinceDataWithResultBlock:(APIRequestResultBlock)resultBlock;

- (void)loadCityDataWithProvinceId:(NSString *)provinceId ResultBlock:(APIRequestResultBlock)resultBlock;

- (void)loadAreaDataWithCityId:(NSString *)cityId ResultBlock:(APIRequestResultBlock)resultBlock;

@end
