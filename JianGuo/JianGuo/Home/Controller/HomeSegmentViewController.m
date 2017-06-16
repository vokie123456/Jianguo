//
//  HomeSegmentViewController.m
//  JianGuo
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "HomeSegmentViewController.h"
#import "CityModel.h"
#import "SchoolModel.h"
#import "DemandListViewController.h"
#import "HomeViewController.h"
#import "SelectCityController.h"
#import "CitySchoolViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "WZLBadgeImport.h"
#import "RemindMsgViewController.h"
#import "MyWalletNewViewController.h"
#import "RealNameViewController.h"
#import "SignDemandViewController.h"

#import "MyPostDetailViewController.h"
#import "BillsViewController.h"
#import "DemandDetailController.h"
#import "MySignDetailViewController.h"
#import "JobTypeViewController.h"
#import "JianZhiDetailController.h"
#import "MyPartJobViewController.h"
#import "WebViewController.h"


#define SegmentWidth 160

@interface HomeSegmentViewController ()<UIScrollViewDelegate,AMapLocationManagerDelegate>
{
    HomeViewController *homeVC;
    DemandListViewController *demandListVC;
    BOOL isHandScroll;
    UIButton *btn_r;
}

@property (nonatomic,strong) AMapLocationManager *manager;
@property (nonatomic,strong) UIButton *cityBtn;
@property (nonatomic,strong) UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (nonatomic,copy) NSString *schoolName;
@property (nonatomic,copy) NSString *schoolId;

@end

@implementation HomeSegmentViewController


-(AMapLocationManager *)manager
{
    if (!_manager) {
        _manager = [[AMapLocationManager alloc] init];
        //设置精确度
        [_manager setPausesLocationUpdatesAutomatically:YES];
        _manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [_manager setAllowsBackgroundLocationUpdates:NO];
        _manager.delegate = self;
        [_manager setLocationTimeout:6];
        [_manager setReGeocodeTimeout:3];
    }
    return _manager;
}


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [NotificationCenter addObserver:self selector:@selector(getNewNotiNews) name:kNotificationGetNewNotiNews object:nil];
        [NotificationCenter addObserver:self selector:@selector(clickNotification:) name:kNotificationClickNotification object:nil];
    }
    return  self;
}


-(void)clickNotification:(NSNotification *)noti//点击通知进入应用
{
    NSDictionary *userInfo = noti.object;
    [self fromNotiToMyjobVC:userInfo];
}


