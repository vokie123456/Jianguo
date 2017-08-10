//
//  BillsViewController.h
//  JianGuo
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"
#import "ZJScrollPageView.h"

@interface BillsViewController : NavigatinViewController <ZJScrollPageViewChildVcDelegate>


@property (nonatomic,copy) NSString *type;

@property (nonatomic,assign) BOOL isFromGetCash;

/**  */
@property (nonatomic,assign,getter=isBool) BOOL boolValue;

@end
