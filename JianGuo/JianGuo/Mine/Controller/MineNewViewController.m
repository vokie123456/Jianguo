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
#import "AddressListViewController.h"
#import "CollectionsViewController.h"
#import "MySkillsViewController.h"
#import "MyBuySkillViewController.h"
#import "WebViewController.h"
#import "PostSkillViewController.h"
#import "AllSkillManageViewController.h"
#import "DemandStatusParentViewController.h"

#import "MineCell.h"

#import "JGHTTPClient+Mine.h"

#import <WZLBadgeImport.h>
#import "UIImageView+WebCache.h"
#import "LCChatKit.h"
#import "JPUSHService.h"
#import "QLAlertView.h"
#import "AlertView.h"

@protocol SKillConfirmDelegate <NSObject>

-(void)alert;

@end

@interface SkillConfirmSuccessView : NSObject

/** delegate */
@property (nonatomic,weak) id <SKillConfirmDelegate> delegate;

+(instancetype)shareAlertView;

-(void)showSuccessView;

@end

@implementation SkillConfirmSuccessView
{
    UIView *bgView;
}

+(instancetype)shareAlertView
{
    static SkillConfirmSuccessView *view;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        view = [SkillConfirmSuccessView new];
    });
    return view;
}

-(void)showSuccessView
{
    bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [bgView addGestureRecognizer:tap];
    
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 220)];
    alertView.center = bgView.center;
    alertView.layer.cornerRadius = 10;
    alertView.backgroundColor = WHITECOLOR;
    [bgView addSubview:alertView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, alertView.width, 30)];
    label.text = @"认证条件";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    [alertView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, label.bottom, alertView.width-40, 50)];
    label1.text = @"只有在兼果校园发不过技能,才能成为技能达人哦!";
    label1.numberOfLines = 0;
    label1.textColor = LIGHTGRAYTEXT;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont boldSystemFontOfSize:16];
    [alertView addSubview:label1];
    
    
    UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
    [sender setTitle:@"发布技能" forState:UIControlStateNormal];
    [sender setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [sender setBackgroundColor:GreenColor];
    sender.layer.cornerRadius = 3;
    [sender addTarget:self action:@selector(postSkill) forControlEvents:UIControlEventTouchUpInside];
    sender.frame = CGRectMake(30, alertView.height-60, alertView.width-60, 40);
    [alertView addSubview:sender];
    
    [APPLICATION.keyWindow addSubview:bgView];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
}

-(void)postSkill
{
    if ([self.delegate respondsToSelector:@selector(alert)]) {
        [self.delegate alert];
        
    }
    [self dismiss:nil];
}

-(void)dismiss:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        bgView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [bgView removeFromSuperview];
        
    }];
}

