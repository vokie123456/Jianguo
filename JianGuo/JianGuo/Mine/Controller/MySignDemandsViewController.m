//
//  MySignDemandsViewController.m
//  JianGuo
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MySignDemandsViewController.h"
#import "MySignDetailViewController.h"
#import "JGHTTPClient+Demand.h"
#import "DemandModel.h"
#import "MyDemandCell.h"

@interface MySignDemandsViewController ()<UITableViewDataSource,UITableViewDelegate,MyDemandClickDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation MySignDemandsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我报名的";
    
    //    self.view.backgroundColor = BACKCOLORGRAY;
    
    self.tableView.rowHeight = 120;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestList:@"1"];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0?1:0);
        [self requestList:[NSString stringWithFormat:@"%ld",pageCount]];
        
    }];
    
    [self requestList:@"1"];
    
}

-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getMySignedDemandsListWithPageNum:count pageSize:nil Success:^(id responseObject) {
        
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

@end
