//
//  JGHTTPClient+Job.h
//  JianGuo
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JGHTTPClient.h"

@interface JGHTTPClient (Job)
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
                    failure:(void (^)(NSError *error))failure;
@end
