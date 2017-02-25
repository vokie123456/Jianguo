//
//  HomeViewController.m
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "HomeViewController.h"
#import "MyWalletViewController.h"
#import "RealNameViewController.h"
#import "GuideImageView.h"
#import "JobTypeViewController.h"
#import "PartTypeModel.h"
#import "CityModel.h"
#import "AreaModel.h"
#import "JGHTTPClient.h"
#import "JGHTTPClient+Home.h"
#import "JGHTTPClient+Job.h"
#import "HeaderView.h"
#import "JGUser.h"
#import "JianzhiModel.h"
#import "JianZhiCell.h"
#import "NoDataView.h"
#import "JianZhiDetailController.h"
#import "SelectCityController.h"
#import "MyPartJobViewController.h"
#import "WebViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "QLAlertView.h"
#import "RemindMsgViewController.h"
#import "WZLBadgeImport.h"
#import "LongDateViewController.h"
#import "UpdateView.h"
#import "PrefrenceViewController.h"
#import "LCChatKit.h"
#import "DOPDropDownMenu.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,AMapLocationManagerDelegate,JGHomeHeaderDelegate,AVIMClientDelegate,UIScrollViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    int pageCount;
    UIView *bgView;
    HeaderView *headerView;
    UIButton *btn_r;
}

@property (nonatomic,strong) AMapLocationManager *manager;
@property (nonatomic,strong) CLGeocoder *geocoder;
@property (assign) CLLocationDegrees latitude;
@property (assign) CLLocationDegrees longitude;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *cityModelArr;
@property (nonatomic,strong) UIButton *cityBtn;
@property (nonatomic,assign) BOOL isRequestedData;

@property (nonatomic, strong) DOPDropDownMenu *selectMenu;

@property (nonatomic,strong) NSMutableArray *jobTypeArr;
@property (nonatomic,strong) NSMutableArray *sortTypeArr;
@property (nonatomic,strong) NSMutableArray *areaTypeArr;


/** 职业种类 */
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *areaId;
@property (nonatomic,copy) NSString *sequenceType;

@end

@implementation HomeViewController


-(NSMutableArray *)jobTypeArr
{
    if (!_jobTypeArr) {
        
        NSMutableArray *arr  = (NSMutableArray *)JGKeyedUnarchiver(JGJobTypeArr);
        PartTypeModel *model = [[PartTypeModel alloc] init];
        model.id = @"0";
        model.name = @"全部兼职";
        [arr insertObject:model atIndex:0];
        _jobTypeArr = arr;
    }
    return _jobTypeArr;
}
-(NSMutableArray *)sortTypeArr
{
    if (!_sortTypeArr) {
        _sortTypeArr = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JGSort" ofType:@"plist"]]];
    }
    return _sortTypeArr;
}
-(NSMutableArray *)areaTypeArr
{
    if (!_areaTypeArr) {
        NSMutableArray *arr = (NSMutableArray *)[CityModel city].areaList;
        AreaModel *model = [[AreaModel alloc] init];
        model.id = @"0";
        model.areaName = @"全部地区";
        [arr insertObject:model atIndex:0];
        _areaTypeArr = arr;
    }
    return _areaTypeArr;
}

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
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        headerView = [HeaderView aHeaderView];
        headerView.delegate = self;
        IMP_BLOCK_SELF(HomeViewController);
        headerView.sendCityArrBlock = ^(NSMutableArray *cityModelArr){
            block_self.cityModelArr = cityModelArr;
        };
        _tableView.tableHeaderView = headerView;
        _tableView.rowHeight = 110;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}



-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

        [NotificationCenter addObserver:self selector:@selector(refreshHotJob:) name:kNotificationGetCitySuccess object:nil];
        [NotificationCenter addObserver:self selector:@selector(clickNotification:) name:kNotificationClickNotification object:nil];
        [NotificationCenter addObserver:self selector:@selector(getNewNotiNews) name:kNotificationGetNewNotiNews object:nil];
    }
    return  self;
}

-(void)clickNotification:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.object;
    [self fromNotiToMyjobVC:userInfo];
}

//-(void)changeCity:(NSNotification *)noti
//{
//    [self refreshHotJob];
//}

-(void)getNewNotiNews
{
    [USERDEFAULTS setObject:@"NotiNews" forKey:isHaveNewNews];
    [USERDEFAULTS synchronize];
    
    
    if (btn_r) {//已经创建了信息按钮
        [btn_r showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeShake];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JGLog(@"%@====%@",[CityModel city].cityName,[CityModel city].code);
    
    
//    self.automaticallyAdjustsScrollViewInsets = NO;

    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候调用这个block
        if (status != AFNetworkReachabilityStatusNotReachable) {
            if (USER.tel) {
                
//                if (USER.hobby.intValue==0) {
//                    
//                    PrefrenceViewController *preferenceVC = [[PrefrenceViewController alloc] init];
//                    preferenceVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:preferenceVC animated:YES];
//                
//                }
            }
        }
    }];
    // 开始监控
    [mgr startMonitoring];
    
    [self setnavigationBarButton];
    
    
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:RGBACOLOR(0, 162, 255, 0)] forBarMetrics:UIBarMetricsDefault];
    
