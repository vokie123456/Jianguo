//
//  MyCVViewController.h
//  JianGuo
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface MyCVViewController : NavigatinViewController

@property (nonatomic,copy)  void(^iconImageBlock)(UIImage *);

@property (nonatomic,copy)  void(^reloadView)();

@property (nonatomic,assign) BOOL hadSelectedSchool;

@end
