//
//  JGHTTPClient+Skill.h
//  JianGuo
//
//  Created by apple on 17/8/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient.h"

@interface JGHTTPClient (Skill)

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
                        failure:(void (^)(NSError *error))failure;
/**
 *  获取技能详情
 */
+(void)getSkillDetailsWithSkillId:(NSString *)Id
                           userId:(NSString *)userId
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
/**
 *  技能评价列表
 */
+(void)getSkillEvaluationsWithSkillId:(NSString *)Id
                               userId:(NSString *)userId
                            pageCount:(NSString *)pageNum
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;

/**
 *  我发布的技能
 */
+(void)manageMySkillsListWithPageNum:(NSString *)pageNum
                             type:(NSString *)type
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;


/**
 *  技能的评论列表
 */
+(void)getSkillCommentsListWithPageNum:(NSString *)pageNum
                               skillId:(NSString *)skillId
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;

/**
 *  发布评论
 */
+(void)postAcommentWithSkillId:(NSString *)Id
                       content:(NSString *)content
                           pid:(NSString *)pid
                      toUserId:(NSString *)toUserId
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

/**
 *  暂停或者恢复技能出售 (0解除暂停， 1暂停技能)
 */
+(void)changeSkillStatusById:(NSString *)skillId
                      status:(NSString *)status
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

/**
 *  收藏技能 (0取消收藏， 1收藏)
 */
+(void)collectionSkillById:(NSString *)skillId
                    status:(NSString *)status
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
/**
 *  点赞技能 (0取消点赞， 1点赞)
 */
+(void)praiseSkillById:(NSString *)skillId
                    status:(NSString *)status
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

/**
 *  收藏列表
 */
+(void)getCollectedSkillsListPageCount:(NSString *)pageNum
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;

/**
 *  达人榜单
 */
+(void)getSkillExpertsListSuccess:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

/**
 *  下单
 */
+(void)placeOrderWithSkillId:(NSString *)skillId
                       price:(NSString *)price
                  skillCount:(NSString *)count
                   addressId:(NSString *)addressId
                orderMessage:(NSString *)note
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;


/**
 *  订单支付
 */
+(void)payOrderWithOrderNo:(NSString *)orderNo
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

/**
 *  订单取消
 */
+(void)cancelOrderWithOrderNo:(NSString *)orderNo
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

/**
 *  type 1：催ta干活，2：催ta确认
 */
+(void)remindToDoSkillWithOrderNo:(NSString *)orderNo
                             type:(NSString *)type
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

/**
 *  修改技能价格
 */
+(void)alertSkillPriceWithOrderNo:(NSString *)orderNo
                      changePrice:(NSString *)changePrice
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

/**
 *  卖家确认订单完成
 */
+(void)skillExpertSureOrderCompletedWithOrderNo:(NSString *)orderNo
                                        Success:(void (^)(id responseObject))success
                                        failure:(void (^)(NSError *error))failure;

/**
 *  买家确认订单完成
 */
+(void)userSureOrderCompletedWithOrderNo:(NSString *)orderNo
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;

/**
 *  买家申请退款
 */
+(void)userApplyForRefundWithOrderNo:(NSString *)orderNo
                              reason:(NSString *)reason
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;

/**
 *  type 1同意退款，2拒绝退款
 */
+(void)decideDealRefundWithOrderNo:(NSString *)orderNo
                              type:(NSString *)type
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

/**
 *  投诉订单
 */
+(void)complainOrderWithOrderNo:(NSString *)orderNo
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

/**
 *  我发布的技能列表('我的'页面)
 */
+(void)getMySkillsListWithPageNum:(NSString *)pageNum
                             type:(NSString *)type
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

/**
 *  我购买的技能列表('我的'页面)
 */
+(void)getMyBuySkillsListWithPageNum:(NSString *)pageNum
                                type:(NSString *)type
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;

/**
 *  做出评价 评价类型（1购买之，2发布者）
 */
+(void)makeEvaluateWithOrderNo:(NSString *)orderNo
                         score:(NSString *)score
                       content:(NSString *)content
                          type:(NSString *)type
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

/**
 *  我发布的技能的 订单详情
 */
+(void)getMySkillDetailWithOrderNo:(NSString *)orderNo
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

/**
 *  我购买的技能的 订单详情
 */
+(void)getMyBuySkillDetailWithOrderNo:(NSString *)orderNo
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;

@end
