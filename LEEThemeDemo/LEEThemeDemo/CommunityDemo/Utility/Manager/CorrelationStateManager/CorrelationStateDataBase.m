//
//  CorrelationStateDataBase.m
//  MierMilitaryNews
//
//  Created by 李响 on 16/8/2.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "CorrelationStateDataBase.h"

#import "FMDB.h"

@interface CorrelationStateDataBase ()

@property (nonatomic , strong ) FMDatabaseQueue *queue;

@end

@implementation CorrelationStateDataBase

+(CorrelationStateDataBase *)shareDataBase{
    
    static CorrelationStateDataBase *dataBase;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataBase = [[CorrelationStateDataBase alloc]init];
        
    });
    
    return dataBase;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //创建数据库对象
        
        [self createDB];
        
        //创建数据库表
        
        [self createTable];
        
    }
    return self;
}

#pragma mark - 创建数据库对象

- (void)createDB{
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"CorrelationStateDB.sqlite"];
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
}

#pragma mark - 创建资讯列表的表

- (void)createTable{
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        //创建表
        
        BOOL succeed = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS 't_correlationstate' ('type' TEXT NOT NULL , 'state' TEXT NOT NULL , 'userid' TEXT NOT NULL , 'identifier' TEXT NOT NULL , 'time' TEXT NOT NULL , PRIMARY KEY ('type' , 'state' , 'userid' , 'identifier'));"];
        
        if (succeed){
            
            NSLog(@"创建数据库t_correlationstate成功");
            
        } else {
            
            NSLog(@"创建数据库t_correlationstate失败");
        }
        
    }];
    
}

#pragma mark - 移除数据

-(BOOL)removeDataWithType:(NSInteger)type
                    State:(NSInteger)state
                   UserId:(NSString *)userId
               Identifier:(NSString *)identifier{
    
    __block BOOL succeed = YES;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        succeed = [db executeUpdate:@"DELETE FROM t_correlationstate WHERE type = ? AND state = ? AND userid = ? AND identifier = ?" , [NSNumber numberWithInteger:type] , [NSNumber numberWithInteger:state] , userId ? userId : @"0" , identifier];
        
        if (succeed){
            
            NSLog(@"数据库t_correlationstate删除数据成功");
        
        } else {
            
            NSLog(@"数据库t_correlationstate删除数据失败");
        }
    }];
    
    return succeed;
}

- (void)removeDataWithType:(NSInteger)type
                     State:(NSInteger)state
                    UserId:(NSString *)userId
                       Day:(NSInteger)day{
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        if ([db executeUpdate:@"DELETE FROM t_correlationstate WHERE type = ? AND state = ? AND userid = ? AND time < ?" , [NSNumber numberWithInteger:type] , [NSNumber numberWithInteger:state] , userId ? userId : @"0" , [NSString stringWithFormat:@"%.f", [[NSDate dateWithTimeIntervalSinceNow:-(60 * 60 * 24 * day)] timeIntervalSince1970]]]){
            
            NSLog(@"数据库t_correlationstate删除%ld天前数据成功" , day);
            
        } else {
            
            NSLog(@"数据库t_correlationstate删除%ld天前数据失败" , day);
        }
        
    }];

}

- (void)removeDataWithDay:(NSInteger)day{
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        if ([db executeUpdate:@"DELETE FROM t_correlationstate WHERE time < ?" , [NSString stringWithFormat:@"%.f", [[NSDate dateWithTimeIntervalSinceNow:-(60 * 60 * 24 * day)] timeIntervalSince1970]]]){
            
            NSLog(@"数据库t_correlationstate删除%ld天前数据成功" , day);
            
        } else {
            
            NSLog(@"数据库t_correlationstate删除%ld天前数据失败" , day);
        }
        
    }];
    
}

#pragma mark - 移除全部数据

-(BOOL)removeAllData{
    
    __block BOOL succeed = YES;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        succeed = [db executeUpdate:@"DELETE FROM t_correlationstate"];
        
        if (succeed){
            
            NSLog(@"删除数据库t_correlationstate成功");
            
        } else {
            
            NSLog(@"删除数据库t_correlationstate失败");
        }
        
    }];
    
    return succeed;
}

#pragma mark - 添加数据

-(BOOL)addDataWithType:(NSInteger)type
                 State:(NSInteger)state
                UserId:(NSString *)userId
            Identifier:(NSString *)identifier{
    
    __block BOOL succeed = NO;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        //插入数据 如果存在 则更新
        
        succeed = [db executeUpdate:@"REPLACE INTO 't_correlationstate' ( 'type' , 'state' , 'userid' , 'identifier' , 'time' ) VALUES ( ? , ? , ? , ? , ? );" , [NSNumber numberWithInteger:type] , [NSNumber numberWithInteger:state] , userId ? userId : @"0" , identifier , [NSString stringWithFormat:@"%.f" , [[NSDate date] timeIntervalSince1970]]];
        
        if (succeed){
            
            NSLog(@"数据库t_correlationstate添加数据成功");
            
        } else {
            
            NSLog(@"数据库t_correlationstate添加数据失败");
        }
        
    }];
    
    return succeed;
}

#pragma mark - 检查数据是否存在

- (BOOL)checkDataWithType:(NSInteger)type
                    State:(NSInteger)state
                   UserId:(NSString *)userId
               Identifier:(NSString *)identifier{
    
    __block BOOL result = NO;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:@"SELECT * FROM t_correlationstate WHERE type = ? AND state = ? AND userid = ? AND identifier = ?;" , [NSNumber numberWithInteger:type] , [NSNumber numberWithInteger:state] , userId ? userId : @"0" , identifier];
        
        if ([set next]) {
            
            result = YES;
        }
        
        [set close];
        
    }];
    
    return result;
}

@end
