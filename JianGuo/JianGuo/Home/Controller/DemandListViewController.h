//
//  DemandListViewController.h
//  JianGuo
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface DemandListViewController : NavigatinViewController


@property (nonatomic,copy) NSString *schoolId;
-(void)requestWithCount:(NSString *)count;

@end


