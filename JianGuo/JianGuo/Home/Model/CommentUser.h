//
//  CommentUser.h
//  JianGuo
//
//  Created by apple on 17/1/10.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentUser : NSObject

/**
 *  用户昵称
 */
@property (nonatomic,copy) NSString *nickName;
/**
 *  用户ID
 */
@property (nonatomic,copy) NSString *userId;
/**
 *  性别
 */
@property (nonatomic,copy) NSString *sex;
/**
 *  姓名
 */
@property (nonatomic,copy) NSString *name;
/**
 *  用户头像
 */
@property (nonatomic,copy) NSString *userImage;

@end
