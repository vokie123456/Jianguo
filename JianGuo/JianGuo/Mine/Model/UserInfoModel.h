//
//  UserInfoModel.h
//  JianGuo
//
//  Created by apple on 17/6/23.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject


/** <#description#> */
@property (nonatomic, copy) NSString*  sumMoney;

/** 任务数量 */
@property (nonatomic, copy) NSString*  demandNum;

/** 兼职赚得钱 */
@property (nonatomic, copy) NSString*  sumJobMoney;

/** 评价数量 */
@property (nonatomic, copy) NSString*  demandEvaluateNum;

/** 粉丝数 */
@property (nonatomic, copy) NSString*  fansNum;

/** 性别(1=女，2=男) */
@property (nonatomic, copy) NSString*  sex;

/** 点赞数 */
@property (nonatomic, copy) NSString*  praiseNum;

/** 生日 */
@property (nonatomic, copy) NSString* birthDate;

/** 任务赚的钱 */
@property (nonatomic, copy) NSString*  sumDemandMoney;

/** 背景图片 */
@property (nonatomic, copy) NSString* backgroundImg;

/** 钱 */
@property (nonatomic, copy) NSString*  money;

/** 头像 */
@property (nonatomic, copy) NSString* headImg;

/** 用户id */
@property (nonatomic, copy) NSString*  userId;

/** 报名总数 */
@property (nonatomic, copy) NSString*  enrollSumNum;

/** 发布任务数 */
@property (nonatomic, copy) NSString*  releaseJobSumNum;

/** 关注的数 */
@property (nonatomic, copy) NSString*  followNum;

/** 昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 简介 */
@property (nonatomic, copy) NSString* introduce;

/** 审核状态 */
@property (nonatomic, copy) NSString*  authUserStatus;

/** 是否关注 */
@property (nonatomic,copy) NSString *isFollow;

/** 学校名称 */
@property (nonatomic,copy) NSString *schoolName;


@end
