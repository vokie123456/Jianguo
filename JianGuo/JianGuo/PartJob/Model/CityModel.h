//
//  CityModel.h
//  JGBuss
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject


/** 城市id */
@property (nonatomic, copy) NSString*  id;

/** 城市code */
@property (nonatomic, copy) NSString* code;

/** 城市名字 */
@property (nonatomic, copy) NSString* cityName;

/** 城区数组 */
@property (nonatomic, strong) NSArray* areaList;
/**
 *  取出存储的城市对象
 */
+(instancetype)city;
/**
 *  存储城市对象
 */
+(void)saveCity:(CityModel *)model;

@end
