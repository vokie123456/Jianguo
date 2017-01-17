//
//  QLSVProgressHud.m
//  QQMarket
//
//  Created by apple on 16/5/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "QLSVProgressHud.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation QLSVProgressHud

+(void)showLoadingViewWithStatus:(NSString *)status
{
    [SVProgressHUD showWithStatus:status];
    
}

+(void)showSuccessHudWithStatus:(NSString *)status
{
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+(void)showFaildHudWithStatus:(NSString *)status
{
    [SVProgressHUD showErrorWithStatus:status];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+(void)dismiss
{
    [SVProgressHUD dismiss];
}

@end
