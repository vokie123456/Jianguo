//
//  MySkillListModel.h
//  JianGuo
//
//  Created by apple on 17/8/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySkillListModel : NSObject


/** 是修改过价格（0未修改，1修改） */
@property (nonatomic, assign) NSInteger  isAdjust;

/** 订单真正的金额 */
@property (nonatomic, assign) CGFloat  realPrice;

/** 申请退款的状态（0未申请，1申请退款） */
@property (nonatomic, assign) NSInteger  refundStatus;

/** 订单金额 */
@property (nonatomic, assign) CGFloat  orderPrice;

/** 创建时间的字符串 */
@property (nonatomic, copy) NSString* createTimeStr;

/** 技能标题 */
@property (nonatomic, copy) NSString* title;

/** 订单号 */
@property (nonatomic, copy) NSString* orderNo;

/** 创建时间戳 */
@property (nonatomic, assign) NSInteger  createTime;

/** 订单状态 */
@property (nonatomic, assign) NSInteger  orderStatus;

/** 技能封面 */
@property (nonatomic, copy) NSString* cover;

/** 技能id */
@property (nonatomic, assign) NSInteger  skillId;

/** 购买者昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 申请退款的金额 */
@property (nonatomic, assign) CGFloat  refundPrice;

/** 购买者头像 */
@property (nonatomic, copy) NSString* headImg;

/** 购买者id */
@property (nonatomic, assign) NSInteger  buyUid;

@end
