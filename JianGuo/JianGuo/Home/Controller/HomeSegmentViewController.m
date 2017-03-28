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



#define SegmentWidth 160

@interface HomeSegmentViewController ()<UIScrollViewDelegate,AMapLocationManagerDelegate>
{
    HomeViewController *homeVC;
    DemandListViewController *demandListVC;
    BOOL isHandScroll;
}

@property (nonatomic,strong) AMapLocationManager *manager;
@property (nonatomic,strong) UIButton *cityBtn;
@property (nonatomic,strong) UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (nonatomic,copy) NSString *schoolName;

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

- (void)viewDidLoad {
    [super viewDidLoad];

    [self location];//定位
    self.schoolName = USER.school_name;
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
            [self.cityBtn setTitle:school.name forState:UIControlStateNormal];
        }else if (city){
            [CityModel saveCity:city];
        }
        [homeVC requestList:@"1"];
        [demandListVC requestWithCount:@"1"];
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
        [demandListVC requestWithCount:@"0"];
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
                [self.cityBtn setTitle:(self.schoolName?self.schoolName:[CityModel city].cityName) forState:UIControlStateNormal];
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
