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
#import "JGHTTPClient+Money.h"
#import "MineHeaderCell.h"
#import "DemandStatusCell.h"
#import <UIButton+AFNetworking.h>
#import "QLAlertView.h"
#import "LCChatKit.h"
#import "DemandStatusModel.h"


@interface MyPostDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ClickPersonDelegate>
{
    
    __weak IBOutlet NSLayoutConstraint *bottomCons;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) DemandModel *demandModel;
@property (nonatomic,strong) SignUsers *user;
@property (nonatomic,copy) NSString *payType;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (nonatomic,strong) UIButton  *telBtn;
@property (nonatomic,strong) UIButton *chatBtn;

@end

@implementation MyPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [NSMutableArray array];
    
    self.navigationItem.title = @"任务详情";
    
    if (self.status.integerValue>1) {
        UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_r setBackgroundImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
        [btn_r addTarget:self action:@selector(callSomeOne) forControlEvents:UIControlEventTouchUpInside];
        btn_r.frame = CGRectMake(0, 0, 20, 20);
        
        self.telBtn = btn_r;
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
 
        
        UIButton * btn_r2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_r2 setBackgroundImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
        [btn_r2 addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
        btn_r2.frame = CGRectMake(0, 0, 20, 20);
        self.chatBtn = btn_r2;
        
        UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btn_r2];
        
        self.navigationItem.rightBarButtonItems = @[rightBtn2,rightBtn];
        
    }
    
    self.tableView.estimatedRowHeight = 80;
    [self requestDemandDetail];
    
    if ([self.statusStr isEqualToString:@"报名中"]) {
        [self.bottomBtn setTitle:@"下架此任务" forState:UIControlStateNormal];
    }else if ([self.statusStr isEqualToString:@"待确认完工"]){
        [self.bottomBtn setTitle:@"确认完工" forState:UIControlStateNormal];
    }else{
        bottomCons.constant = -40;
        self.bottomBtn.hidden = YES;
    }
    
}

/**
 *  电话联系
 */
-(void)callSomeOne
{
    if (self.user.b_user_id.integerValue ==0) {
        [self showAlertViewWithText:@"还没有人报名呢" duration:1];
        return;
    }
    [QLAlertView showAlertTittle:@"确认呼叫服务人员?" message:nil isOnlySureBtn:NO compeletBlock:^{
        [APPLICATION openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.user.tel]]];
    }];
}
/**
 *  聊天
 */
-(void)chat
{
    if (self.user.b_user_id.integerValue ==0) {
    [self showAlertViewWithText:@"还没有人报名呢" duration:1];
    return;
    }
    if (self.user.b_user_id.integerValue == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
        return ;
    }
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:self.user.b_user_id]];
    
    [self.navigationController pushViewController:conversationViewController animated:YES];
    
}
/**
 *  去个人页面
 *
 */
