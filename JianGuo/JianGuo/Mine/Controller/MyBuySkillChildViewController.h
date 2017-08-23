//
//  MyBuySkillChildViewController.h
//  JianGuo
//
//  Created by apple on 17/8/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"
#import "ZJScrollPageView.h"

@interface MyBuySkillChildViewController : NavigatinViewController <ZJScrollPageViewChildVcDelegate,UIViewControllerTransitioningDelegate>

/** 技能状态type */
@property (nonatomic,copy) NSString *type;
@end
