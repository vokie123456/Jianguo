//
//  DemandPostModel.m
//  JianGuo
//
//  Created by apple on 17/7/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandPostModel.h"


@implementation DemandPostModel

+ (NSDictionary *)objectClassInArray// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
{
    return @{@"enrolls" : [Enrolls class]};
}

@end
