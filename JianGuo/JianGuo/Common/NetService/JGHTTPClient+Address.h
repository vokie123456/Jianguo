//
//  JGHTTPClient+Address.h
//  JianGuo
//
//  Created by apple on 17/8/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient.h"

@interface JGHTTPClient (Address)


/**
 *  我发布的地址列表
 */
+(void)getAddresListWithPageNum:(NSString *)pageNum
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

/**
 *  保存/更新地址
 */
+(void)saveOrUpdateAddresWithContactName:(NSString *)userName
                                     tel:(NSString *)tel
                                location:(NSString *)location
                               isDefault:(NSString *)isDefault
                               addressId:(NSString *)addressId
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;

/**
 *  删除地址
 */
+(void)deleteAddressWithAddress:(NSString *)addressId
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

/**
 * 设置为默认地址
 */
+(void)setDefaultAddressWithAddress:(NSString *)addressId
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;


@end
