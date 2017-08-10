//
//  MySkillsChildViewController.h
//  JianGuo
//
//  Created by apple on 17/8/2.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"
#import "ZJScrollPageView.h"

@interface MySkillsChildViewController : NavigatinViewController <ZJScrollPageViewChildVcDelegate>

/** 技能状态type */
@property (nonatomic,copy) NSString *type;

@end
