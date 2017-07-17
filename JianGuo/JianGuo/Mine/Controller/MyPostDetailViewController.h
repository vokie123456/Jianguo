//
//  MyPostDetailViewController.h
//  JianGuo
//
//  Created by apple on 17/2/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface MyPostDetailViewController : NavigatinViewController <UIViewControllerTransitioningDelegate>


/** 改变状态的回调 */
@property (nonatomic,copy) void(^changeStatusBlock)();
@property (nonatomic,copy) NSString *demandId;
@property (nonatomic,copy) NSString *type;//前一个页面传过来的,决定显示几个按钮
@property (nonatomic,assign) BOOL isTimeOut;//为 真 时,–––>有拒绝支付按钮
@property (nonatomic,copy) NSString *statusStr;

@end
