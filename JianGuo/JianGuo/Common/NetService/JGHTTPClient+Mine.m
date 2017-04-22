//
//  JGHTTPClient+Mine.m
//  JianGuo
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JGHTTPClient+Mine.h"
#import "CityModel.h"

@implementation JGHTTPClient (Mine)

/**
 *  实名认证接口
 *
 */
+(void)uploadUserInfoByCardIdFront:(NSString *)frontUrl
                        CarfIdBack:(NSString *)backUrl
                         CardIdNum:(NSString *)CardIdNum
                           loginId:(NSString *)loginId
                          realName:(NSString *)realName
                               sex:(NSString *)sex
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:@"4" forKey:@"type"];
    [params setObject:sex forKey:@"sex"];
    [params setObject:realName forKey:@"realname"];
    [params setObject:CardIdNum forKey:@"IDcard"];
    [params setObject:frontUrl?frontUrl:@"" forKey:@"front_img_url"];
    [params setObject:backUrl?backUrl:@"" forKey:@"behind_img_url"];
    NSString *cityId = [USERDEFAULTS objectForKey:CityCode]?[USERDEFAULTS objectForKey:CityCode]:@"1";
    [params setObject:cityId forKey:@"city_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"auth/info"];
    
    
    [[JGHTTPClient sharedManager] POST:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
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
 *  更改实名认证接口 <不用的接口>
 *
 */
+(void)upDateUserInfoByCardIdFront:(NSString *)frontUrl
                        CarfIdBack:(NSString *)backUrl
                         CardIdNum:(NSString *)CardIdNum
                           loginId:(NSString *)loginId
                          realName:(NSString *)realName
                               sex:(NSString *)sex
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:frontUrl forKey:@"front_image"];
    
    [params setObject:backUrl forKey:@"front_image"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    [params setObject:sex forKey:@"sex"];
    
    [params setObject:realName forKey:@"realname"];
    
    [params setObject:CardIdNum forKey:@"id_number"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_user_realname_Insert_Servlet"];
    
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
 *  获取骑牛token
 */
+(void)getQNtokenSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_QiNiu_Servlet"];
    
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
 *  绑定手机号
 */
+(void)bindingYourPhoneNumByPhoneNum:(NSString *)phoneNum
                             loginId:(NSString *)loginId
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:phoneNum forKey:@"tel"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_user_login_BindingTel_Servlet"];
    
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
 *  查看实名认证信息
 */
+(void)selectRealnameInfoByloginId:(NSString *)loginId
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"auth/info"];
    
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
 *  意见反馈消息
 */
+(void)commitOpinionsByTel:(NSString *)tel
                      text:(NSString *)text
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    [params setObject:USER.tel forKey:@"tel"];
    
    [params setObject:text forKey:@"context"];
    
    [params setObject:userType forKey:@"type"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/opinion"];
    
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
{
    
    NSMutableDictionary *params = [self getAllBasedParams];
    
    !nickName?:[params setObject:nickName forKey:@"nickname"];
    
    !name?:[params setObject:name forKey:@"name"];
    
    iconUrl.length?[params setObject:iconUrl forKey:@"head_img_url"]:nil;
    
    if (height.integerValue == 0) {
        [params setObject:@"165" forKey:@"height"];
    }else{
        [params setObject:height forKey:@"height"];
    }
    
    !cityId?:[params setObject:cityId forKey:@"city_id"];
    
    schoolId.length?[params setObject:schoolId forKey:@"school_id"]:nil;

    inSchoolTime.length?[params setObject:inSchoolTime forKey:@"intoschool_date"]:nil;
    
    !sex?:[params setObject:sex forKey:@"sex"];
    
    !birthDay?:[params setObject:birthDay forKey:@"birth_date"];
    
    !constellation?:[params setObject:constellation forKey:@"constellation"];
    
    qq.length?[params setObject:qq forKey:@"qq"]:nil;
    
    introduce.length?[params setObject:introduce forKey:@"introduce"]:nil;
    
    isStudent.length?[params setObject:isStudent forKey:@"is_student"]:nil;
    
    //credit
    //integral
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/edit"];
    
    [[JGHTTPClient sharedManager] PUT:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            if ([responseObject[@"code"] integerValue] == 600) {
                [self showAlertViewWithText:responseObject[@"message"] duration:1];
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JGLog(@"%@",task.response);
        if (failure) {
            failure(error);
        }
    }];
    
}

/**
 *  查询学校的接口
 */
+(void)searchSchoolByName:(NSString *)name
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    [params setObject:[CityModel city].code forKey:@"city_code"];
    
    !name?:[params setObject:name forKey:@"name"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/school"];
    
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
 *  查询学校的接口
 */
+(void)searchSchoolByName:(NSString *)name
                 cityCode:(NSString *)cityCode
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    !cityCode?:[params setObject:cityCode forKey:@"city_code"];
    
    !name?:[params setObject:name forKey:@"name"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/schoolByCity"];
    
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
 *  查看简历信息
 */
+(void)getJianliInfoByloginId:(NSString *)loginId
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params;
    if (loginId && loginId.integerValue!=0) {
        params = [self getAllBasedParams];
    }
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/info"];
    
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
 *  查看收藏和关注信息
 */
+(void)getcollectionAndAttentionListByloginId:(NSString *)loginId
                                      Success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_attent_Select_Servlet"];
    
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
 *  删除收藏和关注信息
 */
+(void)deleteAcollectionOrattentionByloginId:(NSString *)loginId
                                      dataId:(NSString *)dataId
                                        type:(NSString *)type
                                     Success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    [params setObject:dataId forKey:@"id"];
    
    [params setObject:type forKey:@"type"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_attent_Delete_Id_Servlet"];
    
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
 *  用户支出明细
 */
+(void)lookUserMoneyLogByloginId:(NSString *)loginId
                          type:(NSString *)type
                         count:(NSString *)count
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    [params setObject:type forKey:@"type"];//2=支出,1=收入
    
    [params setObject:count forKey:@"pageNum"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"wallet/log"];
    
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
 *  用户余额查询
 */
+(void)lookUserBalanceByloginId:(NSString *)loginId
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    [params setObject:userType forKey:@"type"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"wallet/money"];
    
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
 *  用户修改支付密码
 */
+(void)alertPayPasswordByloginId:(NSString *)loginId
                        password:(NSString *)password
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    [params setObject:password forKey:@"password"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_user_money_Password_Servlet"];
    
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
 * 绑定支付宝或银行卡：
 */
+(void)bindCardOrAlipayByUserName:(NSString *)userName
                           number:(NSString *)number
                         bankName:(NSString *)bankName
                             type:(NSString *)type
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    [params setObject:type forKey:@"type"];
    
    [params setObject:bankName?bankName:@"" forKey:@"name"];
    
    [params setObject:number forKey:@"number"];
    
    [params setObject:userName forKey:@"receive_name"];

    NSString *Url = [APIURLCOMMON stringByAppendingString:@"wallet/info"];
    
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
 * 查询绑定的收款信息
 */
+(void)getBindInfoSuccess:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"wallet/info"];
    
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
 * 解除绑定信息
 */
+(void)unBindByTypeId:(NSString *)typeId
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    [params setObject:typeId forKey:@"id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"wallet/info"];
    
    [[JGHTTPClient sharedManager] DELETE:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                   failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:loginId forKey:@"login_id"];
    
    [params setObject:openid forKey:@"openid"];
    
    [params setObject:nickname forKey:@"nickname"];
    
    [params setObject:sex forKey:@"sex"];
    
    [params setObject:province forKey:@"province"];
    
    [params setObject:city forKey:@"city"];
    
    [params setObject:country forKey:@"country"];
    
    [params setObject:headimgurl forKey:@"headimgurl"];
    
    if (privilege) {
        [params setObject:privilege forKey:@"privilege"];
    }
    
    [params setObject:unionid forKey:@"unionid"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"T_user_wx_Insert_Servlet"];
    
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
 *  用户提现金额
 */
+(void)PayWageByCode:(NSString *)code
             jsonStr:(NSString *)jsonStr
             Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;
{
    
    NSMutableDictionary *params = [self getAllBasedParams];
    
    [params setObject:jsonStr forKey:@"param"];
    
    [params setObject:code forKey:@"withdrawCode"];
    
    [params setObject:USER.tel forKey:@"tel"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"wallet/money"];
    
    [[JGHTTPClient sharedManager] PUT:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  用户提现获取验证码
 */
+(void)getCodeForCashByphoneNo:(NSString *)phoneNo
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[self getToken] forKey:@"only"];
    
    [params setObject:phoneNo forKey:@"tel"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"IsmsCkeck"];
    
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
 *  拉取别人的个人信息
 */
+(void)getUserInfoWithUserId:(NSString *)userId
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    !userId?:[params setObject:userId  forKey:@"user_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"user/otherinfo"]];
    
    
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
