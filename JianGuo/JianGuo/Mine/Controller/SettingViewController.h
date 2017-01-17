//
//  SettingViewController.h
//  JianGuo
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "BaseViewController.h"
#import "NavigatinViewController.h"

@interface SettingViewController : NavigatinViewController

@property (nonatomic,copy) void(^refreshBlock)();

@end
