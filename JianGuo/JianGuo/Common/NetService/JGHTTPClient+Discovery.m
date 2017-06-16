//
//  JGHTTPClient+Discovery.m
//  JianGuo
//
//  Created by apple on 17/5/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient+Discovery.h"

@implementation JGHTTPClient (Discovery)

/**
 *  拉取发现列表
 */
+(void)getDiscoveryListPageNum:(NSString *)pageNum
                       Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{

    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"articles?pageNum=%@",pageNum]];
    
    [[JGHTTPClient sharedManager] GET:Url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  上传浏览量
 */
+(void)postScanCountByArticleId:(NSString *)articleId
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"articles/visit"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    !articleId?:[params setObject:articleId forKey:@"articleId"];
    
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
