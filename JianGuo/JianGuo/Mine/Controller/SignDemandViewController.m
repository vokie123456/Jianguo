//
//  SignDemandViewController.m
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SignDemandViewController.h"
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
        
        pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>1?1:2);
        
        [self requestWithCount:[NSString stringWithFormat:@"%ld",pageCount]];
        
    }];
    
    [self requestWithCount:@"1"];
    
}


-(void)requestWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient signerListWithDemandId:self.demandId pageNum:[NSString stringWithFormat:@"%@",count] pageSize:nil Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        self.dataArr = [SignUsers mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
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
            SignUsers *model = cell.model;
            model.enroll_status = @"2";
            cell.model = model;
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end
