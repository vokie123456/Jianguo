//
//  GetCashViewController.h
//  JianGuo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface GetCashViewController : NavigatinViewController

@property (nonatomic,copy) void(^refreshBlock)();

@property (nonatomic,copy) NSString *sumMoney;
@end
