
//  JGHTTPClient+Home.m
//  JianGuo
//
//  Created by apple on 16/3/6.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JGHTTPClient+Home.h"
#import "CityModel.h"

@implementation JGHTTPClient (Home)

/**
 *  获取兼职信息列表
 *
 */
+(void)getpartJobsListByHotType:(NSString *)type
                          count:(NSString *)count
                         areaId:(NSString *)areaId
                     orderField:(NSString *)orderField
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{

    NSString *cityId = [CityModel city].code?[CityModel city].code:@"0899";

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setObject:count forKey:@"pageNum"];
    if (type) {
        [params setObject:type forKey:@"job_type_id"];
    }
    if (areaId) {
        [params setObject:areaId forKey:@"area_id"];
    }
    if (orderField) {
        [params setObject:orderField forKey:@"order_field"];
    }
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"job/user/list/%@",cityId]];
    
    [[JGHTTPClient sharedManager] GET:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取长期兼职列表
 *
 */
+(void)getLongDateJobListByCount:(NSString *)count
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:count forKey:@"count"];
    
    [params setObject:[CityModel city].code?[CityModel city].code:@"0899" forKey:@"city_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_job_List_Max_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


/**
 *  查看兼职详情
 *
 */
+(void)lookPartJobsDetailsByJobid:(NSString *)jobId
                       merchantId:(NSString *)merchantId
                          loginId:(NSString *)loginId
                            alike:(NSString *)alike
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    [params setObject:USER.token?USER.token:@"" forKey:@"token"];
    

    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"job/user/detail/%@",jobId]];
    
    [[JGHTTPClient sharedManager] GET:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取轮播图和城市
 *  categoryId (1==任务;  2==兼职)
 */
+(void)getImgsOfScrollviewWithCategory:(NSString *)categoryId
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    !categoryId?:[params setObject:categoryId forKey:@"category_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"banners/v2"];
    
    [[JGHTTPClient sharedManager] GET:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
/**
  *  关注或者收藏
  *
  */
+(void)attentionMercntOrColloectionParjobByJobid:(NSString *)jobId
                                      merchantId:(NSString *)merchantId
                                         loginId:(NSString *)loginId
                                         Success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:jobId forKey:@"collection"];
    
    [params setObject:merchantId forKey:@"follow"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_attent_Insert_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  查看日周月兼职
 */
+(void)getTermJobsBymode:(NSString *)mode
                   count:(NSString *)count
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:mode forKey:@"mode"];
    
    [params setObject:count forKey:@"count"];
    
    [params setObject:[CityModel city].code?[CityModel city].code:@"0899" forKey:@"city_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_job_List_Day_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

/**
 *  报名
 */
+(void)signUpByloginId:(NSString *)loginId
                 jobId:(NSString *)jobId
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *params = [self getAllBasedParams];
    
    [params setObject:jobId forKey:@"job_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"join/status"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}
/**
 *  浏览量接口
 */
+(void)scanTheJobByjobId:(NSString *)jobId
                 loginId:(NSString *)loginId
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:jobId forKey:@"job_id"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_job_Look_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

/**
 *  用户确认参加兼职
 */
+(void)sureToJoinTheJobByjobId:(NSString *)jobId
                       loginId:(NSString *)loginId
                         offer:(NSString *)offer
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:jobId forKey:@"job_id"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    [params setObject:offer forKey:@"offer"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_enroll_Agree_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

/**
 *  用户兼职列表
 *
 */
+(void)getJobListByLoginId:(NSString *)loginId
                     count:(NSString *)count
                      type:(NSString *)type
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *params = [self getAllBasedParams];
    
    [params setObject:count forKey:@"pageNum"];

    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"join/user"];
    
    [[JGHTTPClient sharedManager] GET:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(success){
            if ([responseObject[@"code"] integerValue] == 600) {
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 *  用户取消报名
 *
 */
+(void)cancelSignUpByjobId:(NSString *)jobId
                   loginId:(NSString *)loginId
                     offer:(NSString *)offer
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:jobId forKey:@"job_id"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    [params setObject:offer forKey:@"offer"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_enroll_User_Cancel_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    

}
/**
 *  改变兼职状态
 */
+(void)changeStausByjobId:(NSString *)jobId
                  loginId:(NSString *)loginId
                    offer:(NSString *)offer
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *params = [self getAllBasedParams];
    
    [params setObject:jobId forKey:@"job_id"];
    
    [params setObject:offer forKey:@"status"];
//    
//    [params setObject:loginId forKey:@"user_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"join/status"];
    
    [[JGHTTPClient sharedManager] PUT:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取推送消息列表
 */
+(void)getNotiNewsByPageNum:(NSString *)pageNum
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    
    [params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/push"];
    
    [[JGHTTPClient sharedManager] GET:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            if ([responseObject[@"code"] integerValue] == 600) {
                [self showAlertViewWithText:responseObject[@"message"] duration:1];
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

@end
