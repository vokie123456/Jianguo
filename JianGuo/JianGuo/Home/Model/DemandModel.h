//
//  DemandModel.h
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemandModel : NSObject


/** 任务ID */
@property (nonatomic, copy) NSString*  demandId;

/** 用户ID */
@property (nonatomic, copy) NSString*  userId;

/** 用户的学校 */
@property (nonatomic, copy) NSString*  userSchoolName;

/** 学校id */
@property (nonatomic, copy) NSString*  schoolId;

/** 任务发布到的学校 */
@property (nonatomic, copy) NSString*  schoolName;

/** 头像 */
@property (nonatomic, copy) NSString*  headImg;

/** 头像 */
@property (nonatomic, copy) NSArray*  images;

/** 报名人数 */
@property (nonatomic, copy) NSString*  enrollCount;

/** 需求的发布时间 */
@property (nonatomic, copy) NSString*  createTime;

/** 需求所属城市code */
@property (nonatomic, copy) NSString*  cityCode;

/** 需求类型 */
@property (nonatomic, copy) NSString*  type;

/** 评论数 */
@property (nonatomic, copy) NSString*  commentCount;

/** 点赞数 */
@property (nonatomic, copy) NSString*  likeCount;

/** 是否关注 */
@property (nonatomic, copy) NSString*  isFollow;

/** 所属城市 */
@property (nonatomic, copy) NSString*  cityName;

/** 任务描述 */
@property (nonatomic, copy) NSString*  demandDesc;




//以下是老接口数据

/** 数据ID */
@property (nonatomic, copy) NSString*  id;

/** 赏金 */
@property (nonatomic, copy) NSString*  money;

/** 昵称 */
@property (nonatomic, copy) NSString*  nickname;

/** 头像 */
@property (nonatomic, copy) NSString*  head_img_url;

/** 发需求的人的性别 */
@property (nonatomic, copy) NSString*  sex;

/** 是不是匿名 */
@property (nonatomic, copy) NSString*  anonymous;

/** 所属区域 */
@property (nonatomic, copy) NSString*  area;

/** 所属城市 */
@property (nonatomic, copy) NSString*  city;

/** 需求图片 */
@property (nonatomic, copy) NSString* d_image;

/** 需求状态 */
@property (nonatomic, copy) NSString* d_status;

/** 需求类型 */
@property (nonatomic, copy) NSString* d_type;

/** 需求描述 */
@property (nonatomic, copy) NSString* d_describe;

/** 需求标题 */
@property (nonatomic, copy) NSString* title;

/** 评论数组 */
@property (nonatomic, strong) NSArray* commentEntitys;

/** 点赞数 */
@property (nonatomic, copy) NSString*  like_count;

/** 点赞数 */
@property (nonatomic, copy) NSString*  like_status;

/** 报名状态 */
@property (nonatomic, copy) NSString*  enroll_status;

/** 报名人数 */
@property (nonatomic, copy) NSString*  enroll_count;

/** 报名人ID */
@property (nonatomic, copy) NSString*  enroll_user_id;

/** 发需求者的用户ID */
@property (nonatomic, copy) NSString*  b_user_id;

/** 需求的发布时间 */
@property (nonatomic, copy) NSString*  create_time;

/** 评论总数 */
@property (nonatomic, copy) NSString*  comment_count;

/** 学校ID */
@property (nonatomic, copy) NSString*  school_id;

/** 学校名称 */
@property (nonatomic, copy) NSString*  school_name;

/** 发布者电话 */
@property (nonatomic, copy) NSString*  tel;

@end
