//
//  MineNewViewController.m
//  JianGuo
//
//  Created by apple on 17/6/19.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MineNewViewController.h"
#import "MineChatViewController.h"
#import "RealNameNewViewController.h"
#import "MyWalletNewViewController.h"
#import "LoginNew2ViewController.h"
#import "MyPartJobViewController.h"
#import "WebViewController.h"
#import "EditProfileViewController.h"
#import "FindPassViewController.h"
#import "OpinionsViewController.h"
#import "AboutUsViewController.h"
#import "MyPostDemandViewController.h"
#import "MySignDemandsViewController.h"

#import "MineCell.h"

#import "JGHTTPClient+Mine.h"

#import <WZLBadgeImport.h>
#import "UIImageView+WebCache.h"
#import "LCChatKit.h"
#import "JPUSHService.h"
#import "QLAlertView.h"

@interface MineNewViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *publishB;
@property (weak, nonatomic) IBOutlet UIButton *signB;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *confirmStatusL;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *describL;

@end

@implementation MineNewViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [NotificationCenter addObserver:self selector:@selector(requestMineInfo) name:kNotificationLoginSuccessed object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestMineInfo];
}

-(void)requestMineInfo
{
    
    if (USER.tel.length!=11) {
        return;
    }
    
    [JGHTTPClient getMineInfoSuccess:^(id responseObject) {
        
        NSInteger postCount = [responseObject[@"data"][@"releaseJobSumNum"] integerValue];
        NSInteger signCount = [responseObject[@"data"][@"enrollSumNum"] integerValue];
        CGFloat ownMoney = [responseObject[@"data"][@"sumMoney"] floatValue];
        NSString *name = responseObject[@"data"][@"nickname"];
        
        self.publishB.badgeFont = FONT(12);
        self.signB.badgeFont = FONT(12);
        [self.publishB showBadgeWithStyle:WBadgeStyleNumber value:postCount animationType:WBadgeAnimTypeNone];
        [self.signB showBadgeWithStyle:WBadgeStyleNumber value:signCount animationType:WBadgeAnimTypeNone];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",responseObject[@"data"][@"headImg"]]] placeholderImage:[UIImage imageNamed:@"myicon"]];
        
        self.moneyL.text = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"money"]floatValue]];
        
        NSInteger status = [responseObject[@"data"][@"authUserStatus"] integerValue];
        
        if (status == 1) {
            self.confirmStatusL.text = @"未认证";
        }else if (status == 2){
            self.confirmStatusL.text = @"已认证";
        }else if (status == 3){
            self.confirmStatusL.text = @"审核中";
        }else if (status == 4){
            self.confirmStatusL.text = @"被拒绝";
        }
        
        self.nameL.text = name.length?name:@"未填写";
        NSMutableAttributedString *descriptionStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我已经在兼果校园赚取了%.2f元啦",ownMoney]];
        NSString *aaa = [NSString stringWithFormat:@"%.2f",ownMoney];
        NSRange range = [[NSString stringWithFormat:@"我已经在兼果校园赚取了%.2f元啦",ownMoney] rangeOfString:aaa];
        [descriptionStr addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:range];
        self.describL.attributedText = descriptionStr;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
        
    } failure:^(NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1&&indexPath.row == 5) {
        return 100;
    }
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section?6:1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineCell *cell = [MineCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        
        cell.labelLeft.text = @"兼职管理";
        cell.iconView.image = [UIImage imageNamed:@"admitted"];
        cell.lineView.hidden = YES;
        
    }
    else if (indexPath.section==1){
        
        if (indexPath.row == 0) {
            cell.labelLeft.text = @"编辑资料";
            cell.iconView.image = [UIImage imageNamed:@"data"];
        }else if (indexPath.row == 1){
            cell.labelLeft.text = @"兼果学堂";
            cell.iconView.image = [UIImage imageNamed:@"study_mine"];
        }else if (indexPath.row == 2){
            cell.labelLeft.text = @"修改密码";
            cell.iconView.image = [UIImage imageNamed:@"password_mine"];
        }else if (indexPath.row == 3){
            cell.labelLeft.text = @"意见反馈";
            cell.iconView.image = [UIImage imageNamed:@"opinion"];
        }else if (indexPath.row == 4){
            cell.labelLeft.text = @"关于我们";
            cell.iconView.image = [UIImage imageNamed:@"we"];
            cell.lineView.hidden = YES;
        }else if (indexPath.row == 5){
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.contentView.backgroundColor = BACKCOLORGRAY;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *logoutB = [UIButton buttonWithType:UIButtonTypeCustom];
            logoutB.frame = CGRectMake(20, 50, SCREEN_W-40, 40);
            logoutB.backgroundColor = GreenColor;
            
            if (![self checkExistPhoneNum]) {
                [logoutB setTitle:@"登录" forState:UIControlStateNormal];
                
            }else{
                [logoutB setTitle:@"退出登录" forState:UIControlStateNormal];
            }
            logoutB.layer.cornerRadius = 5;
            [logoutB addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:logoutB];
            
            return cell;
            
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {//兼职管理
        
        if (![self checkExistPhoneNum]) {
            [self gotoLoginVC];
            return;
        }
        MyPartJobViewController *myPartjobVC = [[MyPartJobViewController alloc] init];
        myPartjobVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myPartjobVC animated:YES];
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {//编辑资料
            
            if (![self checkExistPhoneNum]) {
                [self gotoLoginVC];
                return;
            }
            EditProfileViewController *editVC = [[EditProfileViewController alloc] init];
            editVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: editVC animated:YES];
            
        }else if (indexPath.row == 1) {//兼职学堂
            
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.hidesBottomBarWhenPushed = YES;
            webVC.title = @"兼果学堂";
            webVC.url = @"http://101.200.195.147:8888/newJianguoSchool.html";
            [self.navigationController pushViewController:webVC animated:YES];
            
        }else if (indexPath.row == 2) {//修改密码
            
            if (USER.tel.length != 11) {
                [self gotoCodeVC];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                return;
            }
            
            FindPassViewController *findVC = [[FindPassViewController alloc] init];
            findVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:findVC animated:YES];
            
        }else if (indexPath.row == 3) {//意见反馈
            
            if (USER.tel.length != 11) {
                [self gotoCodeVC];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                return;
            }
            OpinionsViewController *opinionVC = [[OpinionsViewController alloc] init];
            opinionVC.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:opinionVC animated:YES];
            
        }else if (indexPath.row == 4) {//关于我们
            
            AboutUsViewController *aboutVC = [[AboutUsViewController alloc] init];
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
            
        }
        
    }
    
}

