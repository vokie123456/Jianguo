//
//  DemandPostModel.h
//  JianGuo
//
//  Created by apple on 17/7/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enrolls.h"

@interface DemandPostModel : NSObject


/** 任务id */
@property (nonatomic, copy) NSString*  demandId;

/** 任务标题 */
@property (nonatomic, copy) NSString* title;

/** 价格 */
@property (nonatomic, copy) NSString*  money;

/** 任务状态 */
@property (nonatomic, copy) NSString*  status;

/** 报名者数组 */
@property (nonatomic, strong) NSArray* enrolls;

/** 报名状态 */
@property (nonatomic, copy) NSString*  enrollStatus;

/** 分类（1我发布，2我报名的） */
@property (nonatomic, copy) NSString*  kind;

/** 时间限制 */
@property (nonatomic, copy) NSString*  limitTime;

/** 完成状态 */
@property (nonatomic, copy) NSString*  completeStatus;

/** 报名数 */
@property (nonatomic, copy) NSString*  enrollCount;

/** 发布者评价状态 */
@property (nonatomic, copy) NSString*  publishEvaluateStatus;

/** 发布时间串 */
@property (nonatomic, copy) NSString* createTimeStr;

/** 任务类型 */
@property (nonatomic, copy) NSString*  demandType;

/** 任务描述 */
@property (nonatomic, copy) NSString* demandDesc;

/** 发布者id */
@property (nonatomic, copy) NSString*  publishUserId;

/** 是否超时 */
@property (nonatomic, copy) NSString*  isTimeout;

/** 评论数 */
@property (nonatomic, copy) NSString*  commentCount;

/** 收到评论状态 */
@property (nonatomic, copy) NSString*  receiveEvaluateStatus;

/** 发布时间戳 */
@property (nonatomic, copy) NSString*  createTime;

/** 时间限制串 */
@property (nonatomic, copy) NSString* limitTimeStr;


// MARK: - 旧接口
///** 任务赏金 */
//@property (nonatomic, copy) NSString*  money;
//
///** 录取人的id */
//@property (nonatomic, copy) NSString*  enrollUserId;
//
///** 任务时限时间 */
//@property (nonatomic, copy) NSString* limitTimeStr;
//
///** 完成状态（0未完成，1正常完成，2超时完成）*/
//@property (nonatomic, copy) NSString*  completestatus;
//
///** 请求类型 <自己发出的请求参数,服务器又返回给我> */
//@property (nonatomic, copy) NSString*  type;
//
///** 任务标题 */
//@property (nonatomic, copy) NSString* title;
//
///** 任务创建时间 */
//@property (nonatomic, copy) NSString* createTimeStr;
//
///** 任务时限时间戳 */
//@property (nonatomic, copy) NSString*  limitTime;
//
///** 报名者昵称 */
//@property (nonatomic, copy) NSString* enrollNickname;
//
///** 任务创建时间戳 */
//@property (nonatomic, copy) NSString*  createTime;
//
///** 报名人数 */
//@property (nonatomic, copy) NSString*  enrollCount;
//
///** 任务图片数组 */
//@property (nonatomic, strong) NSArray* images;
//
///** 报名者头像 */
//@property (nonatomic, copy) NSString* enrollHeadImg;
//
///** 任务类型 */
//@property (nonatomic, copy) NSString*  demandType;
//
///** 任务描述 */
//@property (nonatomic, copy) NSString* demandDesc;
//
///** 任务id */
//@property (nonatomic, copy) NSString*  demandId;
//
///** 任务状态 */
//@property (nonatomic, copy) NSString*  status;
//
///** 是否超时（0未超时，1超时） */
//@property (nonatomic, copy) NSString*  isTimeout;

@end
