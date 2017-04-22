//
//  DemandStatusModel.h
//  JianGuo
//
//  Created by apple on 17/3/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemandStatusModel : NSObject


/**
 *  学校所属的城市ID
 */
@property (nonatomic,copy) NSString *content;

/**
 *  学校所属的城市ID
 */
@property (nonatomic,copy) NSString *time;

/**
 *  学校所属的城市ID
 */
@property (nonatomic,copy) NSString *username;

/**
 *  是不是已经完成的状态
 */
@property (nonatomic,assign) BOOL isFinished;



@end
