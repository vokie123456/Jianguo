//
//  JGHTTPClient+Demand.h
//  JianGuo
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient.h"

@interface JGHTTPClient (Demand)
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
                    failure:(void (^)(NSError *error))failure;

/**
 *  需求列表
 */
+(void)getDemandListWithSchoolId:(NSString *)schoolId
                            type:(NSString *)type
                             sex:(NSString *)sex
                          userId:(NSString *)userId
                       pageCount:(NSString *)pageCount
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

/**
 *  发布评论
 */
+(void)postAcommentWithDemandId:(NSString *)Id
                        content:(NSString *)content
                         userId:(NSString *)userId
                       toUserId:(NSString *)toUserId
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
/**
 *  需求点赞
 *  likeStatus 点赞状态（1点赞，0取消点赞）
 */
+(void)praiseForDemandWithDemandId:(NSString *)Id
                        likeStatus:(NSString *)likeStatus
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
/**
 *  获取评论列表
 */
+(void)getCommentsListWithDemandId:(NSString *)Id
                           pageNum:(NSString *)pageNum
                          pageSize:(NSString *)pageSize
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
/**
 *  我发布的需求列表
 */
+(void)getMyDemandsListWithPageNum:(NSString *)pageNum
                          pageSize:(NSString *)pageSize
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
/**
 *  我报名的需求列表
 */
+(void)getMySignedDemandsListWithPageNum:(NSString *)pageNum
                          pageSize:(NSString *)pageSize
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
/**
 *  获取需求详情
 */
+(void)getDemandDetailsWithDemandId:(NSString *)Id
                             userId:(NSString *)userId
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
/**
 *  我要接活儿(报名==1,录用==2)
 */
+(void)signDemandWithDemandId:(NSString *)Id
                       userId:(NSString *)userId
                       status:(NSString *)status
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

/**
 *  报名申请人的列表
 */
+(void)signerListWithDemandId:(NSString *)Id
                      pageNum:(NSString *)pageNum
                     pageSize:(NSString *)pageSize
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
/**
 *  更新需求状态 需求状态 (需求状态 1正常发布状态，2录取，3 参与者完成需求，4发布者支付，5发布者拒绝支付，6，参与者要求客服介入，7已解决,8=下架,9=删除)
 */
+(void)updateDemandStatusWithDemandId:(NSString *)Id
                               status:(NSString *)status
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

@end
