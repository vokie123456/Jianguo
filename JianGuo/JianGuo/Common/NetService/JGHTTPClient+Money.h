//
//  JGHTTPClient+Money.h
//  JianGuo
//
//  Created by apple on 17/2/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient.h"

@interface JGHTTPClient (Money)


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
                            failure:(void (^)(NSError *error))failure;

@end
