//
//  SelectCityController.h
//  JianGuo
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"

@interface SelectCityController : UITableViewController

@property (nonatomic,strong) NSMutableArray *dataArr;


@property (nonatomic,copy) void(^selectCityBlock)(CityModel *);

@end
