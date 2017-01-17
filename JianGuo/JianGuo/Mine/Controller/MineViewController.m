//
//  MineViewController.m
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MineViewController.h"
#import "AvatarBrowser.h"
#import "JPUSHService.h"
#import "AboutUsViewController.h"
#import <AVOSCloudIM.h>
#import "MineCell.h"
#import "MineHeaderView.h"
#import "RealNameViewController.h"
#import "MyCVViewController.h"
#import "SettingViewController.h"
#import "OpinionsViewController.h"
#import "CollectViewController.h"
#import "ReceivedJudgeViewController.h"
#import "MyWalletViewController.h"
#import "MyPartJobViewController.h"
#import "LoginNewViewController.h"
#import "PrefrenceViewController.h"
#import "LCChatKit.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,MineHeaderDelegate>
{
    MineHeaderView *mineHeaderView;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UIButton *LogoutBtn;

@end

@implementation MineViewController

-(UIButton *)LogoutBtn
{
    if (!_LogoutBtn) {
        _LogoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _LogoutBtn.frame = CGRectMake(40, mineHeaderView.height+250+90, SCREEN_W-80, SCREEN_W==320?30: 40);
        [_LogoutBtn setTitle:USER.phoneNum.length==11?@"退出登录":@"登录" forState:UIControlStateNormal];
        _LogoutBtn.layer.masksToBounds = YES;
        [_LogoutBtn setBackgroundColor:RGBCOLOR(255, 148, 147)];
        _LogoutBtn.layer.cornerRadius = SCREEN_W==320?15: 20;
        [_LogoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _LogoutBtn;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_W, SCREEN_H+20)];
        _tableView.backgroundColor = BACKCOLORGRAY;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        mineHeaderView = [MineHeaderView aMineHeaderView];
        self.iconView = mineHeaderView.iconView;
        mineHeaderView .delegate = self;
        _tableView.tableHeaderView = mineHeaderView;
        _tableView.tableFooterView = nil;
        _tableView.rowHeight = 45;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NotificationCenter addObserver:self selector:@selector(reloadHeaderView) name:kNotificationLoginSuccessed object:nil];
    
    [self.view addSubview:self.tableView];
    
    if (SCREEN_W == 320) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    }
    
//    [self.tableView addSubview:self.LogoutBtn];
    
     [self setnavigationBarButton];
}
/**
 *  设置导航条上的按钮
 */
-(void)setnavigationBarButton
{
    UIButton *btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setBackgroundImage:[UIImage imageNamed:@"icon_shezhi"] forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(ClickMessage) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 19, 18);
    //提醒按钮
//    self.msgRemindView = [[UIView alloc] initWithFrame:CGRectMake(btn_r.right-2, -2, 5, 5)];
//    self.msgRemindView.backgroundColor = [UIColor redColor];
//    self.msgRemindView.layer.masksToBounds = YES;
//    self.msgRemindView.layer.cornerRadius = 2;
//    [btn_r addSubview:self.msgRemindView];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.tableView reloadData];
}

#pragma mark  tableView 的代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if (section == 1){
        return 2;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineCell *cell = [MineCell cellWithTableView:tableView];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.labelLeft.text = @"求职意向";

            cell.iconView.image = [UIImage imageNamed:@"select"];
            
        }else if (indexPath.row == 1) {
            cell.labelLeft.text = @"我的资料";
//            cell.labelRight.text = @"90";
            cell.iconView.image = [UIImage imageNamed:@"icon_pingjia"];
            
        }else if (indexPath.row == 2){
            cell.labelLeft.text = @"兼职管理";
            cell.iconView.image = [UIImage imageNamed:@"icon_guanli"];
        }else if (indexPath.row == 3){
            cell.labelLeft.text = @"我的收藏";
            cell.lineView.hidden = YES;
            cell.iconView.image = [UIImage imageNamed:@"shoucang"];
        }
    }
    else if (indexPath.section==1){
        
        if (indexPath.row == 0) {
            cell.labelLeft.text = @"意见反馈";
            cell.iconView.image = [UIImage imageNamed:@"icon_fankui"];
        }else if (indexPath.row == 1){
            cell.labelLeft.text = @"关于我们";
            cell.iconView.image = [UIImage imageNamed:@"icon_we"];
            cell.lineView.hidden = YES;
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
              
            case 0:
                //求职意向
            {
                if (![self checkExistPhoneNum]) {
                    [self gotoCodeVC];
                    return;
                }
                
                PrefrenceViewController *preferenceVC = [[PrefrenceViewController alloc] init];
                preferenceVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:preferenceVC animated:YES];
                break;
            }
            case 1:
                //我的资料
                
                if (![self checkExistPhoneNum]) {
                    [self gotoCodeVC];
                    return;
                }
                
                [self gotoMyJianLiVC];
                
                break;
            case 2:
                //兼职管理
            {
                if (![self checkExistPhoneNum]) {
                    [self gotoCodeVC];
                    return;
                }
                MyPartJobViewController *myPartjobVC = [[MyPartJobViewController alloc] init];
                myPartjobVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myPartjobVC animated:YES];
                break;
            }
            case 3:
                //收藏与关注
            {
                
//                LCCKContactListViewController*chatVC = [[LCCKContactListViewController alloc] initWithNibName:nil bundle:nil];
//                [self.navigationController pushViewController:chatVC animated:YES];
                if (![self checkExistPhoneNum]) {
                    [self gotoCodeVC];
                    return;
                }
                CollectViewController *collectionVC = [[CollectViewController alloc] init];
                collectionVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:collectionVC animated:YES];
            }
                
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1){
    
        switch (indexPath.row) {
            case 0:
                //意见反馈
            {
                if (![self checkExistPhoneNum]) {
                    [self gotoCodeVC];
                    return;
                }
                OpinionsViewController *opinionVC = [[OpinionsViewController alloc] init];
                opinionVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:opinionVC animated:YES];
                
            }
                
                break;
            case 1:
                //设置
            {
                if (![self checkExistPhoneNum]) {
                    [self gotoCodeVC];
                return;
                }

                AboutUsViewController *aboutUs = [[AboutUsViewController alloc] init];
                aboutUs.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutUs animated:YES];
            }
                
                break;
                
            default:
                break;
        }
        
    }
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/**
 *  点击实名认证按钮
 */
