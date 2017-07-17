//
//  SignUsers.h
//  JianGuo
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUsers : NSObject


/** 录取状态 <1报名装态; 2录取状态; 3拒绝状态> */
@property (nonatomic, copy) NSString*  enrollStatus;

/** 性别 */
@property (nonatomic, copy) NSString*  sex;

/** 昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 头像 */
@property (nonatomic, copy) NSString* headImg;

/** 学校名称 */
@property (nonatomic, copy) NSString* schoolName;

/** 报名者id */
@property (nonatomic, copy) NSString*  enrollUid;

/** 任务状态 */
@property (nonatomic, copy) NSString*  demandStatus;

//======= 以下是老版接口返回数据 =======

/** 昵称 */
//@property (nonatomic, copy) NSString* nickname;

/** 学校 */
@property (nonatomic, copy) NSString* name;

/** 数据ID */
@property (nonatomic, copy) NSString*  id;

/** 报名状态 */
@property (nonatomic, copy) NSString*  enroll_status;

/** 报名时间 */
@property (nonatomic, copy) NSString*  create_time;

/** 用户ID */
@property (nonatomic, copy) NSString*  b_user_id;

/** 也是用户ID */
@property (nonatomic, copy) NSString*  user_id;

/** 需求ID */
@property (nonatomic, copy) NSString*  d_id;

/** 用户头像 */
@property (nonatomic, copy) NSString* head_img_url;

/** 个人介绍 */
@property (nonatomic, copy) NSString* introduce;

/** ??? */
@property (nonatomic, copy) NSString*  auth_time;

/** ??? */
@property (nonatomic, copy) NSString*  integral;

/** 城市ID */
@property (nonatomic, copy) NSString* city_id;

/** 用户电话 */
@property (nonatomic, copy) NSString*  tel;


/** 用户出生日期 */
@property (nonatomic, copy) NSString* birth_date;

/** 性别 */
//@property (nonatomic, copy) NSString*  sex;

/** ??? */
@property (nonatomic, copy) NSString* sign_text;

/** 学校ID */
@property (nonatomic, copy) NSString* school_id;

/** 星座 */
@property (nonatomic, copy) NSString*  constellation;


/** 学校名称 */
@property (nonatomic, copy) NSString* school_name;



/** 入学日期 */
@property (nonatomic, copy) NSString* intoschool_date;

/** 邮箱 */
@property (nonatomic, copy) NSString* email;

/** 身高 */
@property (nonatomic, copy) NSString*  height;

/** ??? */
@property (nonatomic, copy) NSString*  credit;

/** 地区ID */
@property (nonatomic, copy) NSString* area_id;

/** QQ号 */
@property (nonatomic, copy) NSString*  qq;

/** 是否是学生 */
@property (nonatomic, copy) NSString*  is_student;

@end
