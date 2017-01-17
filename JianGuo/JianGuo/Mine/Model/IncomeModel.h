//
//  IncomeModel.h
//  JianGuo
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IncomeModel : NSObject

/** 用户登录Id */
@property (nonatomic, copy) NSString*   login_id;

/** 工作Id */
@property (nonatomic, copy) NSString*   job_id;

/** 应发工资 */
@property (nonatomic, copy) NSString*   hould_money;

/** 对象Id */
@property (nonatomic, copy) NSString*   Id;

/** 备注信息 */
@property (nonatomic, copy) NSString* remarks;

/** 注册时间 */
@property (nonatomic, copy) NSString* reg_time;

/** 实发工资 */
@property (nonatomic, copy) NSString*   real_money;
/** 兼职图片 */
@property (nonatomic, copy) NSString*   job_image;
/** 兼职名称 */
@property (nonatomic, copy) NSString*   job_name;
/** 开始日期 */
@property (nonatomic, copy) NSString*   job_start;
/** 结束日期 */
@property (nonatomic, copy) NSString*   job_stop;

@end
