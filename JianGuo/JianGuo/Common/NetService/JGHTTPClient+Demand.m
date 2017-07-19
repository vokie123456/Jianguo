//
//  JGHTTPClient+Demand.m
//  JianGuo
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient+Demand.h"
#import "CityModel.h"

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
                  limitTime:(NSString *)limitTime
                  anonymous:(NSString *)anonymous
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !money?:[params setObject:money forKey:@"money"];
    !imageUrl?:[params setObject:imageUrl forKey:@"images"];
    !title?:[params setObject:title forKey:@"title"];
    !description?:[params setObject:description forKey:@"d_describe"];
    !type?:[params setObject:type forKey:@"d_type"];
    !city?:[params setObject:city forKey:@"city"];
    !area?:[params setObject:area forKey:@"area"];
    !schoolId?:[params setObject:schoolId forKey:@"school_id"];
    !sex?:[params setObject:sex forKey:@"sex"];
    !limitTime?:[params setObject:limitTime forKey:@"limit_time_str"];
    [params setObject:anonymous forKey:@"anonymous"];
    
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/v2/save"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  需求列表
 */
+(void)getDemandListWithSchoolId:(NSString *)schoolId
                        cityCode:(NSString *)cityCode
                        keywords:(NSString *)keywords
                         orderBy:(NSString *)orderBy
                            type:(NSString *)type
                             sex:(NSString *)sex
                          userId:(NSString *)userId
                       pageCount:(NSString *)pageCount
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !type?:[params setObject:type forKey:@"type"];
    !sex?:[params setObject:sex forKey:@"sex"];
    !userId?:[params setObject:userId forKey:@"publishUserId"];
    !cityCode?:[params setObject:cityCode forKey:@"cityCode"];
    [params setObject:pageCount forKey:@"pageNum"];
    !schoolId?:[params setObject:schoolId forKey:@"schoolId"];
    !keywords?:[params setObject:keywords forKey:@"keywords"];
    !orderBy?:[params setObject:orderBy forKey:@"orderBy"];//以什么排序（create_time或者like_count）
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/v2/list"];
    
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
                            pid:(NSString *)pid
                       toUserId:(NSString *)toUserId
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !Id?:[params setObject:Id forKey:@"d_id"];
    !content?:[params setObject:content forKey:@"content"];
    !pid?:[params setObject:pid forKey:@"p_id"];
    !toUserId?:[params setObject:toUserId forKey:@"to_user_id"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/v2/comment-add"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  需求点赞
 *  likeStatus 点赞状态（1点赞，0取消点赞）
 */
+(void)praiseForDemandWithDemandId:(NSString *)Id
                        likeStatus:(NSString *)likeStatus
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !Id?:[params setObject:Id forKey:@"demandId"];
    !likeStatus?:[params setObject:likeStatus forKey:@"likeStatus"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demand/like"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  获取评论列表
 */
+(void)getCommentsListWithDemandId:(NSString *)Id
                           pageNum:(NSString *)pageNum
                          pageSize:(NSString *)pageSize
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:Id forKey:@"demandId"];
    [params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/v2/comment-list"];
    
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
                             userId:(NSString *)userId
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
//    [params setObject:Id?Id:@"0" forKey:@"id"];
//    [params setObject:userId.integerValue?userId:@"0" forKey:@"user_id"];
    !Id?:[params setObject:Id forKey:@"demandId"];
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"demands/v2/detail"]];
    
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
+(void)getProgressDetailsWithDemandId:(NSString *)Id
                               userId:(NSString *)userId
                                 type:(NSString *)type
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:Id?Id:@"0" forKey:@"id"];
    [params setObject:type forKey:@"type"];
//    [params setObject:userId?userId:@"0" forKey:@"user_id"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demand/getDemandPublish"];
    
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
 *  报名任务
 */
+(void)signDemandWithDemandId:(NSString *)Id
                       userId:(NSString *)userId
                       status:(NSString *)status
                       reason:(NSString *)reason
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:Id forKey:@"demandId"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/v2/enroll"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  投诉接口
 */
+(void)complainSomeOneWithDemandId:(NSString *)Id
                            userId:(NSString *)userId
                            status:(NSString *)status
                            reason:(NSString *)reason
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !Id?:[params setObject:Id forKey:@"d_id"];
    !userId?:[params setObject:userId forKey:@"enroll_user_id"];
    !status?:[params setObject:status forKey:@"d_status"];
    [params setObject:USER.login_id forKey:@"b_user_id"];
    !reason?:[params setObject:reason forKey:@"reason"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demand/complaint"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  报名申请人的列表
 */
+(void)signerListWithDemandId:(NSString *)Id
                      pageNum:(NSString *)pageNum
                     pageSize:(NSString *)pageSize
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !Id?:[params setObject:Id forKey:@"demandId"];
    [params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/enroll-list"];
    
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
 *  删除需求
 */
+(void)updateDemandStatusWithDemandId:(NSString *)Id
                               status:(NSString *)status
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:Id?Id:@"0" forKey:@"id"];
    [params setObject:status forKey:@"d_status"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demand/upDemandStatus"];
    
    [[JGHTTPClient sharedManager] PUT:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  我发布的需求列表
 */
+(void)getMyDemandsListWithPageNum:(NSString *)pageNum
                              type:(NSString *)type
                          pageSize:(NSString *)pageSize
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !type?:[params setObject:type forKey:@"type"];
    [params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/my/publish"];
    
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
 *  关注状态 0==关注; 1==取消
 */
+(void)followUserWithUserId:(NSString *)userId
                     status:(NSString *)status
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:userId forKey:@"followUserId"];
    [params setObject:status forKey:@"status"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/follows"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  我报名的需求列表
 */
+(void)getMySignedDemandsListWithPageNum:(NSString *)pageNum
                                    type:(NSString *)type
                                pageSize:(NSString *)pageSize
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !type?:[params setObject:type forKey:@"type"];
    [params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"demands/my/enroll"]];
    
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
 *  获取评价列表
 */
+(void)getEvaluatesWithUserId:(NSString *)userId
                      pageNum:(NSString *)pageNum
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !userId?:[params setObject:userId forKey:@"userId"];
    [params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"demands/evaluate-list"]];
    
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
 *  删除评论
 */
+(void)deleteCommentWithCommentId:(NSString *)commentId
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"demands/v2/comment-delete/%@",commentId]];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
