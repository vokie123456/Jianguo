//
//  commentModel.h
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

/** 被评论的人的ID */
@property (nonatomic, copy) NSString*  to_user_id;

/** 数据ID */
@property (nonatomic, copy) NSString*  id;

/** 评论人的ID */
@property (nonatomic, copy) NSString*  user_id;

/** 评论时间 */
@property (nonatomic, copy) NSString*  create_time;

/** 评论的用户信息 */
@property (nonatomic, strong) NSArray* users;

/** 评论内容 */
@property (nonatomic, copy) NSString* content;

@end
