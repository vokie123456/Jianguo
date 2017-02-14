//
//  JGHTTPClient+ImageUrl.h
//  JianGuo
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient.h"

@interface JGHTTPClient (ImageUrl)

/**
 *  拉取多张头像
 *
 */
+(void)getImagesByUserId:(NSString *)userId
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

/**
 *  上传单张图片到服务器
 *
 */
+(void)uploadImageUrlByImage:(NSString *)imageUrl
                    position:(NSString *)position
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
/**
 *  单独更新头像
 *
 */
+(void)updateHeadImageUrlByImage:(NSString *)imageUrl
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

@end
