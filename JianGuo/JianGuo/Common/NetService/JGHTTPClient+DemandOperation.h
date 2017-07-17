//
//  JGHTTPClient+DemandOperation.h
//  JianGuo
//
//  Created by apple on 17/6/30.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient.h"

@interface JGHTTPClient (DemandOperation)

/**
 *  报名者取消任务报名
 */
+(void)cancelSignWithDemandId:(NSString *)demandId
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
/**
 *  录用报名者
 */
+(void)admitUserWithDemandId:(NSString *)demandId
                      userId:(NSString *)userId
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
/**
 *  催任务报名者干活儿
 */
+(void)remindUserWithDemandId:(NSString *)demandId
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
/**
 *  任务确认完工< 1==接单者完工， 2==发单者确认完工 >
 */
+(void)sureToFinishDemandWithDemandId:(NSString *)demandId
                         type:(NSString *)type
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

/**
 *  催任务发布者确认完工
 */
+(void)remindPublisherWithDemandId:(NSString *)demandId
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
/**
 *  拒绝支付任务报酬
 */
+(void)refusePayMoneyWithDemandId:(NSString *)demandId
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
/**
 *  下架任务申请
 */
+(void)offDemandWithDemandId:(NSString *)demandId
                      reason:(NSString *)reason
                       money:(NSString *)money
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
/**
 *  接单者处理下架申请 <type: 1同意下架;  2拒绝下架>
 */
+(void)userDealOffDemandWithDemandId:(NSString *)demandId
                              reason:(NSString *)reason
                                type:(NSString *)type
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
/**
 *  任务评价 < 1接单者评价，2发布者评价 >
 */
+(void)evaluateDemand:(NSString *)demandId
             toUserId:(NSString *)toUserId
              comment:(NSString *)comment
                 type:(NSString *)type
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
/**
 *  我报名的任务详情
 */
+(void)getMySignDemandDetailWithDemandId:(NSString *)demandId
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
/**
 *  我发布的任务详情
 */
+(void)getMyPostDemandDetailWithDemandId:(NSString *)demandId
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;

@end
