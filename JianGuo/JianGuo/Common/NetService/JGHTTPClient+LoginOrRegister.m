//
//  JGHTTPClient+LoginOrRegister.m
//  JianGuo
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JGHTTPClient+LoginOrRegister.h"
#import "NSString+MD5Addition.h"

@implementation JGHTTPClient (LoginOrRegister)

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
{
    NSMutableDictionary *params = [self getBasedParams:phoneNum];
    
    [params setObject:phoneNum forKey:@"tel"];
    if (passwd) {
        [params setObject:passwd  forKey:@"passwd"];
    }
    if (code) {
        [params setObject:code  forKey:@"code"];
    }
    [params setObject:type  forKey:@"type"];
    
//    if ([USERDEFAULTS objectForKey:CityCode]) {
//        [params setObject:[USERDEFAULTS objectForKey:CityCode] forKey:@"city_id"];
//    }
//    if ([USERDEFAULTS objectForKey:CityName]) {
//        [params setObject:[USERDEFAULTS objectForKey:CityName] forKey:@"city_name"];
//    }
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"login"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            JGLog(@"%@",responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 *  手机号注册接口
 *
 *  @param phoneNum 手机号
 *  @param passWord 密码
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+(void)registerByPhoneNum:(NSString *)phoneNum
                 passWord:(NSString *)passWord
                     code:(NSString *)code
                     type:(NSString *)type
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[JGHTTPClient getAppIdwithStr:phoneNum] forKey:@"app_id"];
    
    [params setObject:phoneNum forKey:@"tel"];
    
    [params setObject:code forKey:@"code"];
    
    [params setObject:passWord forKey:@"passwd"];
    
    [params setObject:type forKey:@"type"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"sign"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  上传用户信息
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
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:uid forKey:@"uuid"];
    
    [params setObject:type forKey:@"login_type"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"loginOther"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
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
                    failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[JGHTTPClient getAppIdwithStr:tel] forKey:@"app_id"];
    
    [params setObject:tel forKey:@"tel"];
    
    [params setObject:code forKey:@"code"];
    
    [params setObject:uid forKey:@"uuid"];
    
    [params setObject:type forKey:@"type"];
    
    [params setObject:nickname forKey:@"nickname"];
    
    [params setObject:iconUrl forKey:@"head_img_url"];
    
    [params setObject:sex forKey:@"sex"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"loginBind"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  检查有没有该手机号
 *
 *  @param phoneNum 手机号
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+(void)checkIsHadThePhoneNum:(NSString *)phoneNum
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:phoneNum forKey:@"tel"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_user_login_Check_Tel_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
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
                              failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    !phoneNum?:[params setObject:phoneNum forKey:@"tel"];
    
    !type?:[params setObject:type forKey:@"type"];
    
    !phoneNum?:[params setObject:[self getAppIdwithStr:phoneNum] forKey:@"app_id"];
    
    !imageCode?:[params setObject:imageCode forKey:@"imageCode"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"image/code/check"];
    
    
    [[JGHTTPClient sharedManager] GET:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
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
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:phoneNum forKey:@"tel"];
    
    [params setObject:smsCode forKey:@"code"];
    
    [params setObject:newPassWord forKey:@"passwd"];
    
    [params setObject:userType forKey:@"type"];
    
    //TODO: 替换API URL
    //    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"%@/passwdReset?tel=%@&code=%@&passwd=%@&type=%@",[self getAppIdwithStr:phoneNum],phoneNum,smsCode,password,userType]];
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"%@/passwdReset",[self getAppIdwithStr:phoneNum]]];
    [[JGHTTPClient sharedManager] PUT:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

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
                   failure:(void(^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getBasedParams:[NSString stringWithFormat:@"%@",USER.tel]];
    
    JGLog(@"%@",USER.token);
    [params setObject:USER.token?USER.token:@"" forKey:@"token"];
    
    [params setObject:userType forKey:@"type"];
    
    //TODO: 替换API URL
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"login"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  提现处用的获取短信验证码
 *
 *  @param phoneNum 手机号
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+(void)getCodeByPhoneNum:(NSString *)phoneNum
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:phoneNum forKey:@"tel"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_user_login_Check_BackTel_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  偏好设置
 */
+(void)setPreferenceLoginId:(NSString *)loginId
              json_type:(NSString *)json_type
              json_time:(NSString *)json_time
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    [params setObject:json_time forKey:@"json_time"];
    
    [params setObject:json_type forKey:@"json_type"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_hobby_Insert_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 *  偏好设置查询
 */
+(void)getPreferenceLoginId:(NSString *)loginId
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_hobby_Select_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
/**
 *  更换手机号
 */
+(void)changePhoneNumByLoginId:(NSString *)loginId
                      phoneNum:(NSString *)phoneNum
                       smsCode:(NSString *)smsCode
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    [params setObject:phoneNum forKey:@"tel"];
    
    [params setObject:smsCode forKey:@"sms_code"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_user_login_ChangeTel_Servlet"];
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  检查更新接口
 */
+(void)checkVersionSuccess:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"deviceType"];
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"version/upgrade"];
    
    [[JGHTTPClient sharedManager] GET:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
