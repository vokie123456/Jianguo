//
//  DemandDetailController.h
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface DemandDetailController : NavigatinViewController

@property (nonatomic,copy) void(^callBackBlock)();

@property (nonatomic,strong) NSString *demandId;

@property (nonatomic,assign) BOOL isSelf;

@end
