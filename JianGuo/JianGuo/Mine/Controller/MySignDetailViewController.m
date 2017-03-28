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
#import "QLAlertView.h"
#import "LCChatKit.h"
#import "DemandStatusModel.h"


@interface MySignDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) DemandModel *demandModel;
@property (nonatomic,strong) SignUsers *user;

@end

@implementation MySignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [NSMutableArray array];
    
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
            [self createModelArr];
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
//先自己创建一个数组<为了后期从服务器请求时改动小点儿>
-(void)createModelArr
{
    if (self.demandModel.enroll_status.integerValue == 3) {
        NSArray *array = @[[NSString stringWithFormat:@"发布者拒绝了您"],@"报名成功"];
        for (int i=0; i<2; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
            
        }
        return;
    }
    
    NSInteger status = self.demandModel.d_status.integerValue;
    if (status == 1) {
        DemandStatusModel *model = [[DemandStatusModel alloc] init];
        model.content = [NSString stringWithFormat:@"报名成功"];
        [self.dataArr addObject:model];
    }else if (status == 2){
        NSArray *array = @[[NSString stringWithFormat:@"你被录用了,快去完成工作吧"],@"报名成功"];
        for (int i=0; i<status; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }else if (status == 3){
        NSArray *array = @[[NSString stringWithFormat:@"您已确认完工,等待雇主确认"],[NSString stringWithFormat:@"你被录用了,快去完成工作吧"],@"报名成功"];
        for (int i=0; i<status; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }else if (status == 4){
        NSArray *array = @[@"发布者确认完工,交易已完成",@"您已确认完工,等待雇主确认",[NSString stringWithFormat:@"你被录用了,快去完成工作吧"],@"报名成功"];
        for (int i=0; i<status; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }else if (status == 5){
        NSArray *array = @[@"发布者投诉了你,等待平台仲裁",@"您已确认完工,等待雇主确认",[NSString stringWithFormat:@"你被录用了,快去完成工作吧"],@"报名成功"];
        for (int i=0; i<status-1; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }else if (status == 6){
        NSArray *array = @[@"平台已仲裁",@"发布者投诉了你,等待平台仲裁",@"您已确认完工,等待雇主确认",[NSString stringWithFormat:@"你被录用了,快去完成工作吧"],@"报名成功"];
        for (int i=0; i<status-1; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }else if (status == 7){
        NSArray *array = @[@"发布者下架了此任务"];
        for (int i=0; i<1; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }else if (status == 8){
        NSArray *array = @[@"任务被平台下架了"];
        for (int i=0; i<1; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }
}



/**
 *  电话联系
 */
-(void)callSomeOne
{
    [QLAlertView showAlertTittle:@"确定呼叫发布者?" message:nil isOnlySureBtn:NO compeletBlock:^{
        
        [APPLICATION openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.demandModel.tel]]];
        
    }];
}
/**
 *  聊天
 */
-(void)chat
{
    
    if (self.demandModel.b_user_id.integerValue == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
        return ;
    }
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:self.demandModel.b_user_id]];
    
    [self.navigationController pushViewController:conversationViewController animated:YES];
    
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
    return section==0?1:self.dataArr.count;
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
            cell.topView.hidden = YES;
            cell.contentL.textColor = GreenColor;
            cell.timeL.textColor = GreenColor;
            cell.iconView.image = [UIImage imageNamed:@"lastStatus"];
        }
        else if (indexPath.row == self.dataArr.count-1){
            cell.bottomView.hidden = YES;
        }
        cell.model = self.dataArr[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0&&indexPath.section == 0) {
        DemandDetailController *detailVC = [[DemandDetailController alloc] init];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.demandId = self.demandId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
