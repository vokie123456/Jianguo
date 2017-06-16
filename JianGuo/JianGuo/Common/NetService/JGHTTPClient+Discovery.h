//
//  JGHTTPClient+Discovery.h
//  JianGuo
//
//  Created by apple on 17/5/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient.h"

@interface JGHTTPClient (Discovery)

/**
 *  拉取发现列表
 */
+(void)getDiscoveryListPageNum:(NSString *)pageNum
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
/**
 *  上传浏览量
 */
+(void)postScanCountByArticleId:(NSString *)articleId
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

@end
