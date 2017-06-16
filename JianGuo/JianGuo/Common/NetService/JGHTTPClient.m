//
//  JGHTTPClient.m
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JGHTTPClient.h"
#import "NSString+MD5Addition.h"
#import "FMDB.h"

@interface JGHTTPClient()
@property (nonatomic,strong) NSDateFormatter *formatter;

@end

@implementation JGHTTPClient

static FMDatabaseQueue *_queue;

-(NSFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyyMMddHH"];
        [_formatter setLocale:[NSLocale currentLocale]];
    }
    return _formatter;
}

//+ (instancetype)sharedManager {
//    static JGHTTPClient *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@""]];
//    });
//    return manager;
//}

+ (instancetype)sharedManager {
    static JGHTTPClient *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    return manager;
}


-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        
//        self.requestSerializer = [AFJSONRequestSerializer serializer];//请求
        // 请求超时设定
        self.requestSerializer.timeoutInterval = 15;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
//        self.responseSerializer = [AFJSONResponseSerializer serializer];//设置以后收到的返回数据就是没有经过解析的二进制data数据
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/javascript", @"text/json", @"text/html", nil];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

/**
 *  发起请求的公用方法
 *
 */

+(void)startRequestWithUrl:(NSString *)url params:(NSMutableDictionary *)params
{
    
}

/**
    获取兼职信息
 */
+ (void)getInfoOfPartJob:(int)count
            GameZoneType:(int)type
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[JGHTTPClient sharedManager] POST:@"http://120.24.97.113/JianGuo3/app/list/getHotJobs" parameters:params success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];

}
/**
 获取 聊天用户信息
 */
+ (void)getChatUserInfoByLoginId:(NSString *)loginId
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_UserChat_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 获取 多个聊天用户信息
 */
+ (void)getGroupChatUserInfoByLoginId:(NSString *)loginIds
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];

    [params setObject:loginIds forKey:@"ids"];
    
    [params setObject:userType forKey:@"type"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/im"];
    
    [[JGHTTPClient sharedManager] GET:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /*
        if ([responseObject[@"code"]intValue] == 200) {
            
            NSArray *arr = responseObject[@"data"];
            
            for (NSDictionary *dic in arr) {
                
                [self setup];
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                
                [_queue inDatabase:^(FMDatabase *db) {
                    
                    NSMutableArray *userIdArr = [NSMutableArray array];
                    
                    FMResultSet *rs = nil;
                    
                    rs = [db executeQuery:@"select * from t_chatUser"];
                    
                    while (rs.next) {
                        
                        NSString *userId = [rs stringForColumn:@"userId"];
                        [userIdArr addObject:userId];
                    }
                    if (![userIdArr containsObject:[dic objectForKey:@"userId"]]) {
                        
                        // 存储数据
                        BOOL result = [db executeUpdate:@"insert into t_chatUser (userId, chatUserDic) values(?, ?)", [dic objectForKey:@"userId"], data];
                        JGLog(@"%d",result);
                    }
                }];
                
            }
            
        }*/
        if (success) {
            if ([responseObject[@"code"] integerValue] == 600) {
                [self showAlertViewWithText:responseObject[@"message"] duration:1];
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /*
        [self setup];
        
        // 1.定义数组
        __block NSMutableArray *userArr = nil;
        
        // 2.使用数据库
        [_queue inDatabase:^(FMDatabase *db) {
            // 创建数组
            userArr = [NSMutableArray array];
            
            
            FMResultSet *rs = nil;
            
            rs = [db executeQuery:@"select * from t_chatUser"];
            
            while (rs.next) {
                
                NSData *data = [rs dataForColumn:@"chatUserDic"];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [userArr addObject:dic];
            }
        }];
        [_queue close];
        
        NSMutableDictionary *responseObject = [NSMutableDictionary dictionary];
        [responseObject setObject:@"200" forKey:@"code"];
        [responseObject setObject:userArr forKey:@"data"];
        success(responseObject);
         */
        
    }];
}


/**
 获取 多个聊天用户信息
 */
+ (void)getGroup222ChatUserInfoByLoginId:(NSString *)loginId
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    NSString *Url = [@"http://v3.jianguojob.com:8080/" stringByAppendingString:@"T_UserGroup_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        if ([responseObject[@"code"]intValue] == 200) {
//            
//            NSArray *arr = responseObject[@"data"];
//            
//            for (NSDictionary *dic in arr) {
//                
//                [self setup];
//                
//                NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//                
//                [_queue inDatabase:^(FMDatabase *db) {
//                    
//                    NSMutableArray *userIdArr = [NSMutableArray array];
//                    
//                    FMResultSet *rs = nil;
//                    
//                    rs = [db executeQuery:@"select * from t_chatUser"];
//                    
//                    while (rs.next) {
//                        
//                        NSString *userId = [rs stringForColumn:@"userId"];
//                        [userIdArr addObject:userId];
//                    }
//                    if (![userIdArr containsObject:[dic objectForKey:@"userId"]]) {
//                        
//                        // 存储数据
//                        BOOL result = [db executeUpdate:@"insert into t_chatUser (userId, chatUserDic) values(?, ?)", [dic objectForKey:@"userId"], data];
//                        JGLog(@"%d",result);
//                    }
//                }];
//                
//            }
//            
//        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        [self setup];
//        
//        // 1.定义数组
//        __block NSMutableArray *userArr = nil;
//        
//        // 2.使用数据库
//        [_queue inDatabase:^(FMDatabase *db) {
//            // 创建数组
//            userArr = [NSMutableArray array];
//            
//            
//            FMResultSet *rs = nil;
//            
//            rs = [db executeQuery:@"select * from t_chatUser"];
//            
//            while (rs.next) {
//                
//                NSData *data = [rs dataForColumn:@"chatUserDic"];
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                [userArr addObject:dic];
//            }
//        }];
//        [_queue close];
//        
//        NSMutableDictionary *responseObject = [NSMutableDictionary dictionary];
//        [responseObject setObject:@"200" forKey:@"code"];
//        [responseObject setObject:userArr forKey:@"data"];
//        success(responseObject);
        
    }];
}

