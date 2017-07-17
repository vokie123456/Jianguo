//
//  DemandSignModel.h
//  JianGuo
//
//  Created by apple on 17/6/28.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemandSignModel : NSObject


/** 任务赏金 */
@property (nonatomic, copy) NSString*  money;

/** 任务时限 */
@property (nonatomic, copy) NSString* limitTimeStr;

/** 任务发布者id */
@property (nonatomic, copy) NSString*  publishUserId;

/** 任务发布者昵称 */
@property (nonatomic, copy) NSString* publishNickname;

/** 类型 */
@property (nonatomic, copy) NSString*  demandType;

/** 任务标题 */
@property (nonatomic, copy) NSString* title;

/** 任务发布时间 */
@property (nonatomic, copy) NSString* createTimeStr;

/** 任务时限时间戳 */
@property (nonatomic, copy) NSString*  limitTime;

/** 任务发布时间戳 */
@property (nonatomic, copy) NSString*  createTime;

/** 发布者头像 */
@property (nonatomic, copy) NSString* publishHeadImg;

/** 报名人数 */
@property (nonatomic, copy) NSString*  enrollCount;

/** 图片数组 */
@property (nonatomic, strong) NSArray* images;

/** 任务描述 */
@property (nonatomic, copy) NSString* demandDesc;

/** 任务id */
@property (nonatomic, copy) NSString*  demandId;

/** 任务状态 */
@property (nonatomic, copy) NSString*  status;

/** 报名状态< 1报名中，2录取，3被拒绝，4取消报名 > */
@property (nonatomic, copy) NSString*  enrollStatus;

/** 任务状态分类 */
@property (nonatomic, copy) NSString*  type;

@end