-(void)fromNotiToMyjobVC:(NSDictionary *)userInfo
{
    int intType = [userInfo[@"type"] intValue];
    UIViewController *VC;
    switch (intType) {
        case 4:
        case 1:{//报名推送
            
            VC = [[MyPartJobViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case 2:
        case 3:{//主页推送,留在主页就行,不用额外操作
            
            
            JianZhiDetailController *jzdetailVC = [[JianZhiDetailController alloc] init];
            
            jzdetailVC.hidesBottomBarWhenPushed = YES;
            
            jzdetailVC.jobId = userInfo[@"job_id"];
            
            [self.navigationController pushViewController:jzdetailVC animated:YES];
            break;
            
            break;
        }
        case 5:{//钱包推送
            
            VC = [[MyWalletNewViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case 7:
        case 6:{//实名推送
            
            VC = [[RealNameViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case 8:{//收到了果聊消息 –––> 果聊联系人页面
            
            [self.tabBarController setSelectedIndex:1];
            
            break;
        }
        case 9:{//报名了外露的兼职(主要是发短信的形式) –––>不做处理
            
            break;
        }
        case 10:{//发布的任务收到了新报名(–––>我发布的报名列表)
            
            SignDemandViewController *signVC = [SignDemandViewController new];
            signVC.demandId = userInfo[@"jobid"];
            signVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:signVC animated:YES];
            
            break;
        }
            // ***  报名的需求  ***
        case 14://被投诉,收到投诉处理结果(––––>任务详情页面)
        case 13://被雇主投诉(––––>任务详情页面)
        case 16://报名的需求被录用(––––>任务详情页面)
        case 17:{//报名的需求被拒绝(–––>我发布的报名列表)
            MySignDetailViewController *detailVC = [[MySignDetailViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.demandId = userInfo[@"jobid"];
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 15:{//任务服务费用到账(–––>钱包明细,收入明细)
            
            BillsViewController *billVC = [[BillsViewController alloc] init];
            billVC.hidesBottomBarWhenPushed = YES;
            billVC.type = @"1";
            billVC.navigationItem.title = @"收入明细";
            [self.navigationController pushViewController:billVC animated:YES];
            break;
        }
            // ***  发布的需求  ***
        case 11://发布的任务未通过审核
        case 12://发布需求,投诉了服务者,收到了投诉处理结果
        case 18:{//发布的需求收到了新评论(–––>也是任务详情页)
            MyPostDetailViewController *detailVC = [[MyPostDetailViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.demandId = userInfo[@"jobid"];
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 19:{//收到了评论,去普通的需求详情页
            DemandDetailController *detailVC = [[DemandDetailController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.demandId = userInfo[@"jobid"];
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 23:{//自定义推送
            
            RemindMsgViewController *msgVC = [[RemindMsgViewController alloc] init];
            
            msgVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:msgVC animated:YES];
            
            break;
            
        }
        case 24:{//活动推送(H5)
            
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.url = userInfo[@"html_url"];
            
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
            
        case 100:{//活动推送(H5)
            
            break;
        }
    }
}


-(void)getNewNotiNews
{
    [USERDEFAULTS setObject:@"NotiNews" forKey:isHaveNewNews];
    [USERDEFAULTS synchronize];
    
    
    if (btn_r) {//已经创建了信息按钮
        [btn_r showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeShake];
    }
}

/**
 *  点击信息提醒按钮
 */
-(void)ClickMessage
{
    if (![self checkExistPhoneNum]) {
        [self gotoCodeVC];
        return;
    }
    [btn_r clearBadge];
    
    RemindMsgViewController *notiNewsVC = [[RemindMsgViewController alloc] init];
    notiNewsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notiNewsVC animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self location];//定位
    self.schoolName = @"全部学校";

    self.bgScrollView.decelerationRate = UIScrollViewDecelerationRateFast;

    self.bgScrollView.contentSize = CGSizeMake(SCREEN_W*2, 0);
    self.bgScrollView.delegate = self;
    
    [self addChildVC];
    
    [self configNavigationItem];
    
    [self configSegmentControl];
    
    
}

-(void)viewDidLayoutSubviews
{
    demandListVC.view.frame = CGRectMake(0, 0, SCREEN_W, self.bgScrollView.height-49);
    homeVC.view.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, self.bgScrollView.height-49);
}

-(void)selectIndex:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {//校内约
        
        if (self.bgScrollView.contentOffset.x == SCREEN_W) {
            isHandScroll = YES;
            self.segment.userInteractionEnabled = NO;
            [self.bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    }else if (sender.selectedSegmentIndex == 1){//找兼职
        
        if (self.bgScrollView.contentOffset.x == 0) {
            isHandScroll = YES;
            self.segment.userInteractionEnabled = NO;
            [self.bgScrollView setContentOffset:CGPointMake(SCREEN_W, 0) animated:YES];
        }
        
    }
}

-(void)selectCitySChool:(UIButton *)sender
{
    if (self.bgScrollView.contentOffset.x<SCREEN_W/2) {//校内约
        [self selectSChool:sender];
    }else if (self.bgScrollView.contentOffset.x>SCREEN_W/2){//找兼职
        [self selectLocation];
    }
}

//添加子控制器
-(void)addChildVC
{
    homeVC = [HomeViewController new];
    [self addChildViewController:homeVC];
    [self.bgScrollView addSubview:homeVC.view];
    
    demandListVC = [DemandListViewController new];
    [self addChildViewController:demandListVC];
    [self.bgScrollView addSubview:demandListVC.view];
}

//设置导航条上的按钮
-(void)configNavigationItem
{
    
    
    btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setBackgroundImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(ClickMessage) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 19, 14);


    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    if([USERDEFAULTS objectForKey:isHaveNewNews]){
        [btn_r showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeShake];
    }

    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIButton *btn_l = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_l setBackgroundImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
    [btn_l addTarget:self action:@selector(selectCitySChool:) forControlEvents:UIControlEventTouchUpInside];
    btn_l.frame = CGRectMake(-10, 0, 12, 15);
    
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    if (USER.login_id.integerValue>0) {
        
        [btnLocation setTitle:USER.school_name forState:UIControlStateNormal];
    }else{
        
        [btnLocation setTitle:[CityModel city].cityName forState:UIControlStateNormal];
        
    }
    btnLocation.titleLabel.font = FONT(14);
    [btnLocation addTarget:self action:@selector(selectCitySChool:) forControlEvents:UIControlEventTouchUpInside];
    btnLocation.frame = CGRectMake(0, 0, 60, 20);
    btnLocation.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.cityBtn = btnLocation;
    
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_l];
    UIBarButtonItem *bbtLocation = [[UIBarButtonItem alloc] initWithCustomView:btnLocation];
    self.navigationItem.leftBarButtonItems = @[bbtLocation];
}

//设置segmentControl
-(void)configSegmentControl
{
    //先生成存放标题的数据
    NSArray *array = [NSArray arrayWithObjects:@"任务",@"兼职", nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    //设置frame
    segment.frame = CGRectMake((SCREEN_W-SegmentWidth)/2, 10, SegmentWidth, 30);
    [segment setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
    segment.tintColor = WHITECOLOR;
    [segment addTarget:self action:@selector(selectIndex:) forControlEvents:UIControlEventValueChanged];
    //添加到视图
    [segment setSelectedSegmentIndex:0];
    self.segment = segment;
    self.navigationItem.titleView = segment;
    
    
}

//选择学校
-(void)selectSChool:(UIButton *)btn
{
    CitySchoolViewController *schoolVC = [[CitySchoolViewController alloc] init];
    schoolVC.hidesBottomBarWhenPushed = YES;
    schoolVC.selectSchoolBlock = ^(SchoolModel *school,CityModel *city){
        if (school) {
            
            demandListVC.schoolId = school.id;
            self.schoolName = school.name;
            if (school.id.integerValue == 0) {
                
            }else{
                [self.cityBtn setTitle:school.name forState:UIControlStateNormal];
            }
            [homeVC requestList:@"1"];
            [demandListVC requestWithCount:@"1"];
        }else if (city){
            [CityModel saveCity:city];
            [self.cityBtn setTitle:city.cityName forState:UIControlStateNormal];
        }
    };
    [self.navigationController pushViewController:schoolVC animated:YES];
}

/**
 *  选择定位按钮
 */
-(void)selectLocation
{
    IMP_BLOCK_SELF(HomeSegmentViewController);
    SelectCityController *cityVC = [[SelectCityController alloc] init];
    cityVC.dataArr = JGKeyedUnarchiver(JGCityArr);
    cityVC.selectCityBlock = ^(CityModel *cityModel){//传回City 的 model
        [block_self.cityBtn setTitle:cityModel.cityName forState:UIControlStateNormal];
        [CityModel saveCity:cityModel];
        [NotificationCenter postNotificationName:kNotificationCity object:nil];
        [homeVC requestList:@"1"];
        [demandListVC requestWithCount:@"1"];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isHandScroll) {
        if (scrollView == self.bgScrollView) {
            if (self.bgScrollView.contentOffset.x<SCREEN_W/2) {
                [self.segment setSelectedSegmentIndex:0];
                
                JGLog(@"––––––––––––––––––––––––––––––––––––––––")
                [self.cityBtn setTitle:([self.schoolName isEqualToString:@"全部学校"]?[CityModel city].cityName:self.schoolName) forState:UIControlStateNormal];
            }else if (self.bgScrollView.contentOffset.x > SCREEN_W/2){
                [self.segment setSelectedSegmentIndex:1];
                JGLog(@"––––––––––––––––––––––––––––––––––––––––")
                [self.cityBtn setTitle:[CityModel city].cityName forState:UIControlStateNormal];
            }
            
        }
        
    }
    if (self.bgScrollView.contentOffset.x==0||self.bgScrollView.contentOffset.x == SCREEN_W) {
        isHandScroll = NO;
        self.segment.userInteractionEnabled = YES;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isHandScroll = NO;
    self.segment.userInteractionEnabled = YES;
}

//定位
-(void)location
{
    [self.manager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (regeocode) {
            
            [USERDEFAULTS setObject:regeocode.citycode forKey:CityCode];
            
            NSString *cityName = regeocode.city?regeocode.city:regeocode.province;
            
            [USERDEFAULTS setObject:cityName forKey:CityName];
            
            if (cityName.length>1) {
                cityName = [cityName substringWithRange:NSMakeRange(0, cityName.length-1)];
                if ([cityName isEqualToString:[CityModel city].cityName]) {
                    return ;
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位成功" message:@"是否切换到当前定位城市" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        NSArray *array = JGKeyedUnarchiver(JGCityArr);
                        for (CityModel *model in array) {
                            if ([model.cityName isEqualToString:cityName]) {
                                [CityModel saveCity:model];
                                [self.cityBtn setTitle:model.cityName forState:UIControlStateNormal];
                            }
                        }
                        
                        [homeVC requestList:@"0"];
                        [demandListVC requestWithCount:@"1"];
                        [NotificationCenter postNotificationName:kNotificationCity object:nil];
                        
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
            }
        }else{
            if ([[USERDEFAULTS objectForKey:CityCode] integerValue]==0) {
                [self location];//定位失败重新定位
            }
        }
        
    }];
}

-(void)refreshData
{
    [demandListVC requestWithCount:@"1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    PresentingAnimator *animator = [PresentingAnimator new];
    
    animator.scale=1.2;
    
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}


@end
