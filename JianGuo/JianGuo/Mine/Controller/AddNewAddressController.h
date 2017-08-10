//
//  AddNewAddressController.h
//  QQMarket
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NavigatinViewController.h"
#import "AddressModel.h"

@interface AddNewAddressController : NavigatinViewController

@property (nonatomic,assign) BOOL isEditAddress;
@property (nonatomic,strong) AddressModel *model;

@end
