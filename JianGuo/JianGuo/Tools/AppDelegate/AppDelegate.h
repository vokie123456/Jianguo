//
//  AppDelegate.h
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
//如果使用了实时通信模块，请添加下列导入语句到头部：///
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) AVIMClient *client;


@end

