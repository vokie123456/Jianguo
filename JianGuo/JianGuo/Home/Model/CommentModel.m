//
//  commentModel.m
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "CommentModel.h"

@interface CommentUser : NSObject

@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *userId;

@end

@implementation CommentModel


+ (NSDictionary *)objectClassInArray// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
{
    return @{
             @"users" : [CommentUser class]   };
}

@end