- (IBAction)published:(UIButton *)sender {
    
    if (![self checkExistPhoneNum]) {
        [self gotoLoginVC];
        return;
    }
    MyPostDemandViewController *postVC = [[MyPostDemandViewController alloc] init];
    postVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postVC animated:YES];
    
}

- (IBAction)sign:(id)sender {
    
    if (![self checkExistPhoneNum]) {
        [self gotoLoginVC];
        return;
    }
    MySignDemandsViewController *signVC = [[MySignDemandsViewController alloc] init];
    signVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signVC animated:YES];
    
}

- (IBAction)wallet:(id)sender {
    
    //我的钱包

    if (![self checkExistPhoneNum]) {
        [self gotoLoginVC];
        return;
    }
    MyWalletNewViewController *walletVC = [[MyWalletNewViewController alloc] init];
    walletVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:walletVC animated:YES];
        

    
}
- (IBAction)realName:(id)sender {
    if (![self checkExistPhoneNum]) {
        [self gotoLoginVC];
        return;
    }
    if (USER.resume.intValue == 0){
        [self showAlertViewWithText:@"请您先去完善资料" duration:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gotoProfileVC];
        });
        return;
    }
    RealNameNewViewController *realNameVC = [[RealNameNewViewController alloc] init];
    realNameVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:realNameVC animated:YES];
    
}
- (IBAction)header:(id)sender {
    if (![self checkExistPhoneNum]) {
        [self gotoLoginVC];
        return;
    }
    MineChatViewController *mineVC = [[MineChatViewController alloc] init];
    mineVC.userId = USER.login_id;
    mineVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mineVC animated:YES];
    
}

-(void)gotoLoginVC
{
    LoginNew2ViewController *loginVC= [[LoginNew2ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)logout:(UIButton *)sender
{
    if (![sender.currentTitle containsString:@"退出"]) {
        [self gotoLoginVC];
        return;
    }
    
    [QLAlertView showAlertTittle:@"确定退出登录?" message:nil isOnlySureBtn:NO compeletBlock:^{
        
        [[LCChatKit sharedInstance] closeWithCallback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                JGLog(@"关闭果聊成功!!!!");
                
                [NotificationCenter postNotificationName:kNotificationClosedChatKit object:nil];
                
            } else {
                JGLog(@"关闭果聊失败????");
            }
        }];
        
        [JGUser deleteuser];
        [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:nil];
        [NotificationCenter postNotificationName:kNotificationLogoutSuccessed object:nil];
        
        
        self.nameL.text = @"未登录";
        self.describL.text = @"点击登录";
        self.moneyL.text = @"未登录";
        self.confirmStatusL.text = @"未登录";
        self.iconView.image = [UIImage imageNamed:@"myicon"];
        [self.publishB clearBadge];
        [self.signB clearBadge];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView setContentOffset:CGPointMake(0, 0)];
        
    }];
}

-(void)dealloc
{
    [NotificationCenter removeObserver:self name:kNotificationLoginSuccessed object:nil];
}

@end
