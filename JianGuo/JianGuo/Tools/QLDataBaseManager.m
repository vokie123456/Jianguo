//
//  QLDataBaseManager.m
//  JianGuo
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "QLDataBaseManager.h"
#import "FMDB.h"

@implementation QLDataBaseManager

static FMDatabaseQueue *_queue;

+ (void)setup
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"];
    
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    // 2.创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_chatUser (id integer primary key autoincrement, access_token text, idstr text, status blob);"];
    }];
}


//+(NSDictionary *)cahtUserWithUserId:(NSString *)userId
//{
//    //定义数组
//    __block NSMutableArray *userArr;
//    
//    //使用数据库
//    [_queue inDatabase:^(FMDatabase *db) {
//        
//        // 创建数组
//        userArr = [NSMutableArray array];
//        
//        FMResultSet *rs = nil;
////        if (param.since_id) { // 如果有since_id
////            rs = [db executeQuery:@"select * from t_status where access_token = ? and idstr > ? order by idstr desc limit 0,?;", accessToken, param.since_id, param.count];
////        } else if (param.max_id) { // 如果有max_id
////            rs = [db executeQuery:@"select * from t_status where access_token = ? and idstr <= ? order by idstr desc limit 0,?;", accessToken, param.max_id, param.count];
////        } else { // 如果没有since_id和max_id
////            rs = [db executeQuery:@"select * from t_status where access_token = ? order by idstr desc limit 0,?;", accessToken, param.count];
////        }
//        
//        while (rs.next) {
//            NSData *data = [rs dataForColumn:@"userId"];
//            
//        }
//        
//    }];
//}

@end