-(void)clickRealnameBtn
{
    if (![self checkExistPhoneNum]) {
        [self gotoCodeVC];
        return;
    }
    RealNameViewController *realNameVC = [[RealNameViewController alloc] init];
    realNameVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:realNameVC animated:YES];
}
/**
 *  点击钱包按钮
 */
-(void)clickWalletBtn
{
    if (![self checkExistPhoneNum]) {
        [self gotoCodeVC];
        return;
    }
    if (USER.status.intValue == 0||USER.status.intValue == 1) {
        [self showAlertViewWithText:@"请先去实名认证" duration:1];
        return;
    }
    MyWalletViewController *walletVC = [[MyWalletViewController alloc] init];
    walletVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:walletVC animated:YES];
}
/**
 *  点击头像去登录页面
 */
-(void)gotoLoginVC
{
    if (USER.phoneNum.length != 11) {
        [self gotoCodeVC];
        return;
    }else{
        [AvatarBrowser showImage:self.iconView];
    }
}

/**
 *  点击提醒信息按钮事件
 */
-(void)ClickMessage
{
    if (USER.phoneNum.length != 11) {
        [self gotoCodeVC];
        return;
    }
    
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    settingVC.refreshBlock = ^(){
        [self reloadHeaderView];
    };
    [self.navigationController pushViewController:settingVC animated:YES];
}
/**
 *  点击进入个人简历
 */
-(void)gotoMyJianLiVC
{
    
    MyCVViewController *JianliVC = [[MyCVViewController alloc] init];
    
    JianliVC.iconImageBlock = ^(UIImage *iconImage){
        
        self.iconView.image = iconImage;

    };
    
    JianliVC.reloadView = ^{
        [self reloadHeaderView];
    };
    
    JianliVC.hidesBottomBarWhenPushed = YES;    
    
    [self.navigationController pushViewController:JianliVC animated:YES];
}
/**
 *  去登录
 */
-(void)gotoCodeVC
{
    LoginNewViewController *codeVC= [[LoginNewViewController alloc]init];
    codeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:codeVC animated:YES];
}

//退出登录
-(void)logout:(UIButton *)logoutBtn
{
    if (USER.phoneNum.length != 11) {
        [self gotoCodeVC];
        return;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定退出登录?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AVIMClient *client = [[JGIMClient shareJgIm] getAclient];
        [client closeWithCallback:^(BOOL succeeded, NSError *error) {
            
        }];
        [[JGIMClient shareJgIm] setNull];
        
        [JGUser deleteuser];
        [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:nil];
        [NotificationCenter postNotificationName:kNotificationLogoutSuccessed object:client];
        //刷新界面
        [self reloadHeaderView];
    }];
    [alertVC addAction:cancelAC];
    [alertVC addAction:sureAC];
    [self presentViewController:alertVC animated:YES completion:nil];
}
/**
 *  刷新界面
 */
-(void)reloadHeaderView
{
    if (USER.phoneNum.length == 11) {
        [self.LogoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    }else{
        [self.LogoutBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
    self.tableView.tableHeaderView = nil;
    mineHeaderView = [MineHeaderView aMineHeaderView];
    self.iconView = mineHeaderView.iconView;
    mineHeaderView .delegate = self;
    self.tableView.tableHeaderView = mineHeaderView;

}

-(void)dealloc
{
    [NotificationCenter removeObserver:self name:kNotificationLoginSuccessed object:nil];
}

@end
