//
//  ExportModel.h
//  JianGuo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExportModel : NSObject

/** 提现进度的状态 */
@property (nonatomic, copy) NSString*  status;

/** 数据id */
@property (nonatomic, copy) NSString*  id;

/** 支出钱数 */
@property (nonatomic, copy) NSString*  money;

/** 转出到支付宝,银行卡 */
@property (nonatomic, copy) NSString*  type;

/** 提现的操作时间 */
@property (nonatomic, copy) NSString* time;

/** 用户的登录ID */
@property (nonatomic, copy) NSString*  login_id;

/** 备注 */
@property (nonatomic, copy) NSString*  remarks;

@end
