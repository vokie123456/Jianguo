//
//  commentModel.m
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "CommentModel.h"



@implementation CommentModel


+ (NSDictionary *)objectClassInArray// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
{
    return @{
             @"childComments" : [CommentModel class]   };
}
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
  return @{@"pid":@"pId"};
}

@end
