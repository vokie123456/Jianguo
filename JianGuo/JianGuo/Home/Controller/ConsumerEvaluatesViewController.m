//
//  ConsumerEvaluatesViewController.m
//  JianGuo
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "ConsumerEvaluatesViewController.h"

#import "JGHTTPClient+Skill.h"

#import "ConsumerEvaluationsModel.h"

#import "ConsumerCell.h"

@interface ConsumerEvaluatesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UILabel *evaluateCountL;

@end

@implementation ConsumerEvaluatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"客户评价";
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestWithCount:@"1"];
    }];
    
    self.tableView.mj_footer = ({
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            pageCount = ((int)(self.dataArr.count-1)/10) + ((int)((self.dataArr.count-1)/10)>=1?1:2) + (((self.dataArr.count-1)%10)>0&&(self.dataArr.count-1)>10?1:0);
            
            [self requestWithCount:[NSString stringWithFormat:@"%ld",pageCount]];
            
        }];
        footer;
    });
    [self.tableView.mj_header beginRefreshing];
}

-(void)requestWithCount:(NSString *)count
{
    
    [JGHTTPClient getSkillEvaluationsWithSkillId:self.skillId userId:nil pageCount:count Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        JGLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200) {
            _evaluateCountL.text = [NSString stringWithFormat:@"共有%@条用户评价",responseObject[@"data"][@"total"]];
        }
        if (count.integerValue>1) {//上拉加载
            
            if ([[ConsumerEvaluationsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"results"] ] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            
            for (ConsumerEvaluationsModel *model in [ConsumerEvaluationsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"results"]]) {
                [self.dataArr addObject:model];
            }
            [_tableView reloadData];
            
            return;
            
        }else{
            self.dataArr = [ConsumerEvaluationsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"results"]];
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showAlertViewWithText:NETERROETEXT duration:1];
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsumerCell *cell = [ConsumerCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