-(void)clickPerson:(NSString *)userId
{
    MineChatViewController *mineChatVC = [[MineChatViewController alloc] init];
    mineChatVC.userId = self.user.b_user_id;
    [self.navigationController pushViewController:mineChatVC animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

//先自己创建一个数组<为了后期从服务器请求时改动小点儿>
-(void)createModelArr
{
    NSInteger status = self.demandModel.d_status.integerValue;
    if (status == 1) {
        DemandStatusModel *model = [[DemandStatusModel alloc] init];
        model.content = [NSString stringWithFormat:@"发布成功"];
        [self.dataArr addObject:model];
    }else if (status == 2){
        NSArray *array = @[[NSString stringWithFormat:@"你录用了 %@ ",self.user.nickname],@"发布成功"];
        for (int i=0; i<status; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }else if (status == 3){
        NSArray *array = @[[NSString stringWithFormat:@"%@ 完成工作,等待您确认完工",self.user.nickname],[NSString stringWithFormat:@"你录用了 %@ ",self.user.nickname],@"发布成功"];
        for (int i=0; i<status; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }else if (status == 4){
        NSArray *array = @[@"您已完成支付,交易已完成",[NSString stringWithFormat:@"%@ 完成工作,等待您确认完工",self.user.nickname],[NSString stringWithFormat:@"你录用了 %@ ",self.user.nickname],@"发布成功"];
        for (int i=0; i<status; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }else if (status == 5){
        NSArray *array = @[[NSString stringWithFormat:@"您投诉了 %@ ,等待平台仲裁",self.user.nickname],[NSString stringWithFormat:@"%@ 完成工作,等待您确认完工",self.user.nickname],[NSString stringWithFormat:@"你录用了 %@ ",self.user.nickname],@"发布成功"];
        for (int i=0; i<status-1; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }else if (status == 6){
        NSArray *array = @[[NSString stringWithFormat:@"平台已仲裁"],[NSString stringWithFormat:@"您投诉了 %@ ,等待平台仲裁",self.user.nickname],[NSString stringWithFormat:@"%@ 完成工作,等待您确认完工",self.user.nickname],[NSString stringWithFormat:@"你录用了 %@ ",self.user.nickname],@"发布成功"];
        for (int i=0; i<status-1; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }else if (status == 7){
        NSArray *array = @[@"该需求已下架",@"发布成功"];
        for (int i=0; i<2; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }else if (status == 8){
        NSArray *array = @[@"该需求被平台下架",@"发布成功"];
        for (int i=0; i<2; i++) {
            
            DemandStatusModel *model = [[DemandStatusModel alloc] init];
            model.content = array[i];
            [self.dataArr addObject:model];
        }
    }
}

-(void)requestDemandDetail
{
    
    [JGHTTPClient getProgressDetailsWithDemandId:self.demandId userId:USER.login_id type:@"0" Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            
            self.demandModel = [DemandModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.user = [SignUsers mj_objectWithKeyValues:[responseObject[@"data"] objectForKey:@"userInfoEntity"]];
            if (self.user.b_user_id.integerValue == 0) {
                self.telBtn.hidden  = YES;
                self.chatBtn.hidden = YES;
            }
            
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
        if (self.status.integerValue>1&&self.user.b_user_id) {
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
    return self.status.integerValue>1? (self.user.b_user_id?5:4):4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section){
        case 0:
        case 1:
        case 2:
            
            return 1;
            

        case 3:
            
            if (self.status.integerValue>1&&self.user.b_user_id) {
                return 2;
            }else{
                return self.dataArr.count;//进度显示
            }
            

        case 4:
            
            return self.dataArr.count;//进度显示
            
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
        
        if(self.status.integerValue>1&&self.user.b_user_id){
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
            }else if (indexPath.row == self.dataArr.count-1){
                cell.bottomView.hidden = YES;
            }
            cell.model = self.dataArr[indexPath.row];
            return cell;
        }
        
    }else if (indexPath.section == 4){
        DemandStatusCell *cell = [DemandStatusCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.topView.hidden = YES;
            cell.contentL.textColor = GreenColor;
            cell.timeL.textColor = GreenColor;
            cell.iconView.image = [UIImage imageNamed:@"lastStatus"];
        }else if (indexPath.row == self.dataArr.count-1){
            cell.bottomView.hidden = YES;
        }
        cell.model = self.dataArr[indexPath.row];
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
        mineChatVC.userId = self.user.b_user_id;
        [self.navigationController pushViewController:mineChatVC animated:YES];
    }
}

- (IBAction)pay:(UIButton *)sender {
    
    if ([sender.currentTitle containsString:@"完工"]) {//确认完工
        
        [QLAlertView showAlertTittle:@"确认完成后，平台将会把款项支付给服务者" message:nil isOnlySureBtn:NO compeletBlock:^{//发布者确认完成
            JGSVPROGRESSLOAD(@"正在请求");
            [JGHTTPClient updateDemandStatusWithDemandId:self.demandId status:@"4" Success:^(id responseObject) {
                [SVProgressHUD dismiss];
                [self showAlertViewWithText:responseObject[@"message"] duration:1];
                if ([responseObject[@"code"] integerValue] == 200) {
                    [sender setTitle:@"已经完成" forState:UIControlStateNormal];
                    [sender setBackgroundColor:LIGHTGRAY1];
                    sender.userInteractionEnabled = NO;
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
                [self showAlertViewWithText:NETERROETEXT duration:1];
            }];
        }];
        
    }else if ([sender.currentTitle containsString:@"下架"]){
        
        [QLAlertView showAlertTittle:@"下架后，所有的报名者将自动拒绝，确定要下架吗?" message:nil isOnlySureBtn:NO compeletBlock:^{//发布者下架需求
            JGSVPROGRESSLOAD(@"正在请求");
            [JGHTTPClient updateDemandStatusWithDemandId:self.demandId status:@"7" Success:^(id responseObject) {
                [SVProgressHUD dismiss];
                [self showAlertViewWithText:responseObject[@"message"] duration:1];
                if ([responseObject[@"code"] integerValue] == 200) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
                [self showAlertViewWithText:NETERROETEXT duration:1];
            }];
        }];
        
    }else if ([sender.currentTitle containsString:@"联系客服"]){
        [QLAlertView showAlertTittle:@"确认呼叫服务人员?" message:nil isOnlySureBtn:NO compeletBlock:^{
            [APPLICATION openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:@"010-53350021"]]];
        }];
    }
    
}



@end
