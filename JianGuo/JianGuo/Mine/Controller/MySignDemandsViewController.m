//
//  MySignDemandsViewController.m
//  JianGuo
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MySignDemandsViewController.h"
#import "MySignDetailViewController.h"
#import "DemandSignStatusViewController.h"

#import "JGHTTPClient+Demand.h"
#import "DemandModel.h"
#import "MyDemandCell.h"

#import "ZJScrollPageView.h"

@interface MySignDemandsViewController ()<UITableViewDataSource,UITableViewDelegate,ZJScrollPageViewDelegate,MyDemandClickDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
/** 标题数组 */
@property (nonatomic,strong) NSArray *titles;

@end

@implementation MySignDemandsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我报名的";
    

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
    
    self.titles = @[@"待录取",
                    @"待完成",
                    @"待确认",
                    @"待评价",
                    @"已结束"
                    ];
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    scrollPageView.backgroundColor = BACKCOLORGRAY;
    // 这里可以设置头部视图的属性(背景色, 圆角, 背景图片...)
    //    scrollPageView.segmentView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollPageView];
    
//    self.tableView.rowHeight = 120;
//    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        pageCount = 0;
//        [self requestList:@"1"];
//        
//    }];
//    
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//       pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
//        [self requestList:[NSString stringWithFormat:@"%ld",pageCount]];
//        
//    }];
//    
//    [self requestList:@"1"];
    
}

-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getMySignedDemandsListWithPageNum:count type:nil pageSize:nil Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (count.intValue>1) {//上拉加载
            
            if ([[DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (DemandModel *model in [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            return;
            
        }else{
            
            [self.dataArr removeAllObjects];
            self.dataArr = [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyDemandCell *cell = [MyDemandCell cellWithTableView:tableView];
    cell.isSelfSign = YES;
    cell.delegate = self;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySignDetailViewController *detailVC = [[MySignDetailViewController alloc] init];
    DemandModel *model  = self.dataArr[indexPath.row];
    MyDemandCell *cell = (MyDemandCell *)[tableView cellForRowAtIndexPath:indexPath];
    detailVC.statusStr = cell.stateL.text;
    detailVC.demandId = model.id;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)refreshData
{
    [self requestList:@"1"];
}

#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    //    NSLog(@"%ld---------", index);
    
    if (!childVc) {
        DemandSignStatusViewController *VC = [[DemandSignStatusViewController alloc] init];
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
