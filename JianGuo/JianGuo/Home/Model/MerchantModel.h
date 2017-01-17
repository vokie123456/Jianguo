//
//  MerchantModel.h
//  JianGuo
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantModel : NSObject

/** 商家id */
@property (nonatomic, copy) NSString*   id;

/** 标签 */
@property (nonatomic, copy) NSString*   label;

/** 注册时间 */
@property (nonatomic, copy) NSString*   regedit_time;

/** 粉丝数 */
@property (nonatomic, copy) NSString*   fans_count;

/** 商家简介 */
@property (nonatomic, copy) NSString*   about;

/** 共服务多少用户 */
@property (nonatomic, copy) NSString*   user_count;

/** 是否关注 */
@property (nonatomic, copy) NSString*   is_follow;

/** 头像 */
@property (nonatomic, copy) NSString*   name_image;

/** 用户登录表关联ID */
@property (nonatomic, copy) NSString*   login_id;

/** 已提供多少次兼职 */
@property (nonatomic, copy) NSString*   job_count;

/** 登录时间 */
@property (nonatomic, copy) NSString*   login_time;

/** 评分 */
@property (nonatomic, copy) NSString*   score;

/** 商家名称 */
@property (nonatomic, copy) NSString*   name;

/** 在招的岗位数 */
@property (nonatomic, copy) NSString*   post;

/** 商家电话 */
@property (nonatomic, copy) NSString*   tel;


@end
