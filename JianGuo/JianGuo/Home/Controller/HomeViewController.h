//
//  HomeViewController.h
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"
#import <AVOSCloudIM.h>

@interface HomeViewController : NavigatinViewController

@property (nonatomic,strong) UIView *msgRemindView;
@property (nonatomic,strong) AVIMClient *client;

-(void)requestList:(NSString *)count;

@end
