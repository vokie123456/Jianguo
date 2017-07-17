//
//  QLSVProgressHud.m
//  QQMarket
//
//  Created by apple on 16/5/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "QLSVProgressHud.h"
#import "UIImage+GIF.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation QLSVProgressHud

+(void)showLoadingViewWithStatus:(NSString *)status
{
    
    [SVProgressHUD showWithStatus:status];
    
//    // 设置显示最小时间 以便观察效果
//    [SVProgressHUD setMinimumDismissTimeInterval:MAXFLOAT];
//    // 设置背景颜色为透明色
//    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
//    
//    // 利用SVP提供类方法设置 通过UIImage分类方法返回的动态UIImage对象
//    [SVProgressHUD showImage:[UIImage imageWithGIFNamed:@"loading01"] status:status];
    
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
