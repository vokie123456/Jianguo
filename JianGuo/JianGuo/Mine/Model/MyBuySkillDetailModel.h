//
//  MyBuySkillDetailModel.h
//  JianGuo
//
//  Created by apple on 17/8/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DemandStatusLogModel.h"
#import "AddressModel.h"

@interface MyBuySkillDetailModel : NSObject


/** 订单状态 */
@property (nonatomic, assign) NSInteger  orderStatus;

/** 技能标题 */
@property (nonatomic, copy) NSString* title;

/** 技能数量 */
@property (nonatomic, assign) NSInteger  skillCount;

/** 昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 电话 */
@property (nonatomic, copy) NSString*  tel;

/** 服务者性别 */
@property (nonatomic, assign) NSInteger  sex;

/** 是否修改过价格 */
@property (nonatomic, assign) NSInteger  isAdjust;

/** 服务者头像 */
@property (nonatomic, copy) NSString* headImg;

/** 订单时间串 */
@property (nonatomic, copy) NSString* orderTimeStr;

/** 技能id */
@property (nonatomic, assign) NSInteger  skillId;

/** 买家留言 */
@property (nonatomic, copy) NSString* orderMessage;

/** 技能封面 */
@property (nonatomic, copy) NSString* cover;

/** 服务者学校 */
@property (nonatomic, copy) NSString* schoolName;

/** 订单状态流程数组 */
@property (nonatomic, strong) NSArray* logs;

/** 订单号 */
@property (nonatomic, copy) NSString* orderNo;

/** 修改后的价格 */
@property (nonatomic, assign) CGFloat  realPrice;

/** 服务方式（1到店，2线上，3上门，4邮寄） */
@property (nonatomic, assign) NSInteger  serviceMode;

/** 服务方式（1到店，2线上，3上门，4邮寄） */
@property (nonatomic, copy) NSString*  serviceAddress;

/** 地址id */
@property (nonatomic, assign) NSInteger  addressId;

/** 订单时间戳 */
@property (nonatomic, assign) NSInteger  orderTime;

/** 服务者id */
@property (nonatomic, assign) NSInteger  publishUid;

/** 地址 */
@property (nonatomic, strong) AddressModel * address;

/** 订单修改前的价格 */
@property (nonatomic, assign) NSInteger  orderPrice;


@end
