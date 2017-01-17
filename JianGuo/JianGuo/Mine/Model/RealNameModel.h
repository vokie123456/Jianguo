//
//  RealNameModel.h
//  JianGuo
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealNameModel : NSObject


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
@property (nonatomic, copy) NSString*  sex;

@end
