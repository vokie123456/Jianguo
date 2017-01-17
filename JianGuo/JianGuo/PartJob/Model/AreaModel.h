//
//  AreaModel.h
//  JGBuss
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaModel : NSObject

/** 城区id */
@property (nonatomic, copy) NSString*  id;

/** 城市id */
@property (nonatomic, assign) NSInteger  city_id;

/** 城区的名字(海淀) */
@property (nonatomic, copy) NSString* areaName;

@end
