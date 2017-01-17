//
//  NSDate+HW.m
//  Carpool
//
//  Created by dasmaster on 12-10-11.
//  Copyright (c) 2012年 wsk. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)
@dynamic day,month,year,hour,minute,second;

- (NSString *)convertDateToStringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
//    [dateFormatter setTimeZone:timeZone];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}

+ (NSDate *)stringToDate:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
//    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

- (NSDateComponents *) getDateComponent
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =
    NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return dateComponent;
}

- (NSInteger)year
{
    NSDateComponents *dateComponent = [self getDateComponent];
    return dateComponent.year;
}
- (NSInteger)month
{
    NSDateComponents *dateComponent = [self getDateComponent];
    return dateComponent.month;

}
- (NSInteger)day
{
    NSDateComponents *dateComponent = [self getDateComponent];
    return dateComponent.day;

}
- (NSInteger)hour
{
    NSDateComponents *dateComponent = [self getDateComponent];
    return dateComponent.hour;

}
- (NSInteger)minute
{
    NSDateComponents *dateComponent = [self getDateComponent];
    return dateComponent.minute;

}
- (NSInteger)second
{
    NSDateComponents *dateComponent = [self getDateComponent];
    return dateComponent.second;
}


@end
