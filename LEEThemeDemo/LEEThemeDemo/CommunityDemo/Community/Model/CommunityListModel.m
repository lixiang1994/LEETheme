//
//  CommunityListModel.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/25.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityListModel.h"

@implementation CommunityListModel

// 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }
- (NSUInteger)hash { return [self modelHash]; }
- (BOOL)isEqual:(id)object { return [self modelIsEqual:object]; }
- (NSString *)description { return [self modelDescription]; }

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    
    return @{@"authorId" : @"authorId" ,
             @"authorName" : @"author" ,
             @"authorHeadImage" : @"authorHead" ,
             @"authorLevel" : @"level" ,
             @"circleId" : @"fid" ,
             @"circleName" : @"circleName" ,
             @"circleGroupId" : @"groupid" ,
             @"postId" : @"tid" ,
             @"title" : @"title" ,
             @"abstract" : @"newsAbstract" ,
             @"location" : @"location" ,
             @"time" : @"publishTime" ,
             @"timeString" : @"timeAgo" ,
             @"commentCount" : @"replies" ,
             @"lookCount" : @"views" ,
             @"photoCount" : @"picCount" ,
             @"photoList" : @"picList"};
}

@end
