//
//  JGHTTPClient.h
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "NSObject+HudView.h"

@interface JGHTTPClient : AFHTTPSessionManager

+ (instancetype)sharedManager;
+(void)cancelAllRequest;

+(void)startRequestWithUrl:(NSString *)url params:(NSMutableDictionary *)params;

/**
    获取 兼职信息
 */
+ (void)getInfoOfPartJob:(int)count
                  GameZoneType:(int)type
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
/**
 获取 单个聊天用户信息
 */
+ (void)getChatUserInfoByLoginId:(NSString *)loginId
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
/**
 获取 多个聊天用户信息
 */
+ (void)getGroupChatUserInfoByLoginId:(NSString *)loginIds
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;


/**
 获取 多个聊天用户信息
 */
+ (void)getGroup222ChatUserInfoByLoginId:(NSString *)loginId
                              Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
/**
 获取 滑动图片
 */
+ (void)getScrollViewImagesSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
/**
 *  地区类型信息
 */
+(void)getAreaInfoByloginId:(NSString *)loginId
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
/**
 *  生成token
 */
+(NSString *)getToken;

/**
 *  获取时间戳
 *
 *  @return 时间戳字符串
 */
+(NSString *)getTimeStamp;

/**
 *  获取app_id
 */
+(NSString *)getAppIdwithStr:(NSString *)phone;

/**
 *  获取签名sign
 */
+(NSString *)getSign:(NSString *)timeStamp;

/**
 *  获取带基本参数的参数字典
 *
 *  @return 带app_id这种基本参数的参数字典
 */
+(NSMutableDictionary *)getBasedParams:(NSString *)phoneNum;


/**
 *  获取带所有基本参数的参数字典 <timestamp,sign,app_id>
 *
 *  @return 带app_id这种基本参数的参数字典
 */
+(NSMutableDictionary *)getAllBasedParams;


/**
 *  把字典转成json字符串
 *
 *  @param dic 要转成json的字典
 *
 *  @return json字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
