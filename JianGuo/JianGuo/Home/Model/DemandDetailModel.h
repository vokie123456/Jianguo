//
//  DemandDetailModel.h
//  JianGuo
//
//  Created by apple on 17/6/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemandDetailModel : NSObject


/** 发布者id */
@property (nonatomic, copy) NSString*  userId;

/** 任务id */
@property (nonatomic, copy) NSString*  demandId;

/** 任务标题 */
@property (nonatomic, copy) NSString* title;

/** 赏金金额 */
@property (nonatomic, copy) NSString*  money;

/** 是否匿名 */
@property (nonatomic, copy) NSString*  anonymous;

/** 学校id */
@property (nonatomic, copy) NSString*  schoolId;

/** 昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 发布任务的数量 */
@property (nonatomic, copy) NSString*  publishDemandCount;

/** 浏览次数 */
@property (nonatomic, copy) NSString*  viewCount;

/** 学校名称 */
@property (nonatomic, copy) NSString* schoolName;

/** 图片数组 */
@property (nonatomic, strong) NSArray* images;

/** 用户头像 */
@property (nonatomic, copy) NSString* headImg;

/** 生日 */
@property (nonatomic, copy) NSString* birthDate;

/** 任务时限 */
@property (nonatomic, copy) NSString*  limitTime;

/** 任务状态 */
@property (nonatomic, copy) NSString*  demandStatus;

/** 报名人数 */
@property (nonatomic, copy) NSString*  enrollCount;

/** 任务类型 */
@property (nonatomic, copy) NSString*  type;

/** 完成的任务数量 */
@property (nonatomic, copy) NSString*  completedDemandCount;

/** 城市code */
@property (nonatomic, copy) NSString*  cityCode;

/** 评论数 */
@property (nonatomic, copy) NSString*  commentCount;

/** 发布时间 */
@property (nonatomic, copy) NSString*  createTime;

/** 点赞数 */
@property (nonatomic, copy) NSString*  likeCount;

/** 城市名称 */
@property (nonatomic, copy) NSString* cityName;

/** 兴趣标签，数组，<暂无> */
@property (nonatomic, strong) NSArray* interests;

/** 任务描述 */
@property (nonatomic, copy) NSString* demandDesc;

/** 性别 */
@property (nonatomic, copy) NSString* sex;

/** 时限字符串 */
@property (nonatomic, copy) NSString* limit_time_str;

/** 审核状态 */
@property (nonatomic, copy) NSString* authStatus;

/** 是否点过赞 0没有点赞，1表示点赞 */
@property (nonatomic, copy) NSString* isLike;

/** 是否可以报名 1可以报名，2不能报名 */
@property (nonatomic, copy) NSString* canEnroll;

/** 报名状态 -1报名后取消，0未报名，1已经报名，2已经录取，3已经拒绝*/
@property (nonatomic, copy) NSString* enrollStatus;

/** 是否关注 */
@property (nonatomic, copy) NSString* isFollow;


@end
