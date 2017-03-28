//
//  SignDemandViewController.m
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SignDemandViewController.h"
#import "LCCKConversationViewController.h"
#import "JGHTTPClient+Demand.h"
#import "SignersCell.h"
#import "SignUsers.h"

@interface SignDemandViewController ()<UITableViewDataSource,UITableViewDelegate,AgreeUserSomeOneDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation SignDemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"报名列表";
    
    self.tableView.rowHeight = 118;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestWithCount:@"1"];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0?1:0);
        
        [self requestWithCount:[NSString stringWithFormat:@"%ld",pageCount]];
        
    }];
    
    [self requestWithCount:@"1"];
    
}


-(void)requestWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient signerListWithDemandId:self.demandId pageNum:count pageSize:nil Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (count.intValue>1) {//上拉加载
            
            if ([[SignUsers mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *sections = [NSMutableArray array];
            for (SignUsers *model in [SignUsers mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexSet* section = [NSIndexSet indexSetWithIndex:self.dataArr.count-1];
                [sections addObject:section];
            }
            
            //            [_tableView insertRowsAtIndexPaths:sections withRowAnimation:UITableViewRowAnimationFade];
            [_tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataArr.count-sections.count, sections.count)] withRowAnimation:UITableViewRowAnimationFade];
            return;
            
        }else{
            
            [self.dataArr removeAllObjects];
            self.dataArr = [SignUsers mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
        }
        
        [self.tableView reloadData];
        if ([SignUsers mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] == 0) {
            [self showAlertViewWithText:@"没有更多数据" duration:1];
            return ;
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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
    SignersCell *cell = [SignersCell cellWithTableView:tableView];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
//    if (self.dataArr.count>indexPath.row) {
        cell.model = self.dataArr[indexPath.section];
        cell.demandId = self.demandId;
//    }
    cell.delegate = self;
    
    return cell;
}

-(void)userSomeOne:(NSString *)userId status:(NSString *)status cell:(SignersCell *)cell
{
    JGSVPROGRESSLOAD(@"请求中...")
    [JGHTTPClient signDemandWithDemandId:self.demandId userId:userId status:status reason:nil Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"] integerValue] == 200) {
            [self refreshData];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)refreshData
{
    [self requestWithCount:@"1"];
}

-(void)chatUser:(NSString *)userId
{
    if (userId.integerValue == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
        return ;
    }
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:userId]];
    
    [self.navigationController pushViewController:conversationViewController animated:YES];
    

}


@end