@end
@interface MineNewViewController ()<UITableViewDataSource,UITableViewDelegate,SKillConfirmDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *publishB;
@property (weak, nonatomic) IBOutlet UIButton *signB;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *confirmStatusL;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *describL;
@property (weak, nonatomic) IBOutlet UIButton *myBuyB;
@property (weak, nonatomic) IBOutlet UIButton *mySkillB;
@property (weak, nonatomic) IBOutlet UILabel *skillConfirmL;

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
        NSInteger mySkillCount = [responseObject[@"data"][@"skillPublishNum"] integerValue];
        NSInteger myBuySkillCount = [responseObject[@"data"][@"skillBuyNum"] integerValue];
        CGFloat ownMoney = [responseObject[@"data"][@"sumMoney"] floatValue];
        NSString *name = responseObject[@"data"][@"nickname"];
        
        self.publishB.badgeFont = FONT(12);
        self.signB.badgeFont = FONT(12);
        self.mySkillB.badgeFont = FONT(12);
        self.myBuyB.badgeFont = FONT(12);
        
        [self.publishB showBadgeWithStyle:WBadgeStyleNumber value:postCount+signCount animationType:WBadgeAnimTypeNone];
        [self.signB clearBadge];
        [self.myBuyB showBadgeWithStyle:WBadgeStyleNumber value:myBuySkillCount+mySkillCount animationType:WBadgeAnimTypeNone];
        [self.mySkillB clearBadge];
        
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",responseObject[@"data"][@"headImg"]]] placeholderImage:[UIImage imageNamed:@"myicon"]];
        
        self.moneyL.text = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"money"]floatValue]];
        
        NSInteger status = [responseObject[@"data"][@"authUserStatus"] integerValue];
        
        NSInteger skillStatus = [responseObject[@"data"][@"masterStatus"] integerValue];
        
        
        if (status == 1) {
            self.confirmStatusL.text = @"未认证";
        }else if (status == 2){
            self.confirmStatusL.text = @"已认证";
        }else if (status == 3){
            self.confirmStatusL.text = @"审核中";
        }else if (status == 4){
            self.confirmStatusL.text = @"被拒绝";
        }
        
        if (skillStatus==1) {
            self.skillConfirmL.text = @"已认证";
        }else{
            self.skillConfirmL.text = @"未认证";
        }
        
        self.nameL.text = name.length?name:@"未填写";
        NSMutableAttributedString *descriptionStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我已经在兼果校园赚取了%.2f元啦",ownMoney]];
        NSString *aaa = [NSString stringWithFormat:@"%.2f",ownMoney];
        NSRange range = [[NSString stringWithFormat:@"我已经在兼果校园赚取了%.2f元啦",ownMoney] rangeOfString:aaa];
        [descriptionStr addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:range];
        self.describL.attributedText = descriptionStr;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
        
        
    } failure:^(NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return !section?:10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2&&indexPath.row == 5) {
        return 100;
    }
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 6;
    }
    return 0;
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
            cell.labelLeft.text = @"我的收藏";
            cell.iconView.image = [UIImage imageNamed:@"collection_mine"];
        }else if (indexPath.row == 1){
            cell.labelLeft.text = @"地址管理";
            cell.iconView.image = [UIImage imageNamed:@"address"];
        }
        
    }
    else if (indexPath.section==2){
        
        if (indexPath.row == 0) {
            cell.labelLeft.text = @"编辑资料";
            cell.iconView.image = [UIImage imageNamed:@"data"];
            cell.lineView.hidden = NO;
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
        
    }else if (indexPath.section == 1) {//兼职管理
        
        if (![self checkExistPhoneNum]) {
            [self gotoLoginVC];
            return;
        }
        
        if (indexPath.row == 0) {//我的收藏
            
            CollectionsViewController *collectionVC = [[CollectionsViewController alloc] init];
            collectionVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collectionVC animated:YES];
            
        }else if (indexPath.row == 1){//地址管理
            
            AddressListViewController *addressVC = [[AddressListViewController alloc] init];
            addressVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressVC animated:YES];
            
        }
        
    }else if (indexPath.section == 2){
        
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
- (IBAction)mySkill:(UIButton *)sender {
    
    if (![self checkExistPhoneNum]) {
        [self gotoLoginVC];
        return;
    }
    
    AllSkillManageViewController *manageVC = [[AllSkillManageViewController alloc] init];
    manageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:manageVC animated:YES];
    
}
- (IBAction)myBuy:(UIButton *)sender {
    
    if (![self checkExistPhoneNum]) {
        [self gotoLoginVC];
        return;
    }
//    MyBuySkillViewController *myBuySkillVC = [[MyBuySkillViewController alloc] init];
//    myBuySkillVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:myBuySkillVC animated:YES];
    
    MySkillsViewController *myskillVC = [[MySkillsViewController alloc] init];
    myskillVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myskillVC animated:YES];
    
}

- (IBAction)published:(UIButton *)sender {
    
    if (![self checkExistPhoneNum]) {
        [self gotoLoginVC];
        return;
    }
    DemandStatusParentViewController *postVC = [[DemandStatusParentViewController alloc] init];
    postVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postVC animated:YES];
    
}

- (IBAction)sign:(id)sender {
    
//    if (![self checkExistPhoneNum]) {
//        [self gotoLoginVC];
//        return;
//    }
//    MySignDemandsViewController *signVC = [[MySignDemandsViewController alloc] init];
//    signVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:signVC animated:YES];
    
    if (![self checkExistPhoneNum]) {
        [self gotoLoginVC];
        return;
    }
    MyPartJobViewController *myPartjobVC = [[MyPartJobViewController alloc] init];
    myPartjobVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myPartjobVC animated:YES];
    
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

- (IBAction)skillConfirm:(id)sender {
    
    if (![self checkExistPhoneNum]) {
        [self gotoLoginVC];
        return;
    }
    if (USER.status.intValue == 1){
        [self showAlertViewWithText:@"请您先去实名认证" duration:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            RealNameNewViewController *realNameVC = [[RealNameNewViewController alloc] init];
            realNameVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:realNameVC animated:YES];
        });
        return;
    }
    
    if ([self.skillConfirmL.text isEqualToString:@"未认证"]) {
        
        SkillConfirmSuccessView *alertView = [SkillConfirmSuccessView shareAlertView];
        alertView.delegate = self;
        [alertView showSuccessView];
        
    }else if([self.skillConfirmL.text isEqualToString:@"已认证"]){
        [self showAlertViewWithText:@"您已经是兼果校园达人了哦" duration:2];
    }
}

-(void)alert
{
    PostSkillViewController *postVC = [[PostSkillViewController alloc] init];
    postVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postVC animated:YES];
    
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
        [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            
        }];
//        [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
        [NotificationCenter postNotificationName:kNotificationLogoutSuccessed object:nil];
        
        
        self.nameL.text = @"未登录";
        self.describL.text = @"点击登录";
        self.moneyL.text = @"未登录";
        self.confirmStatusL.text = @"未登录";
        self.iconView.image = [UIImage imageNamed:@"myicon"];
        [self.publishB clearBadge];
        [self.signB clearBadge];
        [self.myBuyB clearBadge];
        [self.mySkillB clearBadge];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView setContentOffset:CGPointMake(0, 0)];
        
    }];
}

-(void)dealloc
{
    [NotificationCenter removeObserver:self name:kNotificationLoginSuccessed object:nil];
}

@end
