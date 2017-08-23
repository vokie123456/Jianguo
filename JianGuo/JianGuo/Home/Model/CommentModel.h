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
//@property (nonatomic, copy) NSString*  id;

/** 评论人的ID */
@property (nonatomic, copy) NSString*  user_id;

/** 评论时间 */
@property (nonatomic, copy) NSString*  create_time;

/** 评论的用户信息 */
@property (nonatomic, strong) NSArray* users;

/** 评论内容 */
//@property (nonatomic, copy) NSString* content;

//********* 新版本 评论模型 ***********//

/** 数据id */
@property (nonatomic, copy) NSString*  id;

/** 评论头像 */
@property (nonatomic, copy) NSString* headImg;

/** 是不是发布者 */
@property (nonatomic, copy) NSString*  isPublishUser;

/** 评论子数组 */
@property (nonatomic, strong) NSArray* childComments;

/** 创建时间串<1小时前> */
@property (nonatomic, copy) NSString* createTimeStr;

/** 用户id */
@property (nonatomic, copy) NSString*  userId;

/** 创建时间戳 */
@property (nonatomic, copy) NSString*  createTime;

/** 能不能被删除 */
@property (nonatomic, copy) NSString*  canDelete;

/** 用户昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 如果大于零证明是子评论 */
@property (nonatomic, copy) NSString*  pid;

/** 如果大于零证明是子评论(技能模块的字段) */
//@property (nonatomic, copy) NSString*  pId;

/** 需求id */
@property (nonatomic, copy) NSString*  demandId;

/** 评论内容 */
@property (nonatomic, copy) NSString* content;


@end
