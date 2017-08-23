//
//  MyBuySkillListModel.h
//  JianGuo
//
//  Created by apple on 17/8/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBuySkillListModel : NSObject

/** 是否修改过价格（0未修改，1修改） */
@property (nonatomic, assign) NSInteger  isAdjust;

/** 修改过的价格（也就是真正的价格 */
@property (nonatomic, assign) CGFloat  realPrice;

/** 退款状态（0没有申请退款，1申请退款） */
@property (nonatomic, assign) NSInteger  refundStatus;

/** 订单金额 */
@property (nonatomic, assign) CGFloat  orderPrice;

/** 创建时间的字符串 */
@property (nonatomic, copy) NSString* createTimeStr;

/** 技能标题 */
@property (nonatomic, copy) NSString* title;

/** 订单号 */
@property (nonatomic, copy) NSString* orderNo;

/** 创建时间毫秒值（13位毫秒值，系统已经转化为字符串）*/
@property (nonatomic, assign) NSInteger  createTime;

/** 订单状态 */
@property (nonatomic, assign) NSInteger  orderStatus;

/** 技能封面 */
@property (nonatomic, copy) NSString* cover;

/** 发布者id */
@property (nonatomic, assign) NSInteger  publishUid;

/** 技能id */
@property (nonatomic, assign) NSInteger  skillId;

/** 发布者昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 退款金额 */
@property (nonatomic, assign) CGFloat  refundPrice;

/** 发布者头像 */
@property (nonatomic, copy) NSString* headImg;


@end


