//
//  CityModel.m
//  JGBuss
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CityModel.h"
#define JGCityModelFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"cityModel.data"]
@interface AreaModel : NSObject

/** 城区id */
@property (nonatomic, copy) NSString*  id;

/** 城市id */
@property (nonatomic, assign) NSInteger  city_id;

/** 城区的名字(海淀) */
@property (nonatomic, copy) NSString* areaName;


@end
@implementation CityModel

+ (NSDictionary *)objectClassInArray// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
{
    return @{@"areaList" : [AreaModel class]   };
}

/**
 *  取出存储的城市对象
 */
+(instancetype)city
{
    CityModel *model = JGKeyedUnarchiver(JGCityModelFile);
    if (!model) {
        NSArray *cityArr = JGKeyedUnarchiver(JGCityArr);
        model = [cityArr objectAtIndex:1];
        model.code = @"0899";
    }
    if (!model.code&&model.id) {
        model.code = model.id;
    }
    return model;
}
/**
 *  存储城市对象
 */
+(void)saveCity:(CityModel *)model
{
    [NSKeyedArchiver archiveRootObject:model toFile:JGCityModelFile];
}

MJExtensionCodingImplementation
@end
