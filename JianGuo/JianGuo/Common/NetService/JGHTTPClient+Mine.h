//
//  JGHTTPClient+Mine.h
//  JianGuo
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JGHTTPClient.h"

@interface JGHTTPClient (Mine)

/**
 *  实名认证接口
 *
 */
+(void)uploadUserInfoByCardIdFront:(NSString *)frontUrl
                        CarfIdBack:(NSString *)backUrl
                         CardIdNum:(NSString *)CardIdNum
                          realName:(NSString *)realName
                          schoolId:(NSString *)schoolId
                        schoolName:(NSString *)schoolName
                        studentNum:(NSString *)studentNum
                        studentUrl:(NSString *)studentUrl
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
/**
 *  更改实名认证接口
 *
 */
+(void)upDateUserInfoByCardIdFront:(NSString *)frontUrl
                        CarfIdBack:(NSString *)backUrl
                         CardIdNum:(NSString *)CardIdNum
                           loginId:(NSString *)loginId
                          realName:(NSString *)realName
                               sex:(NSString *)sex
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

/**
 *  获取骑牛token
 */
+(void)getQNtokenSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
/**
 *  绑定手机号
 */
+(void)bindingYourPhoneNumByPhoneNum:(NSString *)phoneNum
                             loginId:(NSString *)loginId
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;

/**
 *  查看实名认证信息
 */
+(void)selectRealnameInfoByloginId:(NSString *)loginId
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

/**
 *  意见反馈消息
 */
+(void)commitOpinionsByTel:(NSString *)tel
                      text:(NSString *)text
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

/**
 *  上传简历信息
 */
+(void)uploadUserJianliInfoByname:(NSString *)name
                         nickName:(NSString *)nickName
                          iconUrl:(NSString *)iconUrl
                              sex:(NSString *)sex
                           height:(NSString *)height
                         schoolId:(NSString *)schoolId
                           cityId:(NSString *)cityId
                           areaId:(NSString *)areaId
                     inSchoolTime:(NSString *)inSchoolTime
                         birthDay:(NSString *)birthDay
                    constellation:(NSString *)constellation//星座
                        introduce:(NSString *)introduce
                               qq:(NSString *)qq
                        isStudent:(NSString *)isStudent
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
/**
 *  查询学校的接口
 */
+(void)searchSchoolByName:(NSString *)name
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
/**
 *  查询学校的接口
 */
+(void)searchSchoolByName:(NSString *)name
                 cityCode:(NSString *)cityCode
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/**
 *  查看简历信息
 */
+(void)getJianliInfoByloginId:(NSString *)loginId
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;;

/**
 *  查看收藏和关注信息
 */
+(void)getcollectionAndAttentionListByloginId:(NSString *)loginId
                                      Success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure;
/**
 *  删除收藏和关注信息
 */
+(void)deleteAcollectionOrattentionByloginId:(NSString *)loginId
                                      dataId:(NSString *)dataId
                                        type:(NSString *)type
                                      Success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure;

/**
 *  用户支出明细 (和收入明细是一个接口 有个type区分 支出=2)
 */
+(void)lookUserMoneyLogByloginId:(NSString *)loginId
                          type:(NSString *)type
                         count:(NSString *)count
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
/**
 *  用户余额查询
 */
+(void)lookUserBalanceByloginId:(NSString *)loginId
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
/**
 *  用户修改支付密码
 */
+(void)alertPayPasswordByloginId:(NSString *)loginId
                        password:(NSString *)password
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
/**
 * 绑定支付宝或银行卡：
 */
+(void)bindCardOrAlipayByUserName:(NSString *)userName
                          number:(NSString *)number
                        bankName:(NSString *)bankName
                            type:(NSString *)type
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

/**
 * 查询绑定的收款信息
 */
+(void)getBindInfoSuccess:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;


/**
 * 解除绑定信息
 */
+(void)unBindByTypeId:(NSString *)typeId
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;


/**
 * 绑定微信
 */
+(void)bindweixinByloginId:(NSString *)loginId
                    openid:(NSString *)openid
                  nickname:(NSString *)nickname
                       sex:(NSString *)sex
                  province:(NSString *)province
                      city:(NSString *)city
                   country:(NSString *)country
                headimgurl:(NSString *)headimgurl
                 privilege:(NSString *)privilege
                   unionid:(NSString *)unionid
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;


/**
 *  结算工资接口
 */
+(void)PayWageByCode:(NSString *)code
             jsonStr:(NSString *)jsonStr
                Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;

/**
 *  用户提现获取验证码
 */
+(void)getCodeForCashByphoneNo:(NSString *)phoneNo
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

/**
 *  拉取别人的个人信息
 */
+(void)getUserInfoWithUserId:(NSString *)userId
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
/**
 *  编辑个人资料接口<新版接口 06-24>
 */
+(void)editUserProfileWithCityCode:(NSString *)cityCode
                           headImg:(NSString *)headImg
                         introduce:(NSString *)introduce
                               sex:(NSString *)sex
                          birthDay:(NSString *)birthDay
                          schoolId:(NSString *)schoolId
                          nickName:(NSString *)nickName
                    intoSchoolDate:(NSString *)intoSchoolDate
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

/**
 *  拉取自己的个人信息
 */
+(void)getMyselfProfileWithUserId:(NSString *)userId
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
/**
 *  拉取关注或者粉丝列表<0我关注的 1我的粉丝>
 */
+(void)getFunsOrFollowsWithType:(NSString *)type
                         userId:(NSString *)userId
                      pageCount:(NSString *)pageCount
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;



/**
 *  获取 <我的> 数据
 */
+(void)getMineInfoSuccess:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;



@end
