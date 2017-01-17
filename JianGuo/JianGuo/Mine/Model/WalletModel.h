//
//  WalletModel.h
//  JianGuo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletModel : NSObject

/** 绑定的支付宝或者银行卡号 */
@property (nonatomic, copy) NSString *  number;

/** 收款信息的ID */
@property (nonatomic, copy) NSString *  id;

/** 收款人的ID */
@property (nonatomic, copy) NSString *  user_id;

/** 银行卡=1,支付宝=2,微信=3 */
@property (nonatomic, copy) NSString *  type;

/** 收款人的名字 */
@property (nonatomic, copy) NSString* receive_name;

/** 银行的名字 */
@property (nonatomic, copy) NSString* name;

/** 支付密码 */
@property (nonatomic, copy) NSString* pay_password;

/** 微信是否绑定 */
@property (nonatomic, copy) NSString* weixin;

/** 钱包余额(本来不属于这个对象) */
@property (nonatomic, copy) NSString* money;

+ (instancetype)userWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */
+(void)saveWallet:(WalletModel *)wallet;

/**
 *  返回存储的账号信息
 */
+ (WalletModel *)wallet;


@end
