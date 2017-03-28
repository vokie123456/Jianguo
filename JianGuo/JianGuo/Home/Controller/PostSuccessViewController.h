//
//  PostSuccessViewController.h
//  JianGuo
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface PostSuccessViewController : NavigatinViewController

@property (nonatomic,copy) void(^callBackBlock)();

@property (nonatomic,copy) NSString *labelStr;
@property (nonatomic,copy) NSString *detailStr;

@end
