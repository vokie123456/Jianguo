//
//  NameIdManger.h
//  JGBuss
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameIdManger : NSObject
/**
 *  获取热门,普通等兼职级别名字
 */
+(NSString *)getHotNameById:(NSString *)hotId;
/**
 *  获取结算方式名字的
 */
+(NSString *)getModeNameById:(NSString *)modeId;
/**
 *  获取工资计算方式的名字
 */
+(NSString *)getTermNameById:(NSString *)termId;
/**
 *  获取性别限制
 */
+(NSString *)getgenderNameById:(NSString *)sexId;
/**
 *  获取结算方式名字的
 */
//+(NSString *)getTermNameById:(NSString *)termId;
@end
