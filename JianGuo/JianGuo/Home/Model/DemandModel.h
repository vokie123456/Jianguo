//
//  DemandModel.h
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemandModel : NSObject


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

/** 发需求者的用户ID */
@property (nonatomic, copy) NSString*  b_user_id;

/** 需求的发布时间 */
@property (nonatomic, copy) NSString*  create_time;

/** 评论总数 */
@property (nonatomic, copy) NSString*  comment_count;

/** 学校ID */
@property (nonatomic, copy) NSString*  school_id;

@end
