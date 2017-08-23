//
//  SkillDetailModel.h
//  JianGuo
//
//  Created by apple on 17/8/10.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkillDetailModel : NSObject

/** 点赞数 */
@property (nonatomic, assign) NSInteger  likeCount;

/** 分类id */
@property (nonatomic, assign) NSInteger  categoryId;

/** 达人称谓 */
@property (nonatomic, copy) NSString* masterTitle;

/** 认证状态 */
@property (nonatomic, assign) NSInteger  authStatus;

/** 技能状态(0==正常接单;  1==暂停接单) */
@property (nonatomic, assign) NSInteger  status;

/** 是否关注（0未关注，1关注） */
@property (nonatomic, assign) NSInteger  isFollow;

/** 用户学校 */
@property (nonatomic, assign) NSInteger  userSchoolId;

/** 销量 */
@property (nonatomic, assign) NSInteger  saleCount;

/** 评论数 */
@property (nonatomic, assign) NSInteger  commentCount;

/** 昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 服务方式（1到店，2线上，3上门，4邮寄） */
@property (nonatomic, assign) NSInteger  serviceMode;

/** 技能描述 */
@property (nonatomic, copy) NSString* skillDesc;

/** 发布任务数量 */
@property (nonatomic, assign) NSInteger  publishDemandCount;

/** 发布者学校名称 */
@property (nonatomic, copy) NSString* publishSchoolName;

/** 发布者城市名称 */
@property (nonatomic, copy) NSString* publishCityName;

/** 是否收藏 （0为收藏，1收藏） */
@property (nonatomic, assign) NSInteger  isFavourite;

/** 发布者id */
@property (nonatomic, assign) NSInteger  publishUid;

/** 星星数 */
@property (nonatomic, assign) NSInteger  starNum;

/** 生日 */
@property (nonatomic, copy) NSString* birthDate;

/** 技能资质 */
@property (nonatomic, copy) NSString* skillAptitude;

/** 平均得分 */
@property (nonatomic, assign) CGFloat  averageScore;

/** 性别（1表示女，2表示男） */
@property (nonatomic, assign) NSInteger  sex;

/** 完成任务数 */
@property (nonatomic, assign) NSInteger  completedDemandCount;

/** 发布者学校id */
@property (nonatomic, assign) NSInteger  publishSchoolId;

/** 浏览数 */
@property (nonatomic, assign) NSInteger  viewCount;

/** 分类名称 */
@property (nonatomic, copy) NSString* categoryName;

/** 是否是达人（0不是，1是） */
@property (nonatomic, assign) NSInteger  isMaster;

/** 用户学校名称 */
@property (nonatomic, copy) NSString* userSchoolName;

/** 技能价格 */
@property (nonatomic, copy) NSString*  price;

/** 服务地址 */
@property (nonatomic, copy) NSString* serviceAddress;

/** 技能描述的图片集合 */
@property (nonatomic, strong) NSArray* descImages;

/** 技能资质的图片集合 */
@property (nonatomic, strong) NSArray* aptitudeImages;

/** 技能id */
@property (nonatomic, assign) NSInteger  skillId;

/** 是否点赞（0未点赞，1点赞） */
@property (nonatomic, assign) NSInteger  isLike;

/** 技能标题 */
@property (nonatomic, copy) NSString* title;

/** 价格描述 */
@property (nonatomic, copy) NSString* priceDesc;

/** 发布到的城市code */
@property (nonatomic, assign) NSInteger  publishCityCode;

/** 头像 */
@property (nonatomic, copy) NSString* headImg;

/** 技能图片 */
@property (nonatomic, copy) NSString* cover;

@end
