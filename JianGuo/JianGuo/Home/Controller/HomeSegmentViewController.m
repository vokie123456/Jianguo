//
//  HomeSegmentViewController.m
//  JianGuo
//
//  Created by apple on 17/7/24.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "HomeSegmentViewController.h"
#import "SearchDemandsViewController.h"
#import "DemandListViewController.h"
#import "SkillViewController.h"


#import "ZJScrollPageView.h"

@interface HomeSegmentViewController () <ZJScrollPageViewDelegate>

/** 标题数组 */
@property (nonatomic,copy) NSArray *titles;

/** segmentView */
@property (nonatomic,strong) ZJScrollSegmentView *segmentView;
/** contentView */
@property (nonatomic,strong) ZJContentView *contentView;

@end

@implementation HomeSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSegmentView];
    
    [self setNavigationBar];
    
}

-(void)setNavigationBar
{
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLocation setTitle:[CityModel city].cityName forState:UIControlStateNormal];
    [btnLocation setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    btnLocation.titleLabel.font = FONT(14);
    [btnLocation addTarget:self action:@selector(selectCitySChool:) forControlEvents:UIControlEventTouchUpInside];
    btnLocation.frame = CGRectMake(0, 0, 20, 20);
    
    //    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_l];
    UIBarButtonItem *bbtLocation = [[UIBarButtonItem alloc] initWithCustomView:btnLocation];
    self.navigationItem.rightBarButtonItems = @[bbtLocation];
}


-(void)selectCitySChool:(UIButton *)btn
{
    SearchDemandsViewController *searchVC = [[SearchDemandsViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
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
    
    self.titles = @[@"技能",
                    @"任务"
                    ];
    
    IMP_BLOCK_SELF(HomeSegmentViewController);
    self.segmentView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 0, 100, 40) segmentStyle:style delegate:self titles:self.titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
        
        [block_self.contentView setContentOffSet:CGPointMake(SCREEN_W*index, 0) animated:YES];
        
    }];
    
    self.navigationItem.titleView = self.segmentView;
    
    self.contentView = [[ZJContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-49) segmentView:self.segmentView parentViewController:self delegate:self];
    [self.view addSubview:self.contentView];
    
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
