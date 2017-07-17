//
//  MyPostDemandViewController.m
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyPostDemandViewController.h"
#import "SignDemandViewController.h"
#import "MyPostDetailViewController.h"
#import "DemandStatusParentViewController.h"

#import "MyDemandCell.h"
#import "JGHTTPClient+Demand.h"
#import "DemandModel.h"
#import "ZJScrollPageView.h"

static NSString *const identifier = @"MyDemandCell";

@interface MyPostDemandViewController ()<UITableViewDataSource,UITableViewDelegate,MyDemandClickDelegate,ZJScrollPageViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

/** 标题数组 */
@property (nonatomic,copy) NSArray *titles;

@end

@implementation MyPostDemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我发布的";
    
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
//        pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
//        [self requestList:[NSString stringWithFormat:@"%ld",pageCount]];
//        
//    }];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}


-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getMyDemandsListWithPageNum:count type:nil pageSize:nil Success:^(id responseObject) {
        
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
    cell.model = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DemandModel *model = self.dataArr[indexPath.row];
    MyDemandCell *cell = (MyDemandCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    MyPostDetailViewController *detailVC = [[MyPostDetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.demandId = model.id;
    detailVC.statusStr = cell.stateL.text;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)getUsers:(NSString *)demandId
{
    SignDemandViewController *usersVC = [[SignDemandViewController alloc] init];
    usersVC.demandId = demandId;
    usersVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:usersVC animated:YES];
}

-(void)deleteDemand:(NSString *)demandId
{
    [JGHTTPClient updateDemandStatusWithDemandId:demandId status:@"9" Success:^(id responseObject) {
        
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(void)offStoreDemand:(NSString *)demandId
{
    [JGHTTPClient updateDemandStatusWithDemandId:demandId status:@"8" Success:^(id responseObject) {
        
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
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
        DemandStatusParentViewController *VC = [[DemandStatusParentViewController alloc] init];
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

