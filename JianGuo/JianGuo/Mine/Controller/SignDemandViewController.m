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
    
    self.navigationItem.title = @"申请人";
    
    self.tableView.rowHeight = 75;
    
    [self requestWithCount:0];
    
}


-(void)requestWithCount:(NSInteger)pageCount
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient signerListWithDemandId:self.demandId pageNum:[NSString stringWithFormat:@"%ld",pageCount] pageSize:nil Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        self.dataArr = [SignUsers mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignersCell *cell = [SignersCell cellWithTableView:tableView];
    
    if (self.dataArr.count>indexPath.row) {
        cell.model = self.dataArr[indexPath.row];
    }
    cell.delegate = self;
    
    return cell;
}

-(void)userSomeOne:(NSString *)userId
{
    JGSVPROGRESSLOAD(@"请求中...")
    [JGHTTPClient signDemandWithDemandId:self.demandId userId:userId status:@"2" Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end
