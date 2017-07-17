//
//  JGHTTPClient+DemandOperation.m
//  JianGuo
//
//  Created by apple on 17/6/30.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient+DemandOperation.h"

@implementation JGHTTPClient (DemandOperation)


/**
 *  报名者取消任务报名
 */
+(void)cancelSignWithDemandId:(NSString *)demandId
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !demandId?:[params setObject:demandId forKey:@"demandId"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/enroll/cancel"];
    
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
 *  录用报名者
 */
+(void)admitUserWithDemandId:(NSString *)demandId
                      userId:(NSString *)userId
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !demandId?:[params setObject:demandId forKey:@"demandId"];
    !userId?:[params setObject:userId forKey:@"admitUid"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/v2/admit"];
    
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
 *  催任务报名者干活儿
 */
+(void)remindUserWithDemandId:(NSString *)demandId
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !demandId?:[params setObject:demandId forKey:@"demandId"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/notify/to-work"];
    
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
 *  任务确认完工< 1==接单者完工， 2==发单者确认完工 >
 */
+(void)sureToFinishDemandWithDemandId:(NSString *)demandId
                                 type:(NSString *)type
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !demandId?:[params setObject:demandId forKey:@"demandId"];
    !type?:[params setObject:type forKey:@"type"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/v2/confirm"];
    
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
 *  催任务发布者确认完工
 */
+(void)remindPublisherWithDemandId:(NSString *)demandId
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !demandId?:[params setObject:demandId forKey:@"demandId"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/notify/to-confirm"];
    
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
 *  拒绝支付任务报酬
 */
+(void)refusePayMoneyWithDemandId:(NSString *)demandId
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !demandId?:[params setObject:demandId forKey:@"demandId"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/refuse-pay"];
    
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
 *  发布者下架任务申请
 */
+(void)offDemandWithDemandId:(NSString *)demandId
                      reason:(NSString *)reason
                       money:(NSString *)money
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !reason?:[params setObject:reason forKey:@"reason"];
    !money?:[params setObject:money forKey:@"money"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"demands/off/%@",demandId]];
    
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
 *  接单者处理下架申请
 */
+(void)userDealOffDemandWithDemandId:(NSString *)demandId
                              reason:(NSString *)reason
                                type:(NSString *)type
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !reason?:[params setObject:reason forKey:@"reason"];
    !type?:[params setObject:type forKey:@"type"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"demands/deal-applyOff/%@",demandId]];
    
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
 *  任务评价 < 1接单者评价，2发布者评价 >
 */
+(void)evaluateDemand:(NSString *)demandId
             toUserId:(NSString *)toUserId
              comment:(NSString *)comment
                 type:(NSString *)type
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !comment?:[params setObject:comment forKey:@"comment"];
    !type?:[params setObject:type forKey:@"type"];
    !demandId?:[params setObject:demandId forKey:@"demandId"];
    !toUserId?:[params setObject:toUserId forKey:@"toUserId"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"demands/evaluate-add"];
    
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
 *  我报名的任务详情
 */
+(void)getMySignDemandDetailWithDemandId:(NSString *)demandId
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"demands/my/enroll/%@",demandId]];
    
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
 *  我发布的任务详情
 */
+(void)getMyPostDemandDetailWithDemandId:(NSString *)demandId
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"demands/my/publish/%@",demandId]];
    
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
