//
//  MySignDemandsViewController.m
//  JianGuo
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MySignDemandsViewController.h"
#import "JGHTTPClient+Demand.h"
#import "DemandModel.h"
#import "MySignDemandCell.h"

@interface MySignDemandsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation MySignDemandsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我报名的";
    
    //    self.view.backgroundColor = BACKCOLORGRAY;
    
    self.tableView.rowHeight = 78;
    
    [self requestWithCount:0];
    
}

-(void)requestWithCount:(NSInteger)pageCount
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getMySignedDemandsListWithPageNum:[NSString stringWithFormat:@"%ld",pageCount] pageSize:nil Success:^(id responseObject) {
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
    MySignDemandCell *cell = [MySignDemandCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

@end
