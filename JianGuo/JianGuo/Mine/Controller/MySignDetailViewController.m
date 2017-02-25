//
//  MySignDetailViewController.m
//  JianGuo
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 ningcol. All rights reserved.
//


#import "MySignDetailViewController.h"
#import "DemandDetailController.h"
#import "MySignDemandCell.h"
#import "DemandStatusCell.h"
#import "JGHTTPClient+Demand.h"
#import "DemandModel.h"
#import "SignUsers.h"


@interface MySignDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) DemandModel *demandModel;
@property (nonatomic,strong) SignUsers *user;

@end

@implementation MySignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"报名详情页";
    self.tableView.estimatedRowHeight = 70;

    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setBackgroundImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(callSomeOne) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 20, 20);
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    
    
    UIButton * btn_r2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r2 setBackgroundImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    [btn_r2 addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
    btn_r2.frame = CGRectMake(0, 0, 20, 20);
    
    
    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btn_r2];
    
    self.navigationItem.rightBarButtonItems = @[rightBtn2,rightBtn];
    
    [self requestDemandDetail];
    
}
-(void)requestDemandDetail
{
    
    [JGHTTPClient getProgressDetailsWithDemandId:self.demandId userId:USER.login_id type:@"1" Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            
            self.demandModel = [DemandModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.tableView reloadData];
            //            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            //            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            //            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else{
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
        }
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

/**
 *  电话联系
 */
-(void)callSomeOne
{
    
}
/**
 *  聊天
 */
-(void)chat
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }else
        return UITableViewAutomaticDimension;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?1:1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MySignDemandCell *cell = [MySignDemandCell cellWithTableView:tableView];
        cell.model = self.demandModel;
        return cell;
    }else{
        DemandStatusCell *cell = [DemandStatusCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.stateL.hidden = NO;
            cell.stateL.text = self.statusStr;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        DemandDetailController *detailVC = [[DemandDetailController alloc] init];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.demandId = self.demandId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
