//
//  DemandModel.m
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandModel.h"

@interface CommentModel : NSObject

/** 被评论的人的ID */
@property (nonatomic, copy) NSString*  to_user_id;

/** 数据ID */
@property (nonatomic, copy) NSString*  id;

/** 评论人的ID */
@property (nonatomic, copy) NSString*  user_id;

/** 评论时间 */
@property (nonatomic, copy) NSString*  create_time;

@end


@implementation DemandModel

+ (NSDictionary *)objectClassInArray// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
{
    return @{
             @"commentEntitys" : [CommentModel class]   };
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName//
{
    return @{
             @"enroll_user_id" : @"demandUserEntity.enroll_user_id"
             };
}


@end
