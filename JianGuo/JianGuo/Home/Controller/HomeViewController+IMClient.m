//
//  HomeViewController+IMClient.m
//  JianGuo
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "HomeViewController+IMClient.h"

@implementation HomeViewController (IMClient)


#pragma mark - AVIMClientDelegate 代理方法

// 接收消息的回调函数
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    JGLog(@"%@", message.text); // 耗子，起床！
    
    [NotificationCenter postNotificationName:kNotificationDidReceiveMessage object:message];
    
}

@end
