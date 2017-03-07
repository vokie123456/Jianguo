//
//  CitySchoolViewController.h
//  JianGuo
//
//  Created by apple on 17/2/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@class SchoolModel;
@class CityModel;
@interface CitySchoolViewController : NavigatinViewController

@property (nonatomic,copy) void(^selectSchoolBlock)(SchoolModel *school,CityModel *city);

@end
