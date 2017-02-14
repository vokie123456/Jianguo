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
    
    [self requestWithCount:0];
    
}


-(void)requestWithCount:(NSInteger)pageCount
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getMyDemandsListWithPageNum:[NSString stringWithFormat:@"%ld",pageCount] pageSize:nil Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        self.dataArr = [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
    MyDemandCell *cell = [MyDemandCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
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

@end

