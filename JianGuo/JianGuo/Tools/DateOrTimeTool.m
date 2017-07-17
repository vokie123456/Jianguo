//
//  DateOrTimeTool.m
//  JianGuo
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "DateOrTimeTool.h"
#import "NSDate+CalculateDay.h"

@implementation DateOrTimeTool

/**
 *  获取一个NSDateFormatter 实例
 */
+(NSDateFormatter *)shareAFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t ontetoken;
    dispatch_once(&ontetoken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone systemTimeZone];//设置成这样能解决相差8小时的问题
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        [formatter setLocale:[NSLocale currentLocale]];
    });
    return formatter;
}
/**
 *  通过时间戳转换成日期
 */
+(NSDate *)getDateByTimeStamp:(NSTimeInterval)timeStamp{

    return [NSDate dateWithTimeIntervalSince1970:timeStamp];

}
/**
 *  通过字符串转换成时间戳
 */
+(NSTimeInterval)getATimeStampBytimeString:(NSString *)timeStr{

    return [[[self shareAFormatter] dateFromString:timeStr] timeIntervalSince1970];
    
}

/**
 *  返回一个日期的字符串
 */
+(NSString *)getDateStringBytimeStamp:(NSTimeInterval)timeStamp
{
    return [[self shareAFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp]];
}

/**
 *  返回一个聊天cell中的时间
 */
+(NSString *)getMessageTime:(NSTimeInterval)timeStamp
{
    NSDate *date = [self getDateByTimeStamp:timeStamp];
    NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
    if (timeNow-3600*24*7>=timeStamp) {//已经超过一个星期了,需要显示具体日期
        
        NSString *timeString = [[self shareAFormatter] stringFromDate:[self getDateByTimeStamp:timeStamp]];
        
        return [timeString substringFromIndex:5];
        
    }else{//只显示星期几,小时和分钟
        NSString *weekStr = [date weekdayNameCN:NO];
         NSString *timeS = [[self shareAFormatter] stringFromDate:[self getDateByTimeStamp:timeStamp]];
        NSArray *array = [timeS componentsSeparatedByString:@" "];
        NSString *timeStr = [array objectAtIndex:(array.count-1)];
        
        NSString *timeString = [[weekStr stringByAppendingString:@" "] stringByAppendingString:timeStr];
        return timeString;
    }
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    // 2.当前时区和指定时间的时间差
//    NSInteger seconds = [zone secondsFromGMTForDate:now];
//    NSDate *newDate = [now dateByAddingTimeInterval:seconds];
    
}

+(NSString *)compareDate:(NSString *)timeStap{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStap longLongValue]
                    ];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday,*beforYestoday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforYestoday = [today dateByAddingTimeInterval:(-secondsPerDay*2)];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * beforeyestodayStr = [[beforYestoday description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:beforeyestodayStr])
    {
        return @"前天";
    }
    else
    {
        return dateString;
    }
}

//根据日期计算星座
+(NSString *)getConstellation:(NSString *)dateStr
{
    //dateStr–––>  2017-02-08
    if (dateStr.length>=8) {
        NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
        NSInteger month = [arr[1] integerValue];
        NSInteger day = [arr.lastObject integerValue];
        return [self getConstellationWithMonth:month day:day];
    }else
        return nil;
}

+ (NSString *)getConstellationWithMonth:(NSInteger)month day:(NSInteger)day
{
    NSString * astroString = @"摩羯座水瓶座双鱼座白羊座金牛座双子座巨蟹座狮子座处女座天秤座天蝎座射手座摩羯座";
    NSString * astroFormat = @"102123444543";
    NSString * result;
    
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*3-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*3, 3)]];
    
    return result;
}


@end
