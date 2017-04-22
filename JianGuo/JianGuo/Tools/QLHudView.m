//
//  QLHudView.m
//  JianGuo
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "QLHudView.h"
#import "DMAlertView.h"
#import "RemindMsgViewController.h"
#import "MyTabBarController.h"

static CGFloat const AlerViewHeight = 64;

@interface QLHudView()

@end

@implementation QLHudView

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static QLHudView *view = nil;
    dispatch_once(&onceToken, ^{
        view = [[self alloc] init];
    });
    return view;
}

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

-(void)showNotificationNews:(NSString *)message
{
    if ([message containsString:@"您有新的消息"]) {
        return;
    }
    [self show:message];
}

-(void)show:(NSString *)message
{
    
    CGRect rect = [message boundingRectWithSize:CGSizeMake(SCREEN_W-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} context:nil];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -(rect.size.height+50)-20, SCREEN_W, (rect.size.height+50)+20)];
    bgView.backgroundColor = RedColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpRemindVC)];
    [bgView addGestureRecognizer:tap];
    
    
    UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, SCREEN_W-40, rect.size.height)];
    contentL.text = message;
    contentL.font = [UIFont boldSystemFontOfSize:14];
    contentL.textColor = WHITECOLOR;
    contentL.numberOfLines = 0;
    contentL.backgroundColor = [UIColor clearColor];
    [bgView addSubview:contentL];
    
    [APPLICATION.keyWindow addSubview:bgView];
    
    CGRect frame = bgView.frame;
    frame.origin.y = -20.f;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        bgView.frame = frame;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(dismiss:) withObject:@{@"height":[NSNumber numberWithFloat:(rect.size.height+50)],@"view":bgView} afterDelay:2];
    }];
}

-(void)jumpRemindVC
{
    
    MyTabBarController *tabVC = (MyTabBarController *)APPLICATION.keyWindow.rootViewController;
    RemindMsgViewController *remindVC = [[RemindMsgViewController alloc] init];
    remindVC.hidesBottomBarWhenPushed = YES;
    NSInteger index =  tabVC.selectedIndex;
    
    [(UINavigationController *)tabVC.viewControllers[index] pushViewController:remindVC animated:YES];
}

-(void)dismiss:(NSDictionary *)params
{
    CGFloat h = [params[@"height"] floatValue];
    UIView *bgView = params[@"view"];
    CGRect frame = bgView.frame;
    frame.origin.y = -h-20;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        bgView.frame = frame;
    } completion:^(BOOL finished) {
//        [APPLICATION setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [bgView removeFromSuperview];
    }];
}

@end
