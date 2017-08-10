//
//  JGHTTPClient+Address.m
//  JianGuo
//
//  Created by apple on 17/8/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient+Address.h"

@implementation JGHTTPClient (Address)

/**
 *  我发布的地址列表
 */
+(void)getAddresListWithPageNum:(NSString *)pageNum
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    !pageNum?:[params setObject:pageNum forKey:@"pageNum"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/addresses"];
    
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
 *  保存/更新地址
 */
+(void)saveOrUpdateAddresWithContactName:(NSString *)userName
                                     tel:(NSString *)tel
                                location:(NSString *)location
                               isDefault:(NSString *)isDefault
                               addressId:(NSString *)addressId
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    !userName?:[params setObject:userName forKey:@"consignee"];
    !tel?:[params setObject:tel forKey:@"mobile"];
    !location?:[params setObject:location forKey:@"location"];
    !isDefault?:[params setObject:isDefault forKey:@"isDefault"];
    !addressId?:[params setObject:addressId forKey:@"id"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/address"];
    
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
 *  删除地址
 */
+(void)deleteAddressWithAddress:(NSString *)addressId
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    !addressId?:[params setObject:addressId forKey:@"addressId"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/address-del"];
    
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
 * 设置为默认地址
 */
+(void)setDefaultAddressWithAddress:(NSString *)addressId
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    
    !addressId?:[params setObject:addressId forKey:@"addressId"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/address-default"];
    
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

@end
