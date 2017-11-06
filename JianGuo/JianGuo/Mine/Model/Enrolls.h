//
//  Enrolls.h
//  JianGuo
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

/**======= 报名人 ========*/
@interface Enrolls : NSObject

/** 任务id */
@property (nonatomic, copy) NSString*  demandId;

/** 报名状态 */
@property (nonatomic, copy) NSString*  enrollStatus;

/** 昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 头像 */
@property (nonatomic, copy) NSString* headImg;

/** 报名者id */
@property (nonatomic, copy) NSString*  enrollUid;

@end
