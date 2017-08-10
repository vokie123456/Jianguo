//
//  BillsViewController.m
//  JianGuo
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "BillsViewController.h"
#import "JGHTTPClient+Mine.h"
#import "BillCell.h"
#import "MoneyRecordModel.h"
#import "GetCashProgressViewController.h"

@interface BillsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation BillsViewController


- (void)viewDidLoad {
    [super viewDidLoad];

//    self.navigationItem.title = @"账单";
    self.tableView.rowHeight = 65;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestList:@"1"];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
//        for (int i=0; i<4; i++) {
//            MoneyRecordModel *model = [[MoneyRecordModel alloc] init];
//            [self.dataArr addObject:model];
//        }
//        
        pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
        
        JGLog(@"one ====  %d",(int)self.dataArr.count/10);
        JGLog(@"two ==== %d",((int)(self.dataArr.count/10)>=1?1:2));
        JGLog(@"three ==== %d",((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0));
        
        [self requestList:[NSString stringWithFormat:@"%ld",pageCount]];
        
    }];
    [self requestList:@"1"];
    
}

-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
//    if (walletType == WalletIncome) {
//        type = @"1";
//    }else if (walletType == WalletPay){
//        type = @"2";
//    }
    
    [JGHTTPClient lookUserMoneyLogByloginId:USER.login_id type:self.type count:count Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (count.intValue>1) {//上拉加载
            
            if ([[MoneyRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (MoneyRecordModel *model in [MoneyRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            return;
            
        }else{
            
            [self.dataArr removeAllObjects];
            self.dataArr = [MoneyRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
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
    BillCell *cell = [BillCell cellWithTableView:tableView];
    
    MoneyRecordModel *model = self.dataArr[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoneyRecordModel *model = self.dataArr[indexPath.row];
    if (model.type.integerValue == 2) {
        GetCashProgressViewController *getCashVC = [[GetCashProgressViewController alloc] init];
        getCashVC.hidesBottomBarWhenPushed = YES;
        getCashVC.model = model;
        [self.navigationController pushViewController:getCashVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)popToPreviousVC
{
    if (self.isFromGetCash) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [super popToPreviousVC];
    }
}

@end
