//
//  JGHTTPClient+Job.m
//  JianGuo
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JGHTTPClient+Job.h"
#import "CityModel.h"

@implementation JGHTTPClient (Job)
/**
 *  兼职筛选排序：
 *
 */
+(void)getJobsListByHotType:(NSString *)type
                     cityId:(NSString *)cityId
                     areaId:(NSString *)areaId
               sequenceType:(NSString *)sequenceType
                      count:(NSString *)count
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
   
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setObject:count forKey:@"pageNum"];
    if (type) {
        [params setObject:type forKey:@"job_type_id"];
    }
    if (areaId) {
        [params setObject:areaId forKey:@"area_id"];
    }
    if (sequenceType) {
        [params setObject:sequenceType forKey:@"order_field"];
    }
    NSString *Url = [APIURLCOMMON stringByAppendingString:[NSString stringWithFormat:@"job/user/list/%@",cityId]];
    
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

@end
