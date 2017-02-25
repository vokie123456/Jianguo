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
#import "LoginNew2ViewController.h"
#import "LoginNewViewController.h"
#import "PrefrenceViewController.h"
#import "LCChatKit.h"
#import "MineHeaderCell.h"
#import "MyWalletNewViewController.h"
#import "MyPostDemandViewController.h"
#import "MySignDemandsViewController.h"
#import <UIButton+AFNetworking.h>
#import "JGHTTPClient+Mine.h"
#import "DateOrTimeTool.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,MineHeaderDelegate>
{
    MineHeaderView *mineHeaderView;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UIButton *LogoutBtn;
@property (nonatomic,strong) UIButton *iconBtn;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UIButton *ageBtn;
@property (nonatomic,strong) UILabel *starL;
@property (nonatomic,strong) JianliAccount *account;

@end

@implementation MineViewController

-(UIButton *)LogoutBtn
{
    if (!_LogoutBtn) {
        _LogoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _LogoutBtn.frame = CGRectMake(40, mineHeaderView.height+250+90, SCREEN_W-80, SCREEN_W==320?30: 40);
        [_LogoutBtn setTitle:USER.tel.length==11?@"退出登录":@"登录" forState:UIControlStateNormal];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BACKCOLORGRAY;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        mineHeaderView = [MineHeaderView aMineHeaderView];
//        self.iconView = mineHeaderView.iconView;
//        mineHeaderView .delegate = self;
//        _tableView.tableHeaderView = mineHeaderView;
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
    
    [self request];
}

-(void)request
{
    JGSVPROGRESSLOAD(@"正在拼命加载中...");
    [JGHTTPClient getJianliInfoByloginId:[JGUser user].login_id Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        JGLog(@"%@",responseObject);
        if (responseObject) {
            
            self.account = [JianliAccount mj_objectWithKeyValues:responseObject[@"data"]];
            
            [self.iconBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.account.head_img_url] placeholderImage:[UIImage imageNamed:@"myicon"]];
            NSString *timeNow = [NSString stringWithFormat:@"%@",[NSDate date]];
            NSInteger age = [timeNow substringToIndex:4].integerValue - [self.account.birth_date substringToIndex:4].integerValue;
            [self.ageBtn setTitle:[NSString stringWithFormat:@"%ld",age] forState:UIControlStateNormal];
            if (self.account.sex.integerValue == 1) {//女
                [self.ageBtn setImage:[UIImage imageNamed:@"girlclear"] forState:UIControlStateNormal];
            }else{
                [self.ageBtn setImage:[UIImage imageNamed:@"boyclear"] forState:UIControlStateNormal];
            }
//            NSArray *array = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
            self.starL.text = [DateOrTimeTool getConstellation:self.account.birth_date]?[DateOrTimeTool getConstellation:self.account.birth_date]:@"未填写";
            self.nameL.text = self.account.nickname;
            
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
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
    
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]};
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTranslucent:YES];
    
}

