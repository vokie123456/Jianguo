//
//  JianzhiModel.h
//  JianGuo
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JianzhiModel : NSObject

/** 工资结算方式 */

@property (nonatomic,copy) NSString *mode;
/** 兼职id */
@property (nonatomic, copy) NSString*  id;

/** 要招的总人数 */
@property (nonatomic, copy) NSString*  sum;

/** 兼职的浏览次数 */
@property (nonatomic, copy) NSString*  browse_count;

/** 开始时间 */
@property (nonatomic, copy) NSString*  start_date;

/** 工资钱 */
@property (nonatomic, copy) NSString*  money;

/** 注册时间 */
@property (nonatomic, copy) NSString* regedit_time;

/** 已录取人数 */
@property (nonatomic, copy) NSString*  count;

/** 已报名人数 */
@property (nonatomic, copy) NSString*  user_count;

/** 结束时间 */
@property (nonatomic, copy) NSString*  end_date;

/** 不知道(应该是工作几天) */
@property (nonatomic, copy) NSString*  day;

/** 兼职图片 */
@property (nonatomic, copy) NSString* job_image;

/** 分类（0=热门兼职，1=精品兼职，2=普通兼职） */
@property (nonatomic, copy) NSString*  hot;

/** 分类（0=短期，1=长期，2=实习生, 3=旅行） */
@property (nonatomic, copy) NSString*  max;

/** 城市id */
@property (nonatomic, copy) NSString*  city_id;

/** 工作地址 */
@property (nonatomic, copy) NSString* address;

/** 性别限制（0=只招女，1=只招男，2=不限男女） */
@property (nonatomic, copy) NSString*  limit_sex;

/** 期限（1=月结，2=周结，3=日结，4=小时结） */
@property (nonatomic, copy) NSString*  term;

/** 商家ID */
@property (nonatomic, copy) NSString*  merchant_id;

/** 状态（1=招聘中，2=暂停中, 3=已招满, 4=已下架） */
@property (nonatomic, copy) NSString*  status;

/** 名称 */
@property (nonatomic, copy) NSString* job_name;

/** 兼职于用户的状态 */
@property (nonatomic,copy) NSString *user_status;

/** 工作开始时间 */
@property (nonatomic, copy) NSString* begin_time;

/** 工作结束时间 */
@property (nonatomic, copy) NSString* end_time;


@end
