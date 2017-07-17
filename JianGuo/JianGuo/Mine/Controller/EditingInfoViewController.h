//
//  EditInfoViewController.h
//  JGBuss
//
//  Created by apple on 17/4/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NavigatinViewController.h"

@interface EditingInfoViewController : NavigatinViewController

@property (nonatomic,copy) void(^editCompletCallBack)(NSString *);
@property (nonatomic,assign) NSInteger  type;
@property (nonatomic,copy) NSString *string;

@end
