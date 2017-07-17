//
//  NavigatinViewController.m
//  JianGuo
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface NavigatinViewController ()<UIGestureRecognizerDelegate>

@end

@implementation NavigatinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationItem setHidesBackButton:YES];
    [self customBackBtn];
    
    [self showANopartJobView];
}

-(void)showANopartJobView
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H/2-125, SCREEN_W, 250)];
    bgView.userInteractionEnabled = NO;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.center.x-60, 0, 120, 120*79/100)];
    imgView.image = [UIImage imageNamed:@"defaultpicture"];
    [bgView addSubview:imgView];
    
    UILabel *labelMiddle = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom+5, SCREEN_W, 25)];
    labelMiddle.text = @"没有数据哦!";
    labelMiddle.font = FONT(16);
    labelMiddle.textColor = LIGHTGRAYTEXT;
    labelMiddle.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:labelMiddle];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"去找工作" forState:UIControlStateNormal];
//    [btn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
//    btn.frame = CGRectMake(bgView.center.x-50, labelMiddle.bottom, 100, 30);
//    [btn addTarget:self action:@selector(gotoPartJobVC:) forControlEvents:UIControlEventTouchUpInside];
//    btn.titleLabel.font = FONT(16);
//    [bgView addSubview:btn];
    
    [self.view addSubview:bgView];
    [self.view bringSubviewToFront:bgView];
    
    bgView.hidden = YES;
}

/**
 *  自定义返回按钮
 */
-(void)customBackBtn
{
    
    if (self == self.navigationController.viewControllers.firstObject) {
        return;
    }
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.showsTouchWhenHighlighted = YES;
    backBtn.frame = CGRectMake(0, 0, 12, 21);
    [backBtn addTarget:self action:@selector(popToPreviousVC) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
}

/**
 *  返回上一级页面
 */
-(void)popToPreviousVC
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = BACKCOLORGRAY;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    CGFloat top = 5;
    CGFloat bottom = 5 ;
    CGFloat left = 0;
    CGFloat right = 0;
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"icon-navigationBar"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    
}


@end
