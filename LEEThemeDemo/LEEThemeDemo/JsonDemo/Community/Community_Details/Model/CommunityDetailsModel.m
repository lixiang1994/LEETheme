//
//  CommunityDetailsModel.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/28.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityDetailsModel.h"

@implementation CommunityDetailsModel

// 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }
- (NSUInteger)hash { return [self modelHash]; }
- (BOOL)isEqual:(id)object { return [self modelIsEqual:object]; }
- (NSString *)description { return [self modelDescription]; }

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    
    return @{
             @"authorId" : @"authorId" ,
             
             @"authorName" : @"author" ,
             
             @"authorHeadImage" : @"userImg" ,
             
             @"authorLevel" : @"level" ,
             
             @"circleModel" : @"circleInfo" ,
             
             @"postId" : @"tid" ,
             
             @"title" : @"title" ,
             
             @"location" : @"location" ,
             
             @"time" : @"publishTime" ,
             
             @"commentCount" : @"replies" ,
             
             @"lookCount" : @"views" ,
             
             @"photoArray" : @"imgArr" ,
             
             @"content" : @"webContent" ,
             
             @"praiseCount" : @"laud" ,
             
             @"followState" : @"follow" ,
             
             @"shareImageUrl" : @"shareImg" ,
             
             @"shareUrl" : @"shareUrl" ,
             
             @"shareWeChatUrl" : @"shareUrl_wx" ,
             
             @"isNewVersion" : @"isNewVersion"
             
             };
}

@end
