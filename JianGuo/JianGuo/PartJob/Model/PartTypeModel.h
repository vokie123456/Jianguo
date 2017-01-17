//
//  PartTypeModel.h
//  JGBuss
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartTypeModel : NSObject

/** 兼职种类id */
@property (nonatomic, copy) NSString*  id;

/** 种类名字(酒店服务员) */
@property (nonatomic, copy) NSString* name;

/** 是否被选中 */
@property (nonatomic, assign) BOOL is_type;

@end
