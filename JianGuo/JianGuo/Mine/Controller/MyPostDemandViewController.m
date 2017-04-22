//
//  MyPostDemandViewController.m
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyPostDemandViewController.h"
#import "MyDemandCell.h"
#import "JGHTTPClient+Demand.h"
#import "DemandModel.h"
#import "SignDemandViewController.h"
#import "MyPostDetailViewController.h"

static NSString *const identifier = @"MyDemandCell";

@interface MyPostDemandViewController ()<UITableViewDataSource,UITableViewDelegate,MyDemandClickDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation MyPostDemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我发布的";
    
//    self.view.backgroundColor = BACKCOLORGRAY;
    
    self.tableView.rowHeight = 120;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestList:@"1"];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
        [self requestList:[NSString stringWithFormat:@"%ld",pageCount]];
        
    }];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}


-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getMyDemandsListWithPageNum:count pageSize:nil Success:^(id responseObject) {
        
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
    detailVC.status = model.d_status;
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

@end

