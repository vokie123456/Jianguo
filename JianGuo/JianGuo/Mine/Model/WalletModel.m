//
//  WalletModel.m
//  JianGuo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "WalletModel.h"

#define JGWallet [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"wallet.data"]

@implementation WalletModel


+ (instancetype)userWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


+(void)saveWallet:(WalletModel *)wallet
{
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    //判断文件是否存在
    //    if ([fileManager fileExistsAtPath:JGUserFile]) {//存在就删掉原来的文件
    //        [fileManager removeItemAtPath:JGUserFile error:nil];
    //    }
    
    [NSKeyedArchiver archiveRootObject:wallet toFile:JGWallet];
    
}



+(WalletModel *)wallet
{
    WalletModel *wallet = [NSKeyedUnarchiver unarchiveObjectWithFile:JGWallet];
    return wallet;
}
MJExtensionCodingImplementation

@end
