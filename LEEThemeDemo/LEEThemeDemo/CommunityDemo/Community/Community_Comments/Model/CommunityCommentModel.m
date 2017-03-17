//
//  CommunityCommentModel.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/11/1.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CommunityCommentModel.h"

@implementation CommunityCommentModel

// 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }
- (NSUInteger)hash { return [self modelHash]; }
- (BOOL)isEqual:(id)object { return [self modelIsEqual:object]; }
- (NSString *)description { return [self modelDescription]; }

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    
    return @{
             @"commentId" : @"commentId" ,
             @"commentContent" : @"content" ,
             @"userId" : @"userId" ,
             @"userName" : @"userName" ,
             @"userImg" : @"userImg" ,
             @"userLevel" : @"level" ,
             @"praiseCount" : @"laud" ,
             @"publishTime" : @"publishTime" ,
             @"replysArray" : @"replys"
             };
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    
    }
    return self;
}

@end
