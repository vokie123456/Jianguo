//
//  StatusManager.h
//  JianGuo
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusManager : NSObject
/**
 *  获取要改变的状态值
 *
 */
+(NSString *)getNextStatus:(NSString *)currentStatus;

@end
