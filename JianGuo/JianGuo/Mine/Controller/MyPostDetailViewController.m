//
//  MyPostDetailViewController.m
//  JianGuo
//
//  Created by apple on 17/2/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyPostDetailViewController.h"
#import "DemandDetailController.h"
#import "MineChatViewController.h"
#import "SignDemandViewController.h"
#import "DemandDetailCell.h"
#import "MySignDemandCell.h"
#import "JGHTTPClient+Demand.h"
#import "DemandModel.h"
#import "SignUsers.h"
#import "DemandProgressCell.h"
#import <BeeCloud.h>
#import "JGHTTPClient+Money.h"
#import "MineHeaderCell.h"
#import "DemandStatusCell.h"
#import <UIButton+AFNetworking.h>
#import "QLAlertView.h"


@interface MyPostDetailViewController ()<UITableViewDataSource,UITableViewDelegate,BeeCloudDelegate,ClickPersonDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) DemandModel *demandModel;
@property (nonatomic,strong) SignUsers *user;
@property (nonatomic,copy) NSString *payType;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@end

@implementation MyPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"任务详情";
    
    if (self.status.integerValue>1) {
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
        
    }
    
    self.tableView.estimatedRowHeight = 80;
    [self requestDemandDetail];
    
    if ([self.statusStr isEqualToString:@"报名中"]) {
        [self.bottomBtn setTitle:@"下架此任务" forState:UIControlStateNormal];
    }else if ([self.statusStr isEqualToString:@"待确认完工"]){
        [self.bottomBtn setTitle:@"确认完工" forState:UIControlStateNormal];
    }else if ([self.statusStr isEqualToString:@"平台仲裁中"]||[self.statusStr isEqualToString:@"已仲裁"]){
        [self.bottomBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    }else{
        self.bottomBtn.hidden = YES;
    }
    
}

/**
 *  电话联系
 */
-(void)callSomeOne
{
    [QLAlertView showAlertTittle:@"确认呼叫服务人员?" message:nil isOnlySureBtn:NO compeletBlock:^{
        [APPLICATION openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.user.tel]]];
    }];
}
/**
 *  聊天
 */
-(void)chat
{
    
}
/**
 *  去个人页面
 *
 */
-(void)clickPerson:(NSString *)userId
{
    MineChatViewController *mineChatVC = [[MineChatViewController alloc] init];
    mineChatVC.userId = self.user.user_id;
    [self.navigationController pushViewController:mineChatVC animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置BeeCloud代理
    [BeeCloud setBeeCloudDelegate:self];
}

-(void)requestDemandDetail
{
    
    [JGHTTPClient getProgressDetailsWithDemandId:self.demandId userId:USER.login_id type:@"0" Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            
            self.demandModel = [DemandModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.user = [SignUsers mj_objectWithKeyValues:[responseObject[@"data"] objectForKey:@"userInfoEntity"]];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0||indexPath.section == 2) {
        return 44;
    }else if (indexPath.section == 1){
        return 70;
    }else if (indexPath.section == 3){
        if (self.status.integerValue>1) {
            if (indexPath.row == 0) {
                return 44;
            }else{
                return 70;
            }
        }else{
            return UITableViewAutomaticDimension;
        }
    }else {
        return UITableViewAutomaticDimension;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.status.integerValue>1? 5:4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section){
        case 0:
        case 1:
        case 2:
            
            return 1;
            

        case 3:
            
            if (self.status.integerValue>1) {
                return 2;
            }else{
                return 4;//进度显示
            }
            

        case 4:
            
            return 4;//进度显示
            
        default:
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = [NSString stringWithFormat:@"订单号: %@",self.demandModel.id];
        cell.textLabel.font = FONT(14);
        cell.detailTextLabel.font = FONT(16);
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.text = self.statusStr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 1){
        
        MySignDemandCell *cell = [MySignDemandCell cellWithTableView:tableView];
        cell.model = self.demandModel;
        return cell;
        
    }else if (indexPath.section == 2){
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = [NSString stringWithFormat:@"查看报名情况"];
        cell.textLabel.font = FONT(15);
        if (self.demandModel) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 人",self.demandModel.enroll_count];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }else if (indexPath.section == 3){
        
        if(self.status.integerValue>1){
            if (indexPath.row == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                
                cell.textLabel.text = [NSString stringWithFormat:@"服务者信息"];
                cell.textLabel.textColor = RGBCOLOR(102, 102, 102);
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.height-1, SCREEN_W-15, 1)];
                line.backgroundColor = BACKCOLORGRAY;
                [cell.contentView addSubview:line];
                
                return cell;
            }else{
                MineHeaderCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MineHeaderCell class]) owner:nil options:nil] lastObject];
                cell.iconBtn.layer.cornerRadius = 20;
                if (self.user) {
                    cell.model = self.user;
                    cell.delegate = self;
                }
                return cell;
            }
        }else{//没有录取用户的时候
            DemandStatusCell *cell = [DemandStatusCell cellWithTableView:tableView];
            if (indexPath.row == 0) {
                cell.topView.hidden = YES;
                cell.contentL.textColor = GreenColor;
                cell.timeL.textColor = GreenColor;
                cell.iconView.image = [UIImage imageNamed:@"lastStatus"];
            }
            return cell;
        }
        
    }else if (indexPath.section == 4){
        DemandStatusCell *cell = [DemandStatusCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.topView.hidden = YES;
            cell.contentL.textColor = GreenColor;
            cell.timeL.textColor = GreenColor;
            cell.iconView.image = [UIImage imageNamed:@"lastStatus"];
        }
        return cell;
    }else
        return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        DemandDetailController *detailVC = [[DemandDetailController alloc] init];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.isSelf = YES;
        detailVC.demandId = self.demandId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (indexPath.section == 2){//查看报名情况
        SignDemandViewController *usersVC = [[SignDemandViewController alloc] init];
        usersVC.demandId = self.demandId;
        usersVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:usersVC animated:YES];
    }else if (indexPath.row == 1&&indexPath.section == 3){
        
        MineChatViewController *mineChatVC = [[MineChatViewController alloc] init];
        mineChatVC.userId = self.user.user_id;
        [self.navigationController pushViewController:mineChatVC animated:YES];
    }
}

- (IBAction)pay:(UIButton *)sender {
    
    if ([sender.currentTitle containsString:@"完工"]) {//确认完工
        
        [QLAlertView showAlertTittle:@"确认完成后，平台将会把款项支付给服务者" message:nil isOnlySureBtn:NO compeletBlock:^{//发布者确认完成
            [JGHTTPClient updateDemandStatusWithDemandId:self.demandId status:@"4" Success:^(id responseObject) {
                [self showAlertViewWithText:responseObject[@"message"] duration:1];
            } failure:^(NSError *error) {
                
            }];
        }];
        
    }else if ([sender.currentTitle containsString:@"下架"]){
        
        [QLAlertView showAlertTittle:@"下架后，所有的报名者将自动拒绝，确定要下架吗?" message:nil isOnlySureBtn:NO compeletBlock:^{//发布者下架需求
            [JGHTTPClient updateDemandStatusWithDemandId:self.demandId status:@"7" Success:^(id responseObject) {
                [self showAlertViewWithText:responseObject[@"message"] duration:1];
            } failure:^(NSError *error) {
                
            }];
        }];
        
    }else if ([sender.currentTitle containsString:@"仲裁"]){
        [QLAlertView showAlertTittle:@"确认呼叫服务人员?" message:nil isOnlySureBtn:NO compeletBlock:^{
            [APPLICATION openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:@"010-53350021"]]];
        }];
    }
    
}



@end
