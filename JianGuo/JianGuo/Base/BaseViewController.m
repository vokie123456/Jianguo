//
//  BaseViewController.m
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginNew2ViewController.h"
#import "DMAlertView.h"
#import "MobClick.h"
#import <POP.h>

@interface BaseViewController ()<UIGestureRecognizerDelegate>
{
    
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [self.view addGestureRecognizer:_swipeGestureRecognizer];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.backgroundColor = BACKCOLORGRAY;
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

/**
 *  页面即将出现方法
 */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
/**
 *  页面即将消失方法
 */
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)showErrorViewWithText:(NSString *)text {
    DMAlertView *hud = nil;
    hud = [[DMAlertView alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud showText:text];
}
- (void)showAlertViewWithText:(NSString *)text duration:(NSTimeInterval)duration {
    DMAlertView *hud = nil;
    hud = [[DMAlertView alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud showText:text duration:duration];
}


#pragma 正则匹配手机号
- (BOOL)checkTelNumber:(NSString*) phoneNum

{
    phoneNum = [phoneNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *pattern =@"^1+[3578]+\\d{9}";
    
    NSPredicate*pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNum];
    
    return isMatch;
    
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(BOOL)checkExistPhoneNum
{
    if (USER.tel.length == 11) {
        return YES;
    }else{
        return NO;
    }
}

-(void)removeSwipeGestureRecognizer
{
    [_swipeGestureRecognizer removeTarget:self action:@selector(back:)];
}
/**
 *  添加button的shake动画
 */
-(void)addShakeAnimation:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    ani.springSpeed = 30.f;
    ani.velocity = @1200;
    ani.springBounciness = 20;
    [button.layer pop_addAnimation:ani forKey:nil];
    [ani setCompletionBlock:^(POPAnimation *animation, BOOL finish) {
        if (finish) {
            [button.layer pop_removeAllAnimations];
            button.userInteractionEnabled = YES;
        }
    }];
}

/**
 *  去登录
 */
-(void)gotoCodeVC
{
    LoginNew2ViewController *loginVC= [[LoginNew2ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
