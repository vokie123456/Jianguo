//
//  TextReasonViewController.h
//  JianGuo
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, ControllerFunctionType) {
    ControllerFunctionTypeRefusePay,
    ControllerFunctionTypePublisherEvualuate,
    ControllerFunctionTypePublisherComplain,
    ControllerFunctionTypeWaiterEvaluate,
    ControllerFunctionTypeSkillApplyRefund
};

@interface TextReasonViewController : BaseViewController


@property (nonatomic,copy) void(^callBackBlock)();
@property (nonatomic,copy) NSString *demandId;

@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,assign) ControllerFunctionType functionType;
@property (nonatomic,copy) NSString *contentTitle;
@property (nonatomic,copy) NSString *userId;

@end
