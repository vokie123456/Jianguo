//
//  QLSVProgressHud.h
//  QQMarket
//
//  Created by apple on 16/5/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLSVProgressHud : NSObject

+(void)showLoadingViewWithStatus:(NSString *)status;

+(void)showSuccessHudWithStatus:(NSString *)status;

+(void)showFaildHudWithStatus:(NSString *)status;

+(void)dismiss;

@end
