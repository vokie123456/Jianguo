//
//  MySignDetailViewController.h
//  JianGuo
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface MySignDetailViewController : NavigatinViewController <UIViewControllerTransitioningDelegate>

/** 改变状态的回调 */
@property (nonatomic,copy) void(^changeStatusBlock)();
@property (nonatomic,copy) NSString *statusStr;
@property (nonatomic,copy) NSString *type;//前一个页面传过来的,决定显示几个按钮
@property (nonatomic,copy) NSString *demandId;

@end
