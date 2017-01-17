//
//  JGHTTPClient+Demand.m
//  JianGuo
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient+Demand.h"

@implementation JGHTTPClient (Demand)

/**
 *  发布需求接口
 *
 *  @param money       赏金
 *  @param imageUrl    需求图片
 *  @param title       需求标题
 *  @param description 需求描述
 *  @param type        需求类型
 *  @param city        所在城市ID
 *  @param area        地区ID
 *  @param anonymous   是否匿名
 *  @param success     成功回调
 *  @param failure     失败回调
 */
+(void)PostDemandWithMoney:(NSString *)money
                   imageUrl:(NSString *)imageUrl
                      title:(NSString *)title
                description:(NSString *)description
                       type:(NSString *)type
                       city:(NSString *)city
                       area:(NSString *)area
                   schoolId:(NSString *)schoolId
                        sex:(NSString *)sex
                  anonymous:(NSString *)anonymous
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:money forKey:@"money"];
    [params setObject:imageUrl forKey:@"d_image"];
    [params setObject:title forKey:@"title"];
    [params setObject:description forKey:@"d_describe"];
    [params setObject:type forKey:@"d_type"];
    [params setObject:city forKey:@"city"];
    [params setObject:area forKey:@"area"];
    [params setObject:schoolId forKey:@"school_id"];
    [params setObject:sex forKey:@"sex"];
    
    [params setObject:anonymous forKey:@"anonymous"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demand/add"];
    
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
 *  需求列表
 */
+(void)getDemandListWithSchoolId:(NSString *)schoolId
                            type:(NSString *)type
                             sex:(NSString *)sex
                          userId:(NSString *)userId
                       pageCount:(NSString *)pageCount
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    !type?:[params setObject:type forKey:@"d_type"];
    !sex?:[params setObject:sex forKey:@"sex"];
    [params setObject:userId?userId:@"0" forKey:@"user_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"demand/getList/%@",schoolId]];
    
    [[JGHTTPClient sharedManager] GET:Url parameters:params.allKeys.count?params:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  发布评论
 */
+(void)postAcommentWithDemandId:(NSString *)Id
                        content:(NSString *)content
                         userId:(NSString *)userId
                       toUserId:(NSString *)toUserId
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:Id forKey:@"d_id"];
    [params setObject:content forKey:@"content"];
    [params setObject:userId forKey:@"user_id"];
    [params setObject:toUserId forKey:@"to_user_id"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demand/addDemandComment"];
    
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
 *  需求点赞
 *  likeStatus 点赞状态（1点赞，0取消点赞）
 */
+(void)praiseForDemandWithDemandId:(NSString *)Id
                        likeStatus:(NSString *)likeStatus
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:Id forKey:@"d_id"];
    [params setObject:likeStatus forKey:@"like_status"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demand/addDemandLike"];
    
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
 *  获取评论列表
 */
+(void)getCommentsListWithDemandId:(NSString *)Id
                           pageNum:(NSString *)pageNum
                          pageSize:(NSString *)pageSize
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:Id?Id:@"0" forKey:@"id"];
    [params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demand/getCommentList"];
    
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
 *  获取需求详情
 */
+(void)getDemandDetailsWithDemandId:(NSString *)Id
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:Id?Id:@"0" forKey:@"id"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demand/getDemand"];
    
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
 *  我要接活儿
 */
+(void)signDemandWithDemandId:(NSString *)Id
                       status:(NSString *)status
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:Id forKey:@"d_id"];
    [params setObject:status forKey:@"enroll_status"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demand/demandEnroll"];
    
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


@end
