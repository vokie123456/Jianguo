//
//  HomeSegmentViewController.m
//  JianGuo
//
//  Created by apple on 17/7/24.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "HomeSegmentViewController.h"
#import "DemandListViewController.h"
#import "SkillViewController.h"


#import "ZJScrollPageView.h"

@interface HomeSegmentViewController () <ZJScrollPageViewDelegate>

/** 标题数组 */
@property (nonatomic,copy) NSArray *titles;

@end

@implementation HomeSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSegmentView];
    
}

-(void)setSegmentView
{
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    // 缩放标题
    style.scaleTitle = NO;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 设置附加按钮的背景图片
    style.titleFont = FONT(15);
    style.scrollTitle = NO;
    style.showLine = YES;
    style.selectedTitleColor = GreenColor;
    style.scrollLineColor = GreenColor;
    
    self.titles = @[@"技能",
                    @"任务"
                    ];
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    scrollPageView.backgroundColor = BACKCOLORGRAY;
    // 这里可以设置头部视图的属性(背景色, 圆角, 背景图片...)
    //    scrollPageView.segmentView.backgroundColor = [UIColor blackColor];
//    self.navigationItem.titleView  = scrollPageView;
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
        if (index == 0) {
            SkillViewController *demandListVC = [[SkillViewController alloc] init];
            childVc = demandListVC;
        }else if (index == 1){
            
            DemandListViewController *demandListVC = [[DemandListViewController alloc] init];
            childVc = demandListVC;
        }
        
        childVc.title = self.titles[index];
    }
    
    return childVc;
}



@end
