//
//  CommunityCircleModel.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/26.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityCircleModel.h"

@implementation CommunityCircleModel

// 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }
- (NSUInteger)hash { return [self modelHash]; }
- (BOOL)isEqual:(id)object { return [self modelIsEqual:object]; }
- (NSString *)description { return [self modelDescription]; }

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    
    return @{
             @"circleId" : @"fid" ,
             
             @"circleName" : @"name" ,
             
             @"circleDescription" : @"description" ,
             
             @"circleImageUrl" : @"img" ,
             
             @"circleHeadImageUrl" : @"headimg" ,
             
             @"circleGroupId" : @"groupid" ,
             
             @"circleGroupName" : @"groupname" ,
             
             @"postCount" : @"threads"
             
             };
}

@end
