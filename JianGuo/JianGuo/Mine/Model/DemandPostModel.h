//
//  DemandPostModel.h
//  JianGuo
//
//  Created by apple on 17/7/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemandPostModel : NSObject


/** 任务赏金 */
@property (nonatomic, copy) NSString*  money;

/** 录取人的id */
@property (nonatomic, copy) NSString*  enrollUserId;

/** 任务时限时间 */
@property (nonatomic, copy) NSString* limitTimeStr;

/** 完成状态（0未完成，1正常完成，2超时完成）*/
@property (nonatomic, copy) NSString*  completestatus;

/** 请求类型 <自己发出的请求参数,服务器又返回给我> */
@property (nonatomic, copy) NSString*  type;

/** 任务标题 */
@property (nonatomic, copy) NSString* title;

/** 任务创建时间 */
@property (nonatomic, copy) NSString* createTimeStr;

/** 任务时限时间戳 */
@property (nonatomic, copy) NSString*  limitTime;

/** 报名者昵称 */
@property (nonatomic, copy) NSString* enrollNickname;

/** 任务创建时间戳 */
@property (nonatomic, copy) NSString*  createTime;

/** 报名人数 */
@property (nonatomic, copy) NSString*  enrollCount;

/** 任务图片数组 */
@property (nonatomic, strong) NSArray* images;

/** 报名者头像 */
@property (nonatomic, copy) NSString* enrollHeadImg;

/** 任务类型 */
@property (nonatomic, copy) NSString*  demandType;

/** 任务描述 */
@property (nonatomic, copy) NSString* demandDesc;

/** 任务id */
@property (nonatomic, copy) NSString*  demandId;

/** 任务状态 */
@property (nonatomic, copy) NSString*  status;

/** 是否超时（0未超时，1超时） */
@property (nonatomic, copy) NSString*  isTimeout;

@end
