//
//  JGHTTPClient+Skill.m
//  JianGuo
//
//  Created by apple on 17/8/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient+Skill.h"

@implementation JGHTTPClient (Skill)

/**
 *  技能列表
 */
+(void)getSkillListWithSchoolId:(NSString *)schoolId
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
    !userId?:[params setObject:userId forKey:@"uid"];
    !cityCode?:[params setObject:cityCode forKey:@"cityCode"];
    [params setObject:pageCount forKey:@"pageNum"];
    !schoolId?:[params setObject:schoolId forKey:@"schoolId"];
    !keywords?:[params setObject:keywords forKey:@"keywords"];
    !orderBy?:[params setObject:orderBy forKey:@"orderBy"];//最新（createTime）,最热（viewCount）
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills"];
    
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
 *  获取技能详情
 */
+(void)getSkillDetailsWithSkillId:(NSString *)Id
                            userId:(NSString *)userId
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !Id?:[params setObject:Id forKey:@"skillId"];
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"skills/detail"]];
    
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
 *  技能评价列表
 */
+(void)getSkillEvaluationsWithSkillId:(NSString *)Id
                               userId:(NSString *)userId
                            pageCount:(NSString *)pageNum
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !Id?:[params setObject:Id forKey:@"skillId"];
    [params setObject:pageNum forKey:@"pageNum"];
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"skills/evaluates"]];
    
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
 *  我发布的技能列表(管理列表)
 */
