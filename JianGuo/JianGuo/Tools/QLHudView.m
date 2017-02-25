//
//  QLHudView.m
//  JianGuo
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "QLHudView.h"
#import "DMAlertView.h"

@implementation QLHudView

+ (void)showErrorViewWithText:(NSString *)text {
    DMAlertView *hud = nil;
    hud = [[DMAlertView alloc] initWithView:APPLICATION.keyWindow];
    [APPLICATION.keyWindow addSubview:hud];
    [hud showText:text];
}
+ (void)showAlertViewWithText:(NSString *)text duration:(NSTimeInterval)duration {
    DMAlertView *hud = nil;
    hud = [[DMAlertView alloc] initWithView:APPLICATION.keyWindow];
    [APPLICATION.keyWindow addSubview:hud];
    [hud showText:text duration:duration];
}

@end
