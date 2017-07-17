//
//  ShareSuccessViewController.h
//  JianGuo
//
//  Created by apple on 17/7/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface ShareSuccessViewController : NavigatinViewController

/** 任务id */
@property (nonatomic,copy) NSString *demandId;
/** 任务标题 */
@property (nonatomic,copy) NSString *demandTitle;
/** 任务金额 */
@property (nonatomic,copy) NSString *money;

@end
