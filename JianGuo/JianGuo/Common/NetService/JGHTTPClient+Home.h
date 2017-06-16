//
//  JGHTTPClient+Home.h
//  JianGuo
//
//  Created by apple on 16/3/6.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JGHTTPClient.h"

@interface JGHTTPClient (Home)
/**
 *  获取兼职信息列表
 *
 */
+(void)getpartJobsListByHotType:(NSString *)type
                          count:(NSString *)count
                         areaId:(NSString *)areaId
                     orderField:(NSString *)orderField
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
/**
 *  查看兼职详情
 *
 */
+(void)lookPartJobsDetailsByJobid:(NSString *)jobId
                       merchantId:(NSString *)merchantId
                          loginId:(NSString *)loginId
                            alike:(NSString *)alike
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
/**
 *  获取轮播图和城市
 *
 */
+(void)getImgsOfScrollviewWithCategory:(NSString *)categoryId
                               Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
/**
 *  关注或者收藏
 *
 */
+(void)attentionMercntOrColloectionParjobByJobid:(NSString *)jobId
                                      merchantId:(NSString *)merchantId
                                         loginId:(NSString *)loginId
                                         Success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))failure;
/**
 *  报名
 */
+(void)signUpByloginId:(NSString *)loginId
                 jobId:(NSString *)jobId
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;
/**
 *  浏览量接口
 */
+(void)scanTheJobByjobId:(NSString *)jobId
                 loginId:(NSString *)loginId
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
/**
 *  查看日周月兼职
 */
+(void)getTermJobsBymode:(NSString *)mode
                  count:(NSString *)count
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
/**
 *  用户确认参加兼职
 */
+(void)sureToJoinTheJobByjobId:(NSString *)jobId
                       loginId:(NSString *)loginId
                         offer:(NSString *)offer
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
/**
 *  用户兼职列表
 *
 */
+(void)getJobListByLoginId:(NSString *)loginId
                       count:(NSString *)count
                        type:(NSString *)type
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
/**
 *  用户取消报名
 *
 */
+(void)cancelSignUpByjobId:(NSString *)jobId
                       loginId:(NSString *)loginId
                         offer:(NSString *)offer
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
/**
 *  改变兼职状态
 */
+(void)changeStausByjobId:(NSString *)jobId
                 loginId:(NSString *)loginId
                   offer:(NSString *)offer
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  获取推送消息列表
 */
+(void)getNotiNewsByPageNum:(NSString *)pageNum
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/**
 *  获取长期兼职列表
 *
 */
+(void)getLongDateJobListByCount:(NSString *)count
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

@end
