//
//  MySkillsViewController.m
//  JianGuo
//
//  Created by apple on 17/8/2.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MySkillsViewController.h"
#import "MySkillsChildViewController.h"
#import "MyBuySkillChildViewController.h"
#import "AllSkillManageViewController.h"

#import "ZJScrollPageView.h"

@interface MySkillsViewController () <ZJScrollPageViewDelegate>

/** 标题数组 */
@property (nonatomic,strong) NSArray *titles;

/** segmentView */
@property (nonatomic,strong) ZJScrollSegmentView *segmentView;
/** contentView */
@property (nonatomic,strong) ZJContentView *contentView;

@end

@implementation MySkillsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.navigationItem.title = @"已结束的技能交易";
    
//    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn_r setTitle:@"技能设置" forState:UIControlStateNormal];
//    [btn_r setTitleColor:GreenColor forState:UIControlStateNormal];
//    btn_r.titleLabel.font = FONT(16);
//    [btn_r addTarget:self action:@selector(setMySkill:) forControlEvents:UIControlEventTouchUpInside];
//    btn_r.frame = CGRectMake(0, 0, 80, 30);
//    
//    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    
    if (!self.isFinishedVC) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"已结束" style:UIBarButtonItemStylePlain target:self action:@selector(setMySkill:)];
        item.tintColor = GreenColor;
        
        self.navigationItem.rightBarButtonItem = item;
//        self.navigationItem.title = @"技能交易";
    }
    
    [self setSegmentView];
}


-(void)setSegmentView
{
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    // 缩放标题
    //    style.scaleTitle = YES;
    //    style.titleBigScale = 2;
    // 颜色渐变
    style.normalTitleColor = LIGHTGRAYTEXT;
    style.gradualChangeTitleColor = YES;
    // 设置附加按钮的背景图片
    style.titleFont = [UIFont systemFontOfSize:17];
    style.scrollTitle = NO;
    style.showLine = YES;
    style.selectedTitleColor = GreenColor;
    style.scrollLineColor = GreenColor;
    
    self.titles = @[
                    @"我购买的",
                    @"我出售的"
                    ];
    
    IMP_BLOCK_SELF(MySkillsViewController);
    self.segmentView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W==320?150: 200, 40) segmentStyle:style delegate:self titles:self.titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
        
        [block_self.contentView setContentOffSet:CGPointMake(SCREEN_W*index, 0) animated:YES];
        
    }];
    
    self.navigationItem.titleView = self.segmentView;
    
    self.contentView = [[ZJContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) segmentView:self.segmentView parentViewController:self delegate:self];
    [self.view addSubview:self.contentView];

}

-(void)setMySkill:(UIButton *)sender
{
    MySkillsViewController *manageVC = [[MySkillsViewController alloc] init];
    manageVC.hidesBottomBarWhenPushed = YES;
    manageVC.isFinishedVC = YES;
    [self.navigationController pushViewController:manageVC animated:YES];
}


#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    //    NSLog(@"%ld---------", index);
    
    if (!childVc) {
        if (index == 1) {
            
            MySkillsChildViewController *VC = [[MySkillsChildViewController alloc] init];
            if (_isFinishedVC) {
                VC.type = @"6";
            }
            childVc = VC;
            childVc.title = self.titles[index];
        }else if (index == 0){
            
            MyBuySkillChildViewController *VC = [[MyBuySkillChildViewController alloc] init];
            if (_isFinishedVC) {
                VC.type = @"6";
            }
            childVc = VC;
            childVc.title = self.titles[index];
            
        }
        
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
