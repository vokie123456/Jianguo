//
//  DetailModel.h
//  JianGuo
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

/** 商家头像 */
@property (nonatomic, copy) NSString* head_img_url;

/** 其他 */
@property (nonatomic, copy) NSString* other;

/** 录取人数 */
@property (nonatomic, copy) NSString*  count;

/** 报名人数 */
@property (nonatomic, copy) NSString*  user_count;

/** 集合时间 */
@property (nonatomic, copy) NSString* set_time;

/** 集合地点 */
@property (nonatomic, copy) NSString* set_place;

/** 停止日期 */
@property (nonatomic, copy) NSString*  end_date;

/** 商家ID */
@property (nonatomic, copy) NSString*  user_id;

/** 商家电话 */
@property (nonatomic, copy) NSString*  tel;

/** 停止时间 */
@property (nonatomic, copy) NSString*  end_time;

/** 工作内容 */
@property (nonatomic, copy) NSString* content;

/** 兼职头像 */
@property (nonatomic, copy) NSString* job_image;

/** 兼职Id */
@property (nonatomic, copy) NSString*  id;

/** 商家姓名 */
@property (nonatomic, copy) NSString* contact_name;

/** 商家关于 */
@property (nonatomic, copy) NSString* merchant_about;

/** 工作要求 */
@property (nonatomic, copy) NSString* require;

/** 开始日期 */
@property (nonatomic, copy) NSString*  start_date;

/** 开始时间 */
@property (nonatomic, copy) NSString*  begin_time;

/** 发布时间(日期字符串) */
@property (nonatomic, copy) NSString* reg_date;

/** 发布时间(时间戳) */
@property (nonatomic, copy) NSString* createTime;

/** 工资 */
@property (nonatomic, copy) NSString* money;

/** 性别限制 */
@property (nonatomic, copy) NSString* limit_sex;

/** 招聘总数 */
@property (nonatomic, copy) NSString*  sum;

/** 工作地址 */
@property (nonatomic, copy) NSString* address;

/** 兼职名称 */
@property (nonatomic, copy) NSString* job_name;

/** 结算方式id */
@property (nonatomic, copy) NSString* mode;

/** 工资计算方式 */
@property (nonatomic, copy) NSString* term;

/** 结算方式名称 */
@property (nonatomic, copy) NSString* mode_name;

/** 兼职状态 */
@property (nonatomic, copy) NSString* status;

/** 是否收藏 */
@property (nonatomic, copy) NSString* isFavorite;

/** 是否报名 */
@property (nonatomic, copy) NSString* isEnroll;

/** 是否报名(0=没报名,1=已报名) */
@property (nonatomic, copy) NSString* join_status;


/** 商家权限（3是内部,2是外部商家，1是个人商户） */
@property (nonatomic, copy) NSString* bus_type;

/** 商家权限（3是内部,2是外部商家，1是个人商户）<新版本里加的一个字段值跟 bus_type 是一样的> */
@property (nonatomic, copy) NSString* permissions;

/** 限制数组 */
@property (nonatomic,copy) NSArray *limits_name;

/** 福利数组 */
@property (nonatomic,copy) NSArray *welfare_name;

/** 标签数组 */
@property (nonatomic,copy) NSArray *label_name;

@end
