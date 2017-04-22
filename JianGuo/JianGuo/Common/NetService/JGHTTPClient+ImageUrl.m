//
//  JGHTTPClient+ImageUrl.m
//  JianGuo
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "JGHTTPClient+ImageUrl.h"

@implementation JGHTTPClient (ImageUrl)

/**
 *  拉取多张头像
 *
 */
+(void)getImagesByUserId:(NSString *)userId
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    !userId?:[params setObject:userId forKey:@"user_id"];
    
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/getHeadImages"];
    
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
 *  上传单张图片到服务器
 *
 */
+(void)uploadImageUrlByImage:(NSString *)imageUrl
                    position:(NSString *)position
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:imageUrl forKey:@"img"];
    [params setObject:position forKey:@"position"];
    [params setObject:USER.login_id forKey:@"user_id"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/replaceImg"];
    
    [[JGHTTPClient sharedManager] PUT:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 *  单独更新头像
 *
 */
+(void)updateHeadImageUrlByImage:(NSString *)imageUrl
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [self getAllBasedParams];
    [params setObject:imageUrl forKey:@"head_img_url"];
    
    NSString *Url = [APIURLCOMMON stringByAppendingString:@"user/updateImg"];
    
    [[JGHTTPClient sharedManager] PUT:Url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