/**
 获取 滑动图片
 */
+ (void)getScrollViewImagesSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"app";
    NSString *url = [@"http://120.24.97.113/" stringByAppendingString:@"JianGuo3/getScrollImgs"];
    
    [[JGHTTPClient sharedManager] POST:url parameters:params success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
        NSLog(@"JSON: %@", responseObject);
        success(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
}
/**
 *  地区类型信息
 */
+(void)getAreaInfoByloginId:(NSString *)loginId
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{

    NSString *Url = [APIURLCOMMON stringByAppendingString:@"join/label"];
    
    [[JGHTTPClient sharedManager] GET:Url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  生成token
 */
+(NSString *)getToken
{
//    NSDate *date = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString *currentDateStr = [[[self sharedManager] formatter] stringFromDate:[NSDate date]];
    
    
    //xse2iowiowdg3542d49z2016-03-03 09:jfiejdw4gdeqefw33ff23fi999
    NSString *tokenStr = [[@"xse2iowiowdg3542d49z" stringByAppendingString:currentDateStr] stringByAppendingString:@"jfiejdw4gdeqefw33ff23fi999"];
    
    NSString *token = [[tokenStr stringFromMD5] uppercaseString];
    return token;
    
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
+(void)cancelAllRequest
{
    [[[self sharedManager] operationQueue] cancelAllOperations];
}

+ (void)setup
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatuser.sqlite"];
    
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    // 2.创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_chatUser (id integer primary key autoincrement, userId text, chatUserDic blob);"];
    }];
}

/**
 *  @return 时间戳字符串
 */
+(NSString *)getTimeStamp
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%lld",(long long)(time * 1000)];
    return timeStamp;
}

/**
 *  获取app_id
 */
+(NSString *)getAppIdwithStr:(NSString *)phone
{
    return [[[NSString stringWithFormat:@"%@",phone] stringFromMD5] stringFromMD5];
}
/**
 *  获取带基本参数的参数字典
 *
 *  @return 带app_id这种基本参数的参数字典
 */
+(NSMutableDictionary *)getBasedParams:(NSString *)phoneNum
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (phoneNum) {
        [params setObject:[self getAppIdwithStr:phoneNum] forKey:@"app_id"];
    }else{
        [params setObject:[self getAppIdwithStr:USER.tel] forKey:@"app_id"];
    }
    return params;
}
/**
 *  获取签名sign  <<<< MD5(app_id+signSecret+timestamp+token+"jianguo")  signSecret = "He37o6TaD0N"  >>>>
 */
+(NSString *)getSign:(NSString *)timeStamp;
{
    
    NSString *app_id = [self getAppIdwithStr:USER.tel];
    NSString *signSecret = @"He37o6TaD0N";
    NSString *token = USER.token;
    NSString *jianguo = @"jianguo";
    NSString *signStr = [[[[app_id stringByAppendingString:signSecret] stringByAppendingString:timeStamp] stringByAppendingString:token] stringByAppendingString:jianguo];
    return [[signStr stringFromMD5] uppercaseString];
    
}


/**
 *  获取带所有基本参数的参数字典 <timestamp,sign,app_id>
 *
 *  @return 带app_id这种基本参数的参数字典
 */
+(NSMutableDictionary *)getAllBasedParams
{
    if (!USER.tel) {
        return [NSMutableDictionary dictionary];
    }
    
    NSString *timestamp = [self getTimeStamp];
    
    NSMutableDictionary *params = [self getBasedParams:USER.tel];
    
    [params setObject:timestamp forKey:@"timestamp"];
    
    [params setObject:[self getSign:timestamp] forKey:@"sign"];
    
    return params;
}

@end
