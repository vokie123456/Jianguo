//
//  SignUsers.h
//  JianGuo
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUsers : NSObject


/** 昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 学校 */
@property (nonatomic, copy) NSString* name;

/** 数据ID */
@property (nonatomic, copy) NSString*  id;

/** 报名状态 */
@property (nonatomic, copy) NSString*  enroll_status;

/** 报名时间 */
@property (nonatomic, copy) NSString*  create_time;

/** 用户ID */
@property (nonatomic, copy) NSString*  user_id;

/** 需求ID */
@property (nonatomic, copy) NSString*  d_id;

/** 用户头像 */
@property (nonatomic, copy) NSString* head_img_url;

@end
