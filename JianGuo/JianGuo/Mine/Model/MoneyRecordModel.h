//
//  MoneyRecordModel.h
//  JianGuo
//
//  Created by apple on 16/11/30.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyRecordModel : NSObject

/** 兼职图片 */
@property (nonatomic, copy) NSString*   logImg;

/** 兼职名称 */
@property (nonatomic, copy) NSString*   logName;

/** 创建时间 */
@property (nonatomic, copy) NSString*   createTime;

/** 到账时间 */
@property (nonatomic, copy) NSString*   endTime;

/** 状态 1==没到账; 2==已到账 3==拒绝 */
@property (nonatomic, copy) NSString*   status;

/** 备注 */
@property (nonatomic, copy) NSString*   note;

/** 数据id */
@property (nonatomic, copy) NSString*   id;

/** 发钱的商家ID */
@property (nonatomic, copy) NSString*   from_id;

/** 自己的ID */
@property (nonatomic, copy) NSString*   user_id;

/** 支付宝号或者是卡号 */
@property (nonatomic, copy) NSString*   number;

/** 提现去处(1==银行卡 2==支付宝) */
@property (nonatomic, copy) NSString*   pay_type;

/** 
 1;//兼职工资
 5;//充值
 2;//提现
 4;//商家支出工资款（商家端记录信息备用）
 6;//用户发布需求冻结（发需求扣款记录）
 7;//用户下架任务退回的钱
 */
@property (nonatomic, copy) NSString*   type;

/** ??? */
@property (nonatomic, copy) NSString*   pay_type_id;

/** 钱数 */
@property (nonatomic, copy) NSString*   money;
@end
