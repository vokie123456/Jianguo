//
//  SettingViewController.m
//  JianGuo
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "SettingViewController.h"
#import "MyTabBarController.h"
#import "MineCell.h"
#import "LoginViewController.h"
#import "AboutUsViewController.h"
#import "FindPassViewController.h"
#import <AVOSCloudIM.h>
#import "JPUSHService.h"
#import "LoginNew2ViewController.h"
#import "CodeLoginViewController.h"
#import "LCChatKit.h"
#import "JGHTTPClient.h"
#import "ChatUser.h"
#import "OpinionsViewController.h"
#import "AboutUsViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *LogoutBtn;

@end

@implementation SettingViewController

-(UIButton *)LogoutBtn
{
    if (!_LogoutBtn) {
        _LogoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _LogoutBtn.frame = CGRectMake(0, 35, SCREEN_W, 44);
        [_LogoutBtn setBackgroundColor:WHITECOLOR];
        [_LogoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_LogoutBtn setTitleColor:RGBCOLOR(255, 148, 147) forState:UIControlStateNormal];
        _LogoutBtn.layer.masksToBounds = YES;
//        [_LogoutBtn setBackgroundColor:RGBCOLOR(255, 148, 147)];
//        _LogoutBtn.layer.cornerRadius = 22;
        [_LogoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _LogoutBtn;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H+20)];
        _tableView.backgroundColor = BACKCOLORGRAY;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = nil;
        _tableView.rowHeight = 45;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self.view addSubview:self.tableView];
    [self customBackBtn];
}
/**
 *  自定义返回按钮
 */
-(void)customBackBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 12, 21);
    [backBtn addTarget:self action:@selector(popToLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
}

/**
 *  返回上一级页面
 */
-(void)popToLoginVC
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = BACKCOLORGRAY;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    CGFloat top = 5;
    CGFloat bottom = 5 ;
    CGFloat left = 0;
    CGFloat right = 0;
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"icon-navigationBar"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return 80;
    }else
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (USER.tel.length? 3 :2)+2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineCell *cell = [MineCell cellWithTableView:tableView];
    
    if(indexPath.row == 0){
//        cell.iconView.image = [UIImage imageNamed:@"icon_password"];
        cell.labelLeft.text = @"修改密码";
        return cell;
    }
    else if (indexPath.row == 1){
//        cell.iconView.image = [UIImage imageNamed:@"jiebang"];
        cell.labelLeft.text = @"更换手机号";
        return cell; 
    }
    else if (indexPath.row == 2){
//        cell.iconView.image = [UIImage imageNamed:@"jiebang"];
        cell.labelLeft.text = @"意见反馈";
        return cell;
    }
    else if (indexPath.row == 3){
//        cell.iconView.image = [UIImage imageNamed:@"jiebang"];
        cell.labelLeft.text = @"关于我们";
        return cell;
    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.contentView addSubview:self.LogoutBtn];
        cell.contentView.backgroundColor = BACKCOLORGRAY;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        
        if (USER.tel.length != 11) {
            [self gotoCodeVC];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
        
        FindPassViewController *findVC = [[FindPassViewController alloc] init];
        [self.navigationController pushViewController:findVC animated:YES];
    }
    else if (indexPath.row == 1) {
        
        if (USER.tel.length != 11) {
            [self gotoCodeVC];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
        CodeLoginViewController *codeVC = [[CodeLoginViewController alloc] init];
        codeVC.isChangePhoneNum = YES;
        [self.navigationController pushViewController:codeVC animated:YES];
        
    }
    else if (indexPath.row == 2) {
        if (USER.tel.length != 11) {
            [self gotoCodeVC];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
        OpinionsViewController *opinionVC = [[OpinionsViewController alloc] init];

        [self.navigationController pushViewController:opinionVC animated:YES];
        
    }
    else if (indexPath.row == 3) {
        
        AboutUsViewController *aboutVC = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)logout:(UIButton *)logoutBtn
{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定退出登录?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
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
//        APPLICATION.keyWindow.rootViewController = [[MyTabBarController alloc] init];
//        MyTabBarController *myTabBarVC = (MyTabBarController *)APPLICATION.keyWindow.rootViewController;
////        LCCKConversationListViewController *messageVC = [myTabBarVC.viewControllers objectAtIndex:2];
////        [messageVC initWithNibName:nil bundle:nil];
//        [myTabBarVC.viewControllers objectAtIndex:2] = [[LCCKConversationListViewController alloc] init];
        
        //刷新界面
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:cancelAC];
    [alertVC addAction:sureAC];
    [self presentViewController:alertVC animated:YES completion:nil];
    
//    AVIMClient *client = [[JGIMClient shareJgIm] getAclient];
//    [client closeWithCallback:^(BOOL succeeded, NSError *error) {
//        
//    }];
//    [[JGIMClient shareJgIm] setNull];
//
//    [JGUser deleteuser];
//    APPLICATION.keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
}
/**
 *  去登录
 */
-(void)gotoCodeVC
{
    LoginNew2ViewController *loginVC= [[LoginNew2ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