#pragma mark  tableView 的代理方法

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
        return 100;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineCell *cell = [MineCell cellWithTableView:tableView];

    if (indexPath.section == 0) {
       
        MineHeaderCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MineHeaderCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.iconBtn = cell.iconBtn;
        self.nameL = cell.nameL;
        self.ageBtn = cell.ageBtn;
        self.starL = cell.starL;
        return cell;
        
    }
    else if (indexPath.section == 1) {

        if (indexPath.row == 0) {
            cell.labelLeft.text = @"我的钱包";
            cell.iconView.image = [UIImage imageNamed:@"wallet"];
            
        }else if (indexPath.row == 1){
            cell.labelLeft.text = @"实名认证";
            cell.lineView.hidden = YES;
            cell.iconView.image = [UIImage imageNamed:@"name"];
        }

    }
    else if (indexPath.section==2){
        
        if (indexPath.row == 0) {
            cell.labelLeft.text = @"我发布的任务";
            cell.iconView.image = [UIImage imageNamed:@"release"];
        }else if (indexPath.row == 1){
            cell.labelLeft.text = @"我报名的任务";
            cell.iconView.image = [UIImage imageNamed:@"sign"];
            cell.lineView.hidden = YES;
        }
        
    }
    
    else if (indexPath.section==3){
        
        if (indexPath.row == 0) {
            cell.labelLeft.text = @"兼职管理";
            cell.iconView.image = [UIImage imageNamed:@"management"];
        }else if (indexPath.row == 1){
            cell.labelLeft.text = @"我的收藏";
            cell.iconView.image = [UIImage imageNamed:@"xin"];
            cell.lineView.hidden = YES;
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
              
            case 10:
                //求职意向
            {
                if (![self checkExistPhoneNum]) {
                    [self gotoLoginVC];
                    return;
                }
                
                PrefrenceViewController *preferenceVC = [[PrefrenceViewController alloc] init];
                preferenceVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:preferenceVC animated:YES];
                break;
            }
            case 0:
                //我的资料
                
                if (![self checkExistPhoneNum]) {
                    [self gotoLoginVC];
                    return;
                }
                
                [self gotoMyJianLiVC];
                
                break;
           
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1){
    
        switch (indexPath.row) {
            case 0:
                //我的钱包
            {
                if (![self checkExistPhoneNum]) {
                    [self gotoLoginVC];
                    return;
                }
                MyWalletNewViewController *walletVC = [[MyWalletNewViewController alloc] init];
                walletVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:walletVC animated:YES];
                
            }
                
                break;
            case 1:
                //实名认证
            {
                if (![self checkExistPhoneNum]) {
                    [self gotoLoginVC];
                    return;
                }
                RealNameViewController *realNameVC = [[RealNameViewController alloc] init];
                realNameVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:realNameVC animated:YES];
                
            }
                
                break;
                
            default:
                break;
        }
        
    }else if (indexPath.section == 2){
        
        switch (indexPath.row) {
            case 0:
                //我发布的任务
            {
                if (![self checkExistPhoneNum]) {
                    [self gotoLoginVC];
                    return;
                }
                
                MyPostDemandViewController *demandVC = [[MyPostDemandViewController alloc] init];
                demandVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:demandVC animated:YES];
                
            }
                
                break;
            case 1:
                //我报名的任务
            {
                if (![self checkExistPhoneNum]) {
                    [self gotoLoginVC];
                    return;
                }
                
                MySignDemandsViewController *demandVC = [[MySignDemandsViewController alloc] init];
                demandVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:demandVC animated:YES];
                
            }
                
                break;
            default:
                break;
        }
        
    }else if (indexPath.section == 3){
        switch (indexPath.row) {
            case 0:
                //兼职管理
            {
                if (![self checkExistPhoneNum]) {
                    [self gotoLoginVC];
                    return;
                }
                MyPartJobViewController *myPartjobVC = [[MyPartJobViewController alloc] init];
                myPartjobVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myPartjobVC animated:YES];
                break;
            }
            case 1:
                //收藏与关注
            {
                if (![self checkExistPhoneNum]) {
                    [self gotoLoginVC];
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
}

/**
 *  点击实名认证按钮
 */
-(void)clickRealnameBtn
{
    if (![self checkExistPhoneNum]) {
        [self gotoLoginVC];
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
        [self gotoLoginVC];
        return;
    }
//    if (USER.status.intValue == 0||USER.status.intValue == 1) {
//        [self showAlertViewWithText:@"请先去实名认证" duration:1];
//        return;
//    }
    MyWalletViewController *walletVC = [[MyWalletViewController alloc] init];
    walletVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:walletVC animated:YES];
}
/**
 *  点击头像去登录页面
 */
-(void)clickIconView
{
    if (USER.tel.length != 11) {
        [self gotoLoginVC];
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
    if (USER.tel.length != 11) {
        [self gotoLoginVC];
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
-(void)gotoLoginVC
{
    LoginNew2ViewController *loginVC= [[LoginNew2ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
    
//    LoginNewViewController *oldLoginVC= [[LoginNewViewController alloc]init];
//
//    [self.navigationController pushViewController:oldLoginVC animated:YES];
}

//退出登录
-(void)logout:(UIButton *)logoutBtn
{
    if (USER.tel.length != 11) {
        [self gotoLoginVC];
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
//    if (USER.tel.length == 11) {
//        [self.LogoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//    }else{
//        [self.LogoutBtn setTitle:@"登录" forState:UIControlStateNormal];
//    }
//    self.tableView.tableHeaderView = nil;
//    mineHeaderView = [MineHeaderView aMineHeaderView];
//    self.iconView = mineHeaderView.iconView;
//    mineHeaderView .delegate = self;
//    self.tableView.tableHeaderView = mineHeaderView;

}

-(void)dealloc
{
    [NotificationCenter removeObserver:self name:kNotificationLoginSuccessed object:nil];
}

@end
