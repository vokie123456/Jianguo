//
//  CollectionsViewController.m
//  JianGuo
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "CollectionsViewController.h"
#import "MakeEvaluateViewController.h"

#import "JGHTTPClient+Skill.h"

#import "SkillsCell.h"

#import "SkillListModel.h"

@interface CollectionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation CollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的收藏";
    
    self.tableView.rowHeight = 335.f;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestList:@"1"];
        
    }];
    
    
    self.tableView.mj_footer = ({
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter  footerWithRefreshingBlock:^{//上拉加载
            pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
            [self requestList:[NSString stringWithFormat:@"%ld",(long)pageCount]];
        }];
        //        footer.automaticallyHidden = YES;
        footer;
        
    });
    
    [self.tableView.mj_header beginRefreshing];
}


-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    [JGHTTPClient getCollectedSkillsListPageCount:count Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (count.intValue>1) {//上拉加载
            
            if ([[SkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (SkillListModel *model in [SkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            [_tableView reloadData];
            //            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            return;
            
        }else{
            
            [self.dataArr removeAllObjects];
            self.dataArr = [SkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkillsCell *cell = [SkillsCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MakeEvaluateViewController *evaluateVC = [[MakeEvaluateViewController alloc] init];
    evaluateVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:evaluateVC animated:YES];
    
}



@end