+(void)manageMySkillsListWithPageNum:(NSString *)pageNum
                                type:(NSString *)type
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !type?:[params setObject:type forKey:@"type"];
    [params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/my"];
    
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
 *  技能的评论列表
 */
+(void)getSkillCommentsListWithPageNum:(NSString *)pageNum
                               skillId:(NSString *)skillId
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !skillId?:[params setObject:skillId forKey:@"skillId"];
    [params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/comment-list"];
    
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
 *  发布评论
 */
+(void)postAcommentWithSkillId:(NSString *)Id
                        content:(NSString *)content
                            pid:(NSString *)pid
                       toUserId:(NSString *)toUserId
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !Id?:[params setObject:Id forKey:@"skillId"];
    !content?:[params setObject:content forKey:@"content"];
    !pid?:[params setObject:pid forKey:@"pId"];
    !toUserId?:[params setObject:toUserId forKey:@"toUserId"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/comment-add"];
    
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
 *  删除评论
 */
+(void)deleteSkillCommentWithCommentId:(NSString *)commentId
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !commentId?:[params setObject:commentId forKey:@"commentId"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/comment-del"];
    
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
 *  暂停或者回复技能出售 (0解除暂停， 1暂停技能)
 */
+(void)changeSkillStatusById:(NSString *)skillId
                      status:(NSString *)status
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !skillId?:[params setObject:skillId forKey:@"skillId"];
    [params setObject:status forKey:@"status"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/pause"];
    
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
 *  收藏技能 (0取消收藏， 1收藏)
 */
+(void)collectionSkillById:(NSString *)skillId
                      status:(NSString *)status
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !skillId?:[params setObject:skillId forKey:@"skillId"];
    [params setObject:status forKey:@"status"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/favourite"];
    
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
 *  点赞技能 (0取消点赞， 1点赞)
 */
+(void)praiseSkillById:(NSString *)skillId
                status:(NSString *)status
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !skillId?:[params setObject:skillId forKey:@"skillId"];
    [params setObject:status forKey:@"status"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/like"];
    
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
 *  收藏列表
 */
+(void)getCollectedSkillsListPageCount:(NSString *)pageNum
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/favorite-skill"];
    
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
 *  达人榜单
 */
+(void)getSkillExpertsListSuccess:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"masters"];
    
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
 *  下单
 */
+(void)placeOrderWithSkillId:(NSString *)skillId
                       price:(NSString *)price
                  skillCount:(NSString *)count
                   addressId:(NSString *)addressId
                orderMessage:(NSString *)note
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !skillId?:[params setObject:skillId forKey:@"skillId"];
    !price?:[params setObject:price forKey:@"price"];
    !count?:[params setObject:count forKey:@"skillCount"];
    !addressId?:[params setObject:addressId forKey:@"addressId"];
    !note?:[params setObject:note forKey:@"orderMessage"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/order"];
    
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
 *  订单支付
 */
+(void)payOrderWithOrderNo:(NSString *)orderNo
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:orderNo forKey:@"orderNo"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/order-pay"];
    
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
 *  订单取消
 */
+(void)cancelOrderWithOrderNo:(NSString *)orderNo
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:orderNo forKey:@"orderNo"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/order-cancel"];
    
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
 *  type 1：催ta干活，2：催ta确认
 */
+(void)remindToDoSkillWithOrderNo:(NSString *)orderNo
                             type:(NSString *)type
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:orderNo forKey:@"orderNo"];
    [params setObject:type forKey:@"type"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/order-notify"];
    
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
 *  修改技能价格
 */
+(void)alertSkillPriceWithOrderNo:(NSString *)orderNo
                      changePrice:(NSString *)changePrice
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:orderNo forKey:@"orderNo"];
    [params setObject:changePrice forKey:@"changePrice"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/change-price"];
    
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
 *  卖家确认订单完成
 */
+(void)skillExpertSureOrderCompletedWithOrderNo:(NSString *)orderNo
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:orderNo forKey:@"orderNo"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/confirm/service-complete"];
    
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
 *  买家确认订单完成
 */
+(void)userSureOrderCompletedWithOrderNo:(NSString *)orderNo
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:orderNo forKey:@"orderNo"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/confirm/order-complete"];
    
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
 *  买家申请退款
 */
+(void)userApplyForRefundWithOrderNo:(NSString *)orderNo
                              reason:(NSString *)reason
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:orderNo forKey:@"orderNo"];
    [params setObject:reason forKey:@"reason"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/apply/order-refund"];
    
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
 *  type 1同意退款，2拒绝退款
 */
+(void)decideDealRefundWithOrderNo:(NSString *)orderNo
                              type:(NSString *)type
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:orderNo forKey:@"orderNo"];
    [params setObject:type forKey:@"type"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/process/order-refund"];
    
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
 *  投诉订单
 */
+(void)complainOrderWithOrderNo:(NSString *)orderNo
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:orderNo forKey:@"orderNo"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/order-complain"];
    
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
 *  我发布的技能列表('我的'页面)
 */
+(void)getMySkillsListWithPageNum:(NSString *)pageNum
                             type:(NSString *)type
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !type?:[params setObject:type forKey:@"type"];
    [params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/my-publish"];
    
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
 *  我购买的技能列表('我的'页面)
 */
+(void)getMyBuySkillsListWithPageNum:(NSString *)pageNum
                             type:(NSString *)type
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !type?:[params setObject:type forKey:@"type"];
    [params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/my-buy"];
    
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
 *  做出评价 评价类型（1购买者，2发布者）
 */
+(void)makeEvaluateWithOrderNo:(NSString *)orderNo
                         score:(NSString *)score
                       content:(NSString *)content
                          type:(NSString *)type
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !type?:[params setObject:type forKey:@"type"];
    !score?:[params setObject:score forKey:@"score"];
    !content?:[params setObject:content forKey:@"content"];
    !orderNo?:[params setObject:orderNo forKey:@"orderNo"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/evaluate-add"];
    
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
 *  我发布的技能的 订单详情
 */
+(void)getMySkillDetailWithOrderNo:(NSString *)orderNo
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !orderNo?:[params setObject:orderNo forKey:@"orderNo"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/my-publish/detail"];
    
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
 *  我购买的技能的 订单详情
 */
+(void)getMyBuySkillDetailWithOrderNo:(NSString *)orderNo
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !orderNo?:[params setObject:orderNo forKey:@"orderNo"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"skills/my-buy/detail"];
    
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
