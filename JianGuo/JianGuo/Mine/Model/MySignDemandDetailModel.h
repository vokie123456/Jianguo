//
//  MySignDemandDetailModel.h
//  JianGuo
//
//  Created by apple on 17/7/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySignDemandDetailModel : NSObject



/** 任务状态 */
@property (nonatomic, copy) NSString*  status;

/** 报名状态 */
@property (nonatomic, copy) NSString*  enrollStatus;

/** 任务赏金 */
@property (nonatomic, copy) NSString*  money;

/** 任务发布时间串 */
@property (nonatomic, copy) NSString* createTimtStr;

/** 发布者电话 */
@property (nonatomic, copy) NSString*  publishTel;

/** 任务时限时间串 */
@property (nonatomic, copy) NSString* limitTimeStr;

/** 发布者学校名称 */
@property (nonatomic, copy) NSString* publishSchoolName;

/** 发布者昵称 */
@property (nonatomic, copy) NSString* publishNickname;

/** 发布者头像 */
@property (nonatomic, copy) NSString* publishHeadImg;

/** 任务标题 */
@property (nonatomic, copy) NSString* title;

/** 订单号 */
@property (nonatomic, copy) NSString*  orderNo;

/** 任务时限时间戳 */
@property (nonatomic, copy) NSString*  limitTime;

/** 任务发布时间戳 */
@property (nonatomic, copy) NSString*  createTime;

/** 状态数组 */
@property (nonatomic, strong) NSArray* logs;

/** 发布者id */
@property (nonatomic, copy) NSString*  publishUid;

/** 任务描述 */
@property (nonatomic, copy) NSString* demandDesc;

/** 任务id */
@property (nonatomic, copy) NSString*  demandId;

/** 发布者性别 */
@property (nonatomic, copy) NSString*  publishSex;

/** 是否评价过 */
@property (nonatomic, copy) NSString*  evaluateStatus;

@end
