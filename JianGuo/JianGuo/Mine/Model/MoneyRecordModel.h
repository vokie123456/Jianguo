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
@property (nonatomic, copy) NSString*   job_image;

/** 兼职名称 */
@property (nonatomic, copy) NSString*   job_name;

/** 开始日期 */
@property (nonatomic, copy) NSString*   start_date;

/** 结束日期 */
@property (nonatomic, copy) NSString*   end_date;

/** 创建时间 */
@property (nonatomic, copy) NSString*  createTime;

/** 状态 */
@property (nonatomic, copy) NSString*  status;

/** 备注 */
@property (nonatomic, copy) NSString* note;

/** 数据id */
@property (nonatomic, copy) NSString*  id;

/** 发钱的商家ID */
@property (nonatomic, copy) NSString*  from_id;

/** 自己的ID */
@property (nonatomic, copy) NSString*  user_id;

/** 提现到支付宝或者银行卡 */
@property (nonatomic, copy) NSString*  type;

/** ??? */
@property (nonatomic, copy) NSString*  pay_type_id;

/** 钱数 */
@property (nonatomic, copy) NSString*  money;
@end
