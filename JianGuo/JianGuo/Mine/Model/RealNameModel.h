//
//  RealNameModel.h
//  JianGuo
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealNameModel : NSObject


//========  以下是新接口字段  =====


/** 学生证图片 */
@property (nonatomic, copy) NSString* studentNoImg;

/** 学校id */
@property (nonatomic, copy) NSString*  schoolId;

/** <#description#> */
@property (nonatomic, copy) NSString*  sex;

/** 生日 */
@property (nonatomic, copy) NSString* birthDate;

/** 身份证正面 */
@property (nonatomic, copy) NSString* frontImg;

/** 学号 */
@property (nonatomic, copy) NSString* studentNo;

/** 身份证背面 */
@property (nonatomic, copy) NSString* behindImg;

/** 身份证号 */
@property (nonatomic, copy) NSString* identityCard;

/** 用户id */
@property (nonatomic, copy) NSString*  userId;

/** 真实姓名 */
@property (nonatomic, copy) NSString* realName;

/** 学校名称 */
@property (nonatomic, copy) NSString* schoolName;

/** 认证状态（1未审核，2通过, 3审核中，4 拒绝 */
@property (nonatomic, copy) NSString*  authStatus;



//========  以下是老接口字段  =====

/** 身份证号 */
@property (nonatomic, copy) NSString*  IDcard;

/** 审核状态 */
@property (nonatomic, copy) NSString*  auth_status;

/** 数据ID */
@property (nonatomic, copy) NSString*  id;

/** 背面身份证照片 */
@property (nonatomic, copy) NSString* behind_img_url;

/** 正面身份证照片 */
@property (nonatomic, copy) NSString* front_img_url;

/** 真实姓名 */
@property (nonatomic, copy) NSString*  realname;

/** ??? */
@property (nonatomic, copy) NSString*  type;

/** 性别 */
//@property (nonatomic, copy) NSString*  sex;

@end
