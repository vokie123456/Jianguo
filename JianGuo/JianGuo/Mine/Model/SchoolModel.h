//
//  SchoolModel.h
//  JianGuo
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolModel : NSObject

/**
 *  学校所属的城市ID
 */
@property (nonatomic,copy) NSString *city_id;
/**
 *  学校ID
 */
@property (nonatomic,copy) NSString *id;
/**
 *  学校名称
 */
@property (nonatomic,copy) NSString *name;

@end
