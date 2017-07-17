//
//  DemandStatusParentViewController.h
//  JianGuo
//
//  Created by apple on 17/6/27.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"
#import "ZJScrollPageView.h"

@interface DemandStatusParentViewController : NavigatinViewController <ZJScrollPageViewChildVcDelegate,UIViewControllerTransitioningDelegate>
/** 不同状态的参数<1待录取 2、待完成 3、待确认 4、待评价 5已结束> */
@property (nonatomic,copy) NSString *type;

@end
