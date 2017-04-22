//
//  JGHTTPClient+Money.m
//  JianGuo
//
//  Created by apple on 17/2/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient+Money.h"

@implementation JGHTTPClient (Money)


/**
 *  上传支付结果信息
 *  bill_type == (weixin 1, alipay 2)
 */
+(void)uploadOrderPayResultWithType:(NSString *)bill_type
                              title:(NSString *)bill_title
                              money:(NSString *)bill_money
                             detail:(NSString *)bill_detail
                               code:(NSString *)bill_code
                              beeNo:(NSString *)bee_no
                            orderId:(NSString *)order_id
                             userId:(NSString *)pay_user_id
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    !bill_type?:[params setObject:bill_type forKey:@"bill_type"];
    !bill_title?:[params setObject:bill_title forKey:@"bill_title"];
    !bill_money?:[params setObject:bill_money forKey:@"bill_money"];
    !bill_detail?:[params setObject:bill_detail forKey:@"bill_detail"];
    !bill_code?:[params setObject:bill_code forKey:@"bill_code"];
    !bee_no?:[params setObject:bee_no forKey:@"bee_no"];
    !order_id?:[params setObject:order_id forKey:@"order_no"];
    !pay_user_id?:[params setObject:pay_user_id forKey:@"pay_user_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"wallet/recharge"];
    
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

@end
