//
//  MyPostDemandDetailModel.m
//  JianGuo
//
//  Created by apple on 17/7/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyPostDemandDetailModel.h"
#import "DemandStatusLogModel.h"

@implementation MyPostDemandDetailModel

+ (NSDictionary *)objectClassInArray// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
{
    return @{
             @"logs" : [DemandStatusLogModel class]   };
}

@end
