//
//  MoneyRecordModel.m
//  JianGuo
//
//  Created by apple on 16/11/30.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MoneyRecordModel.h"
#import "DetailModel.h"
/*
 job_image
 job_name
 start_date
 end_date
 */
@implementation MoneyRecordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName//
{
    return @{
             @"job_image" : @"jobEntity.job_image" ,
             @"job_name" : @"jobEntity.job_name" ,
             @"start_date" : @"jobEntity.start_date" ,
             @"end_date" : @"jobEntity.end_date"    };
}



@end
