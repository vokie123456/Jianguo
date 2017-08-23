//
//  AddressListViewController.h
//  JianGuo
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@class AddressListCell,AddressModel;
@interface AddressListViewController : NavigatinViewController


@property (nonatomic,assign) BOOL isFromPlaceOrderVC;

@property (nonatomic,copy) void (^selectAddressBlock)(AddressModel *model,AddressListCell *cell);
@end