//     self.navigationController.navigationBar.layer.masksToBounds = YES;
    
    [[AMapLocationServices sharedServices]setApiKey:@"f20c4451633dac96db2947cb73229359"];
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
                        
                        [self requestList:@"1"];
                        [NotificationCenter postNotificationName:kNotificationCity object:nil];
                        
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
            }
        }

    }];
    
    if (!self.isRequestedData) {
        
        [self requestList:@"1"];
    }
    
    [self.view addSubview:self.tableView];

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{//下拉刷新
        
        self.tableView.tableHeaderView = nil;
        headerView = [HeaderView aHeaderView];
        headerView .delegate = self;
        self.tableView.tableHeaderView = headerView;

        [self requestList:@"1"];
    }];

    self.tableView.mj_header = header;

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
       
        pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>1?1:2);
        [self requestList:[NSString stringWithFormat:@"%d",pageCount]];
    }];

//    if (![self checkExistPhoneNum]) {//没登录
//        
//    }else{
//        //开启聊天客户端
//
//    }
    
//显示引导图片
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
//    if (![[USERDEFAULTS objectForKey:NSStringFromClass([self class])]isEqualToString:currentVersion]) {
////
//        [self addGuideImageView];
//        
//        [USERDEFAULTS setObject:currentVersion forKey:NSStringFromClass([self class])];
//        [USERDEFAULTS synchronize];
//    }
    
    [self initMenu];

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self handleRemoteNotifcation];
    
}

-(void)initMenu{
    self.selectMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    self.selectMenu.delegate = self;
    self.selectMenu.dataSource = self;
    self.selectMenu.textSelectedColor = GreenColor;
    [self.view addSubview:self.selectMenu];
}

/**
 *  添加引导图
 */
-(void)addGuideImageView
{
    GuideImageView *imgView = [[GuideImageView alloc] initWithFrame:APPLICATION.keyWindow.bounds];
    
    imgView.image = [UIImage imageNamed:@"img_guide1"];
    if (SCREEN_W==375||SCREEN_W==414) {
        imgView.image = [UIImage imageNamed:@"img_guide6s1"];
    }

    imgView.count = 1;
    imgView.userInteractionEnabled = YES;
    [self.tabBarController.view addSubview:imgView];
}

/**
 *  处理远程推送的跳转逻辑
 */
-(void)handleRemoteNotifcation
{
    NSDictionary *userInfo = [USERDEFAULTS objectForKey:@"push"];
    if (userInfo) {
        
        NSDictionary *userInfo = [USERDEFAULTS objectForKey:@"push"];
        if (userInfo) {
            
            NSArray *array = [[userInfo objectForKey:@"aps"] allKeys];
            if ([array containsObject:@"type"]||[[userInfo allKeys] containsObject:@"type"]) {
                
                [self fromNotiToMyjobVC:userInfo];
                
            }else{
                UITabBarController *tabVc = (UITabBarController *)APPLICATION.keyWindow.rootViewController;
                [tabVc setSelectedIndex:2];
                
            }
            
            
        }
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"push"];
        
    }
}


