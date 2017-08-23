//
//  MyBuySkillDetailViewController.h
//  JianGuo
//
//  Created by apple on 17/8/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface MyBuySkillDetailViewController : NavigatinViewController <UIViewControllerTransitioningDelegate>

/** 订单号 */
@property (nonatomic,copy) NSString *orderNo;
@end
