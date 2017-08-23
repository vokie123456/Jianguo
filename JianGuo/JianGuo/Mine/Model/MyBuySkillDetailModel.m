//
//  MyBuySkillDetailModel.m
//  JianGuo
//
//  Created by apple on 17/8/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyBuySkillDetailModel.h"


@implementation MyBuySkillDetailModel

+ (NSDictionary *)objectClassInArray// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
{
    return @{@"address" : [AddressModel class], @"logs" : [DemandStatusLogModel class]    };
}

@end
