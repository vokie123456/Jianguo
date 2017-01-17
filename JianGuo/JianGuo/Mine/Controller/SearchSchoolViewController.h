//
//  SearchSchoolViewController.h
//  JianGuo
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "BaseViewController.h"
@class SchoolModel;
@interface SearchSchoolViewController : UITableViewController

@property (nonatomic,copy)  void(^seletSchoolBlock)(SchoolModel *schoolModel);

@end
