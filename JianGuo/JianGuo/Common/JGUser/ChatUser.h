//
//  ChatUser.h
//  JianGuo
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCChatKit.h"

@interface ChatUser : NSObject<LCCKUserDelegate>

//@property (nonatomic,copy) NSString *name;
//
//@property (nonatomic,copy) NSString *userId;
//
//@property (nonatomic,copy) NSString *avatarUrl;

/**
 *  检查与 aPerson 是否表示同一对象
 */
- (BOOL)isEqualToUer:(ChatUser *)user;

- (void)saveToDiskWithKey:(NSString *)key;

+ (id)loadFromDiskWithKey:(NSString *)key;

@end
