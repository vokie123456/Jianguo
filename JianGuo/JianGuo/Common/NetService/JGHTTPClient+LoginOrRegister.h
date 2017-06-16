//
//  JGHTTPClient+LoginOrRegister.h
//  JianGuo
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JGHTTPClient.h"

@interface JGHTTPClient (LoginOrRegister)

/**
 *  上传用户信息(第三方登录后调用的接口)
 *
 *  @param token    从QQ或者微信获取到的token
 *  @param nickName 昵称
 *  @param iconUrl  头像Url
 *  @param sex      性别
 */
+(void)uploadUserInfoFromThirdWithUuid:(NSString *)uid
                             loginType:(NSString *)type
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
/**
 *  检查有没有该手机号
 *
 *  @param phoneNum 手机号
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+(void)checkIsHadThePhoneNum:(NSString *)phoneNum
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
/**
 *  获取短信验证码
 *
 *  @param phoneNum 手机号
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+(void)getAMessageAboutCodeByphoneNum:(NSString *)phoneNum
                                 type:(NSString *)type
                            imageCode:(NSString *)imageCode
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;

/**
 *  手机登录接口
 *
 *  @param phoneNum 手机号
 *  @param passWord 密码
 */
+(void)loginByPhoneNum:(NSString *)phoneNum
              passWord:(NSString *)passWord
                   MD5:(BOOL)MD5
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;
/**
 *  手机号注册接口
 *
 *  @param phoneNum 手机号
 */
+(void)registerByPhoneNum:(NSString *)phoneNum
                 passWord:(NSString *)passWord
                     code:(NSString *)code
                     type:(NSString *)type
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
/**
 *  手机号登录<包括验证码登录和密码登录>
 *
 *  @param phoneNum 手机号
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+(void)loginByPhoneNum:(NSString *)phoneNum
                  code:(NSString *)code
                passwd:(NSString *)passwd
                  type:(NSString *)type
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;
/**
 *  修改密码
 *
 *  @param phoneNum    手机号
 *  @param newPassWord 新密码
 *  @param success     成功回调
 *  @param failure     失败回调
 */
+(void)alertThePassWordByPhoneNum:(NSString *)phoneNum
                          smsCode:(NSString *)smsCode
                      newPassWord:(NSString *)newPassWord
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

/**
 *  提现处用的获取短信验证码
 *
 *  @param phoneNum 手机号
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+(void)getCodeByPhoneNum:(NSString *)phoneNum
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
/**
 *  偏好设置
 */
+(void)setPreferenceLoginId:(NSString *)loginId
              json_type:(NSString *)json_type
              json_time:(NSString *)json_time
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
/**
 *  偏好设置查询
 */
+(void)getPreferenceLoginId:(NSString *)loginId
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
/**
 *  更换手机号
 */
+(void)changePhoneNumByLoginId:(NSString *)loginId
                      phoneNum:(NSString *)phoneNum
                       smsCode:(NSString *)smsCode
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
/**
 *  自动登录
 *
 *  @param phoneNum 手机号
 *  @param token token
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+(void)loginAutoByPhoneNum:(NSString *)phoneNum
                     token:(NSString *)token
                   Success:(void(^)(id responseObject))success
                   failure:(void(^)(NSError *error))failure;
/**
 *  检查更新接口
 */
+(void)checkVersionSuccess:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
/**
 *  第三方登录绑定手机号
 */
+(void)bindingPhoneNumByUid:(NSString *)uid
                        tel:(NSString *)tel
                  loginType:(NSString *)type
                        sex:(NSString *)sex
                       code:(NSString *)code
                   nickname:(NSString *)nickname
                    iconUrl:(NSString *)iconUrl
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

@end
