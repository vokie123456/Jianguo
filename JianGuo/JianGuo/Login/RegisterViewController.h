//
//  RegisterViewController.h
//  JianGuo
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface RegisterViewController : NavigatinViewController

@property (nonatomic,copy) void(^phoneNumBlock)(NSString *);
@end
