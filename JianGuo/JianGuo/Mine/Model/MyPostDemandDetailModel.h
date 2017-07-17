//
//  MyPostDemandDetailModel.h
//  JianGuo
//
//  Created by apple on 17/7/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPostDemandDetailModel : NSObject


/** 发布者信息 */
@property (nonatomic, copy) NSString* publishHeadImg;

/** 报名者性别 */
@property (nonatomic, copy) NSString*  enrollSex;

/** 任务id */
@property (nonatomic, copy) NSString*  demandId;

/** 标题 */
@property (nonatomic, copy) NSString* title;

/** 报名者昵称 */
@property (nonatomic, copy) NSString* enrollNickname;

/** 任务赏金 */
@property (nonatomic, copy) NSString*  money;

/** 任务状态 */
@property (nonatomic, copy) NSString*  status;

/** 报名者id */
@property (nonatomic, copy) NSString*  enrollUid;

/** 任务时限 */
@property (nonatomic, copy) NSString*  limitTime;

/** 报名人数 */
@property (nonatomic, copy) NSString*  enrollCount;

/** 任务发布时间 */
@property (nonatomic, copy) NSString* createTimeStr;

/** 任务状态数组 */
@property (nonatomic, strong) NSArray* logs;

/** 报名者学校名称 */
@property (nonatomic, copy) NSString* enrollSchoolName;

/** 订单号 */
@property (nonatomic, copy) NSString*  orderNo;

/** 任务描述 */
@property (nonatomic, copy) NSString* demandDesc;

/** 报名者头像 */
@property (nonatomic, copy) NSString* enrollHeadImg;

/** 报名者电话 */
@property (nonatomic, copy) NSString* enrollTel;

/** 创建时间 */
@property (nonatomic, copy) NSString*  createTime;

/** 发布者id */
@property (nonatomic, copy) NSString*  publishUid;

/** 任务时限时间串 */
@property (nonatomic, copy) NSString* limitTimeStr;

/** 报名状态 */
@property (nonatomic, copy) NSString* enrollStatus;

/** 评价状态 */
@property (nonatomic, copy) NSString* evaluateStatus;

/** 完成状态 (0未完成，1正常完成，2超时完成)*/
@property (nonatomic, copy) NSString* completeStatus;

@end
