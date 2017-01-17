//
//  NameIdManger.m
//  JGBuss
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NameIdManger.h"

@implementation NameIdManger

/**
 *  获取热门,普通等兼职级别名字
 */
+(NSString *)getHotNameById:(NSString *)hotId
{
    NSInteger ID = hotId.integerValue;
    switch (ID) {
        case 0:{
            
            return @"普通";
            
            break;
        } case 1:{
            
            return @"热门";
            
            break;
        } case 2:{
            
            return @"精品";
            
            break;
        } case 3:{
            
            return @"旅行";
            
            break;
        }
        default:
            return nil;
            break;
    }

}
/**
 *  获取结算方式名字的
 */
+(NSString *)getModeNameById:(NSString *)modeId
{
    NSInteger ID = modeId.integerValue;
    switch (ID) {
        case 0:{
            
            return @"月结";
            
            break;
        } case 1:{
            
            return @"周结";
            
            break;
        } case 2:{
            
            return @"日结";
            
            break;
        } case 3:{
            
            return @"旅行";
            
            break;
        }
        default:
            return nil;
            break;
    }
}
/**
 *  获取工资计算方式的名字
 */
+(NSString *)getTermNameById:(NSString *)termId
{
    NSInteger ID = termId.integerValue;
    switch (ID) {
        case 0:{
            
            return @"元/月";
            
            break;
        } case 1:{
            
            return @"元/周";
            
            break;
        } case 2:{
            
            return @"元/天";
            
            break;
        } case 3:{
            
            return @"元/小时";
            
            break;
        } case 4:{
            
            return @"元/次";
            
            break;
        } case 5:{
            
            return @"义工";
            
            break;
        } case 6:{
            
            return @"面议";
            
            break;
        }
        default:
            return nil;
            break;
    }
}
/**
 *  获取性别限制
 */
+(NSString *)getgenderNameById:(NSString *)sexId
{
    NSInteger ID = sexId.integerValue;
    switch (ID) {
        case 0:{
            
            return @"只招女";
            
            break;
        } case 1:{
            
            return @"只招男";
            
            break;
        } case 2:{
            
            return @"不限男女";
            
            break;
        } case 3:{
            
            return @"男女各限";
            
            break;
        } case 30:{
            
            return @"只招女";
            
            break;
        } case 31:{
            
            return @"只招男";
            
            break;
        }
        default:
            return nil;
            break;
    }
}

@end
