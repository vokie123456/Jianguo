//
//  JianliAccount.m
//  JianGuo
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JianliAccount.h"

#define JIANLIACCOUNTFILE [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"JLAcount.data"]

@implementation JianliAccount

//单例模式
+(instancetype)shareJianLiAccount
{
    JianliAccount *jianliAccount = [[JianliAccount alloc] init];
    return jianliAccount;
}

+(void)saveAccountWithDictionary:(NSDictionary *)dic
{
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    //判断文件是否存在
    //    if ([fileManager fileExistsAtPath:JGUserFile]) {//存在就删掉原来的文件
    //        [fileManager removeItemAtPath:JGUserFile error:nil];
    //    }
    
    
    JianliAccount *account = [JianliAccount mj_objectWithKeyValues:dic];
    
    [NSKeyedArchiver archiveRootObject:account toFile:JIANLIACCOUNTFILE];
    
}
+(JianliAccount *)account
{
    JianliAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:JIANLIACCOUNTFILE];
    return account;
}
MJCodingImplementation

@end
