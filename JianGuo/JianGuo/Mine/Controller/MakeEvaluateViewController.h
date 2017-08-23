//
//  MakeEvaluateViewController.h
//  JianGuo
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface MakeEvaluateViewController : NavigatinViewController

/** 订单号 */
@property (nonatomic,copy) NSString *orderNo;
/** type */
@property (nonatomic,copy) NSString *type;
/** 回调 */
@property (nonatomic,copy) void(^callBackBlock)();

@end
