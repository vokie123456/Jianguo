//
//  UIView+AlertView.m
//  JianGuo
//
//  Created by apple on 16/3/20.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "UIView+AlertView.h"

#import "DMAlertView.h"

@implementation UIView (AlertView)
- (void)showErrorViewWithText:(NSString *)text {
    DMAlertView *hud = nil;
    hud = [[DMAlertView alloc] initWithView:APPLICATION.keyWindow];
    [APPLICATION.keyWindow addSubview:hud];
    [hud showText:text];
}
- (void)showAlertViewWithText:(NSString *)text duration:(NSTimeInterval)duration {
    DMAlertView *hud = nil;
    hud = [[DMAlertView alloc] initWithView:APPLICATION.keyWindow];
    [APPLICATION.keyWindow addSubview:hud];
    [hud showText:text duration:duration];
}
@end