-(void)requestList:(NSString *)count
{
    self.isRequestedData = YES;
    JGSVPROGRESSLOAD(@"加载中...")
    [JGHTTPClient getJobsListByHotType:self.type cityId:self.cityId areaId:self.areaId sequenceType:self.sequenceType count:count Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        if (count.intValue>1) {//上拉加载
            
            if ([[JianzhiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (JianzhiModel *model in [JianzhiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            return;
            
        }else{
            [self.dataArr removeAllObjects];
            self.dataArr = [JianzhiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        

    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

/**
 *  设置导航条上的按钮
 */
-(void)setnavigationBarButton
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
    [btn_l addTarget:self action:@selector(selectLocation) forControlEvents:UIControlEventTouchUpInside];
    btn_l.frame = CGRectMake(-10, 0, 10, 12);
    
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLocation setTitle:[CityModel city].cityName forState:UIControlStateNormal];
    btnLocation.titleLabel.font = FONT(14);
    [btnLocation addTarget:self action:@selector(selectLocation) forControlEvents:UIControlEventTouchUpInside];
    btnLocation.frame = CGRectMake(0, 0, 30, 20);
    self.cityBtn = btnLocation;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_l];
    UIBarButtonItem *bbtLocation = [[UIBarButtonItem alloc] initWithCustomView:btnLocation];
    self.navigationItem.leftBarButtonItems = @[bbtLocation,leftBtn];
}

#pragma mark  tableView 的代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count == 0) {
        return 280;
    }else{
        return 110;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count == 0) {
        return 1;
    }else{
        return self.dataArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.dataArr.count == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        [cell.contentView addSubview:[NoDataView aNoDataView]];
        cell.contentView.backgroundColor = BACKCOLORGRAY;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSelected:YES animated:YES];
        return cell;
    }else{
        static NSString *identifer = @"homecell";
        JianZhiCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JianZhiCell" owner:nil options:nil]lastObject];
        }
        JianzhiModel *model = self.dataArr[indexPath.row];
        cell.model = model;
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return self.selectMenu;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataArr.count == 0){
        return;
    }
    
    
    JianZhiCell *cell = (JianZhiCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    JianzhiModel *model = self.dataArr[indexPath.row];
    
    JianZhiDetailController *jzdetailVC = [[JianZhiDetailController alloc] init];
    
    if (cell.leftCountL.hidden) {//隐藏的时候是招满了
        NSMutableAttributedString *sendCount = [[NSMutableAttributedString alloc] initWithString:@"已经招满"];
        [sendCount addAttributes:@{NSForegroundColorAttributeName:RedColor} range:NSMakeRange(0, sendCount.length)];
        
        jzdetailVC.sendCount = sendCount;

    }else{//不隐藏的时候是吧显示的内容直接传过去
        jzdetailVC.sendCount = cell.leftCountL.attributedText;
    }
    
    jzdetailVC.hidesBottomBarWhenPushed = YES;
    
    jzdetailVC.jobId = model.id;

    
    [self.navigationController pushViewController:jzdetailVC animated:YES];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row>2) {
        [self.tableView setFrame:CGRectMake(0, -64, SCREEN_W, SCREEN_H)];
    }else{
        [self.tableView setFrame:CGRectMake(0, -64, SCREEN_W, SCREEN_H+64)];
    }
}

/**
 *  自定义section headerView
 *
 *  @return 一个View
 */
-(UIView *)customAheaderView
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    sectionHeaderView.backgroundColor = WHITECOLOR;
    
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 13.5, 18)];
    leftImgView.image = [UIImage imageNamed:@"icon_remen"];
    [sectionHeaderView addSubview:leftImgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftImgView.right+5, 0, 100, 40)];
    label.text = @"热门兼职";
    label.font = FONT(18);
    label.textColor = RedColor;
    [sectionHeaderView addSubview:label];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(SCREEN_W-40, 5, 30, 30);
//    [refreshBtn setBackgroundColor:YELLOWCOLOR];
    [refreshBtn addTarget:self action:@selector(refreshHotJob:) forControlEvents:UIControlEventTouchUpInside];
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"icon_update"] forState:UIControlStateNormal];
    [sectionHeaderView addSubview:refreshBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, sectionHeaderView.frame.size.height-1, SCREEN_W, 1)];
    lineView.backgroundColor = BACKCOLORGRAY;
    [sectionHeaderView addSubview:lineView];
    
    
    return sectionHeaderView;
    
}
/**
 *  刷新热门兼职列表
 */
-(void)refreshHotJob:(id)object
{
    if (!object) {
        if (!self.isRequestedData) {
            [self requestList:@"1"];
        }
    }else{
        [self requestList:@"1"];
    }
}

#pragma mark  headerView 的代理方法
/**
 *  点击轮播图的触发事件
 *
 *  @param url 传过来的参数
 */
-(void)clickScollViewforUrl:(NSString *)url
{
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
    
}
/**
 *  点击四个 小view 的触发事件
 *
 *  @param str 传过来的参数
 */
-(void)clickOneOfFourBtns:(NSString *)str
{//兼职（0=普通，1=热门，2=精品，3=旅行）
    JobTypeViewController *jobVC = [[JobTypeViewController alloc] init];
    
    jobVC.hidesBottomBarWhenPushed = YES;
    
    if ([str intValue] == 1) {//精品兼职
        jobVC.title = @"精品兼职";
        jobVC.type = @"1";
        
    }else if (str.intValue == 2){//兼职旅行
        jobVC.title = @"兼职旅行";
        jobVC.type = @"3";
        
    }else if (str.intValue == 3){//日结兼职
        jobVC.title = @"日结兼职";
        jobVC.type = @"4";
        
    }else if ([str intValue]==4){//长期兼职
        jobVC.title = @"长期兼职";
        jobVC.type = @"2";
    }
    
    [self.navigationController pushViewController:jobVC animated:YES];
}
/**
 *  选择定位按钮
 */
