//
//  DateOrTimeTool.h
//  JianGuo
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateOrTimeTool : NSObject

/**
 *  获取一个NSDateFormatter 实例
 */
+(NSDateFormatter *)shareAFormatter;
/**
 *  通过时间戳转换成日期
 */
+(NSDate *)getDateByTimeStamp:(NSTimeInterval)timeStamp;
/**
 *  通过字符串转换成时间戳
 */
+(NSTimeInterval)getATimeStampBytimeString:(NSString *)timeStr;
/**
 *  返回一个聊天cell中的时间
 */
+(NSString *)getMessageTime:(NSTimeInterval)timeStamp;
/**
 *  返回一个日期的字符串
 */
+(NSString *)getDateStringBytimeStamp:(NSTimeInterval)timeStamp;
/**
 *  返回几天前
 */
+(NSString *)compareDate:(NSString *)timeStap;

//根据日期计算星座
+(NSString *)getConstellation:(NSString *)dateStr;

@end
