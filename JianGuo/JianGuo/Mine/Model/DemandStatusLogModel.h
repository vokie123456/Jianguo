//
//  DemandStatusLogModel.h
//  JianGuo
//
//  Created by apple on 17/7/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemandStatusLogModel : NSObject

/** 任务id */
@property (nonatomic, copy) NSString*  demandId;

/** 状态触发时间 */
@property (nonatomic, copy) NSString*  createTime;

/** 状态内容 */
@property (nonatomic, copy) NSString* content;

/** 状态类型 */
@property (nonatomic, copy) NSString* type;

/** 状态触发时间串 */
@property (nonatomic, copy) NSString* createTimeStr;

@end
