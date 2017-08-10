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
+(void)getSkillDetailsWithDemandId:(NSString *)Id
                             userId:(NSString *)userId
                            Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

/**
 *  我发布的技能列表
 */
+(void)getMySkillsListWithPageNum:(NSString *)pageNum
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

@end
