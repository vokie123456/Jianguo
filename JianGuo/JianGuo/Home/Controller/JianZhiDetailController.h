//
//  JianZhiDetailController.h
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"
@class JianzhiModel;

@interface JianZhiDetailController : NavigatinViewController


@property (nonatomic,copy) NSAttributedString *sendCount;

@property (nonatomic,copy) NSString *jobId;

@property (nonatomic,copy) NSString *merchantId;

@property (nonatomic,copy) NSString *loginId;

@property (nonatomic,strong) JianzhiModel *jzModel;

@end
