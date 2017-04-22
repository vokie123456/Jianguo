//
//  JGUser.m
//  JianGuo
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JGUser.h"

#define JGUserFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.data"]

@implementation JGUser

//单例模式
+(instancetype)shareUser
{
//    static JGUser *user = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
       JGUser * user = [[self alloc] init];
//    });
    return user;
}

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


+(void)saveUser:(JGUser *)user WithDictionary:(NSDictionary *)dic loginType:(LoginType)loginType 
{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //判断文件是否存在
//    if ([fileManager fileExistsAtPath:JGUserFile]) {//存在就删掉原来的文件
//        [fileManager removeItemAtPath:JGUserFile error:nil];
//    }
    
    
    if (dic) {
        
        user.tel = dic[@"tel"];
        user.qiniuToken = dic[@"qiniu_token"];
        user.qqwx_token = dic[@"qqwx_token"];
        user.token = dic[@"token"];
        user.status = dic[@"auth_status"];
        user.login_id = dic[@"id"];
        user.resume = dic[@"resume"];
        user.iconUrl = dic[@"head_img_url"];
        user.nickname = dic[@"nickname"];
        user.schoolId = dic[@"school_id"];
        user.school_name = dic[@"school_name"];
        user.name = dic[@"name"];
        user.birthDay = dic[@"birth_date"];
        user.introduce = dic[@"introduce"];
        user.is_student = @"1";
        user.height = dic[@"height"];
        user.gender = dic[@"sex"];
        
        /**** 以上为新接口返回字段 ****/
        
        
        
        user.hobby = dic[@"hobby"];
        user.realname = dic[@"realname"];
        user.credit = dic[@"credit"];
        user.integral = dic[@"integral"];
        user.regedit_time = dic[@"regedit_time"];
        user.login_time = dic[@"login_time"];
        if (loginType != 0) {
            user.loginType = loginType;
        }
    }
    
    [NSKeyedArchiver archiveRootObject:user toFile:JGUserFile];
    
}

-(NSString *)tel
{
    return _tel?[NSString stringWithFormat:@"%@",_tel]:nil;
}

+(JGUser *)user
{
    JGUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:JGUserFile];
    if (!user) {
        user = [JGUser shareUser];
        user.login_id = @"0";
    }
    return user;
}

+(void)savePassWord:(NSString *)passWord
{
    JGUser *user = [JGUser user];//这种写法(声明一个新指针)可以,如果直接把 [JGUser user](也就是没有 user 这个指针的方法) 修改不了密码
    user.passWord = passWord;
    [self saveUser:user WithDictionary:nil loginType:0];
    
    
    //这种写法修改不了,因为 [JGUser user] 修改了没保存呢,你就又通过 [JGUser user] 获取一个对象,此时它没被修改,保存也还是原来的 user
//    [JGUser user].passWord = passWord;
//    [self saveUser:[JGUser user] WithDictionary:nil loginType:0];
}

/**
 *  删除本地的用户信息 以达到退出账号效果
 */
+ (void)deleteuser
{
    NSFileManager *fielManager = [[NSFileManager alloc] init];
    NSError *error;
    [fielManager removeItemAtPath:JGUserFile error:&error];
}

MJCodingImplementation

@end


