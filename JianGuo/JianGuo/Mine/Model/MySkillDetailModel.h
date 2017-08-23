//
//  MySkillDetailModel.h
//  JianGuo
//
//  Created by apple on 17/8/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DemandStatusLogModel.h"
#import "AddressModel.h"

@interface MySkillDetailModel : NSObject


/** 订单状态 */
@property (nonatomic, assign) NSInteger  orderStatus;

/** 技能标题 */
@property (nonatomic, copy) NSString* title;

/** 技能数量 */
@property (nonatomic, assign) NSInteger  skillCount;

/** 购买者昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 购买者电话 */
@property (nonatomic, copy) NSString*  tel;

/** 购买者性别 */
@property (nonatomic, assign) NSInteger  sex;

/** 是否修改了价格 */
@property (nonatomic, assign) NSInteger  isAdjust;

/** 购买者头像 */
@property (nonatomic, copy) NSString* headImg;

/** 订单时间 */
@property (nonatomic, copy) NSString* orderTimeStr;

/** 技能id */
@property (nonatomic, assign) NSInteger  skillId;

/** 买家留言 */
@property (nonatomic, copy) NSString* orderMessage;

/** 技能封面 */
@property (nonatomic, copy) NSString* cover;

/** 购买者学校名称 */
@property (nonatomic, copy) NSString* schoolName;

/** 订单状态数组 */
@property (nonatomic, strong) NSArray* logs;

/** 订单号 */
@property (nonatomic, copy) NSString* orderNo;

/** 真实价格 */
@property (nonatomic, assign) CGFloat  realPrice;

/** 服务方式 */
@property (nonatomic, assign) NSInteger  serviceMode;

/** 购买者id */
@property (nonatomic, assign) NSInteger  buyUid;

/** 地址id */
@property (nonatomic, assign) NSInteger  addressId;

/** 订单时间戳 */
@property (nonatomic, assign) NSInteger  orderTime;

/** 地址模型 */
@property (nonatomic, strong) AddressModel * address;

/** 订单价格(未修改前) */
@property (nonatomic, assign) CGFloat  orderPrice;


@end
