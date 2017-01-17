//
//  QLAlertView.m
//  JianGuo
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "QLAlertView.h"

@implementation QLAlertView

+(void)showAlertTittle:(NSString *)tittle message:(NSString *)message isOnlySureBtn:(BOOL)isOnlySure compeletBlock:(void(^)())block
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:tittle message:message preferredStyle:UIAlertControllerStyleAlert];
    if (isOnlySure) {
        UIAlertAction *sureAC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:block];
        [alertVC addAction:sureAC];
    }else{
        
        UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:block];
        [alertVC addAction:cancelAC];
        [alertVC addAction:sureAC];

    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

+(void)showAlertTittle:(NSString *)tittle message:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:tittle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAC];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}


@end
