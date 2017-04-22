//
//  NavigatinViewController.h
//  JianGuo
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "BaseViewController.h"

@interface NavigatinViewController : BaseViewController

{
    UIView *bgView;
    NSInteger pageCount;
}

// 抽屉交互封装的属性
@property (nonatomic,strong) UIView *drawerView;

@property (nonatomic,assign) BOOL isDrawered;

// 抽屉的容器View
@property (nonatomic,strong) UIView *drawer_Content;

// 滑动抽屉时用于禁用scrollView的滚动
@property (nonatomic,strong) UIScrollView *drawer_ScrollContent;
@property (nonatomic,assign) CGPoint drawer_touchBeganPoint;
@property (nonatomic,strong) UIActivityIndicatorView *drawer_activityView;

@property (nonatomic, assign) BOOL adjustStatusBar;
/**
 *  返回上一级页面
 */
-(void)popToPreviousVC;

@end