-(void)selectLocation
{
    IMP_BLOCK_SELF(HomeViewController);
    SelectCityController *cityVC = [[SelectCityController alloc] init];
    cityVC.dataArr = JGKeyedUnarchiver(JGCityArr);
    cityVC.selectCityBlock = ^(CityModel *cityModel){//传回City 的 model
        [block_self.cityBtn setTitle:cityModel.cityName forState:UIControlStateNormal];
        [CityModel saveCity:cityModel];
        [NotificationCenter postNotificationName:kNotificationCity object:nil];
        [block_self requestList:@"1"];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
}
/**
 *  点击信息提醒按钮
 */
-(void)ClickMessage
{
    [btn_r clearBadge];

    self.msgRemindView.hidden = YES;
    RemindMsgViewController *notiNewsVC = [[RemindMsgViewController alloc] init];
    notiNewsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notiNewsVC animated:YES];
}
-(void)showANopartJobView
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_W, 250)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.center.x-60, 0, 120, 120)];
    imgView.image = [UIImage imageNamed:@"img_renwu1"];
    [bgView addSubview:imgView];
    
    UILabel *labelMiddle = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom+5, SCREEN_W, 25)];
    labelMiddle.text = @"还没有任何数据哦!";
    labelMiddle.font = FONT(16);
    labelMiddle.textColor = LIGHTGRAYTEXT;
    labelMiddle.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:labelMiddle];
    
    [self.tableView addSubview:bgView];
    bgView.hidden = YES;
}


/**
 *  去登录
 */
-(void)gotoCodeVC
{
    CodeLoginViewController *codeVC = [[CodeLoginViewController alloc]init];
    codeVC.hidesBottomBarWhenPushed = YES;
    codeVC.isFromJianZhiDetail = YES;
    [self.navigationController pushViewController:codeVC animated:YES];
}

-(void)fromNotiToMyjobVC:(NSDictionary *)userInfo
{
    int intType = [userInfo[@"type"] intValue];
    UIViewController *VC;
    switch (intType) {
        case 0:{//报名推送
            
            VC = [[MyPartJobViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        } case 1:{//钱包推送
            
            VC = [[MyWalletViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        } case 2:{//实名推送
            
            VC = [[RealNameViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        } case 3:{//主页推送,留在主页就行,不用额外操作
            
            
            
            break;
        } case 4:{//活动推送(H5)
            
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.url = userInfo[@"html_url"];
            
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        } case 5:{//推送一条兼职详情
            
            JianZhiDetailController *jzdetailVC = [[JianZhiDetailController alloc] init];
            
            jzdetailVC.hidesBottomBarWhenPushed = YES;
            
            jzdetailVC.jobId = userInfo[@"job_id"];
            
            [self.navigationController pushViewController:jzdetailVC animated:YES];
            break;
        }
    }
}
- (IBAction)clickAllJobs:(UIButton *)sender {
    
    [self.tabBarController setSelectedIndex:1];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:RGBACOLOR(0, 162, 255,self.tableView.contentOffset.y/100)] forBarMetrics:UIBarMetricsDefault];
    
}


-(UIImage *)imageWithBgColor:(UIColor *)color {//用颜色生成一个image对象
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

#pragma mark DOPDropDownMenuDataSource (三方筛选控件代理方法)
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{//有几列
    return 3;
}
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{//哪一列有几行
    if (column == 0) {
        return self.jobTypeArr.count;
    }else if (column == 1){
        return self.areaTypeArr.count;
    }else {
        return self.sortTypeArr.count;
    }
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{//设置哪一列的哪一行 的名字
    
    if (indexPath.column == 0) {
        PartTypeModel *model = self.jobTypeArr[indexPath.row];
        return model.name;
    } else if (indexPath.column == 1){
        AreaModel *model = self.areaTypeArr[indexPath.row];
        return model.areaName;
    } else {
        return [self.sortTypeArr[indexPath.row] objectForKey:@"name"];
    }
    
}
#pragma mark - DOPDropDownMenuDelegate
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{//选择第几行执行什么操作
    
    if (indexPath.column == 0) {
        
        PartTypeModel *model = self.jobTypeArr[indexPath.row];
        self.type = model.id;
        
    } else if (indexPath.column == 1){
        
        AreaModel *model = self.areaTypeArr[indexPath.row];
        self.areaId = model.id;
        
    } else {
        self.sequenceType = [self.sortTypeArr[indexPath.row] objectForKey:@"id"];
    }
    [self  requestList:@"1"];
    
}



-(void)dealloc
{
    [NotificationCenter removeObserver:self name:kNotificationGetCitySuccess object:nil];
    [NotificationCenter removeObserver:self name:kNotificationClickNotification object:nil];
    [NotificationCenter removeObserver:self name:kNotificationGetNewNotiNews object:nil];
}

@end
