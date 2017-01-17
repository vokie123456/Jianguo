//
//  QLAlertView.h
//  JianGuo
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLAlertView : NSObject

+(void)showAlertTittle:(NSString *)tittle message:(NSString *)message isOnlySureBtn:(BOOL)isOnlySure compeletBlock:(void(^)())block;
+(void)showAlertTittle:(NSString *)tittle message:(NSString *)message;

@end
