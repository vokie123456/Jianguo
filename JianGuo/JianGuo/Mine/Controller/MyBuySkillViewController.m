//
//  MyBuySkillViewController.m
//  JianGuo
//
//  Created by apple on 17/8/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyBuySkillViewController.h"
#import "MyBuySkillChildViewController.h"

#import "ZJScrollPageView.h"

@interface MyBuySkillViewController () <ZJScrollPageViewDelegate>

/** 标题数组 */
@property (nonatomic,strong) NSArray *titles;
@end

@implementation MyBuySkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"我购买的";
    
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    // 缩放标题
    style.scaleTitle = NO;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 设置附加按钮的背景图片
    style.titleFont = FONT(15);
    if (SCREEN_W>=375) {
        style.scrollTitle = NO;
    }
    style.showLine = YES;
    //    style.showCover = YES;
    style.normalTitleColor = LIGHTGRAYTEXT;
    style.selectedTitleColor = GreenColor;
    style.scrollLineColor = GreenColor;
    style.coverBackgroundColor = [GreenColor colorWithAlphaComponent:0.5];
    
    self.titles = @[
                    @"待付款",
                    @"待服务",
                    @"待确认",
                    @"待评价",
                    @"待售后",
                    @"已结束"
                    ];
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    scrollPageView.backgroundColor = BACKCOLORGRAY;
    [self.view addSubview:scrollPageView];
    
}

#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    //    NSLog(@"%ld---------", index);
    
    if (!childVc) {
        MyBuySkillChildViewController *VC = [[MyBuySkillChildViewController alloc] init];
        VC.type = [NSString stringWithFormat:@"%ld",index+1];
        childVc = VC;
        childVc.title = self.titles[index];
    }
    
    return childVc;
}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---将要出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---已经出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---将要消失",index);
    
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---已经消失",index);
    
}


@end
