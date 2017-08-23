//
//  SkillsDetailViewController.h
//  JianGuo
//
//  Created by apple on 17/7/27.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface SkillsDetailViewController : NavigatinViewController

/** 技能id */
@property (nonatomic,copy) NSString *skillId;

/** 回调block */
@property (nonatomic,copy) void(^callBack)(NSInteger collectionStatus);

@end
