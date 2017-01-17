//
//  ChatMsgViewController.h
//  JianGuo
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "BaseViewController.h"
#import "NavigatinViewController.h"
#import <AVOSCloudIM.h>

@interface ChatMsgViewController :NavigatinViewController

@property (nonatomic,strong) AVIMConversation *conversation;

@property (nonatomic,copy) void(^sendMessageBlock)(NSString *);

@end
