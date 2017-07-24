//
//  MyTabBarController.m
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MyTabBarController.h"

#import "MineNewViewController.h"
#import "HomeViewController.h"
#import "DemandListViewController.h"
#import "DiscoveryViewController.h"
#import "PartJobViewController.h"
#import "DemandDetailNewViewController.h"

#import "NewsScrollViewController.h"

#import "RemindMsgViewController.h"
#import "MyWalletNewViewController.h"
#import "RealNameNewViewController.h"
#import "SignDemandViewController.h"

#import "MyPostDetailViewController.h"
#import "BillsViewController.h"
#import "MySignDetailViewController.h"

#import "JianZhiDetailController.h"
#import "MyPartJobViewController.h"
#import "WebViewController.h"
#import "MineChatViewController.h"

#import <AMapLocationKit/AMapLocationKit.h>

#import "LCChatKit.h"
#import <POP.h>
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"

@interface MyTabBarController ()<UITabBarControllerDelegate,AMapLocationManagerDelegate>

@property (nonatomic,strong) AMapLocationManager *manager;

@end

@implementation MyTabBarController


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
        
//        [NotificationCenter addObserver:self selector:@selector(clickNotification:) name:kNotificationClickNotification object:nil];

    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self setChildController];
    
    [self location];
    
}


//定位
-(void)location
{
    [self.manager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (regeocode) {
            
            [USERDEFAULTS setObject:regeocode.citycode forKey:CityCode];
            
            NSString *cityName = regeocode.city?regeocode.city:regeocode.province;
            
            [USERDEFAULTS setObject:cityName forKey:CityName];
            
            
        }else{
            if ([[USERDEFAULTS objectForKey:CityCode] integerValue]==0) {
                [self location];//定位失败重新定位
            }
        }
        
    }];
}

//测试一下分支
-(void)testBranch
{
    JGLog(@"testBranch");
}

-(void)setChildController
{
    
    DemandListViewController *homeVC = [[DemandListViewController alloc] init];
//    HomeNewViewController *homeVC = [[HomeNewViewController alloc] init];
//    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.title = @"首页";
    
//    homeVC.view.frame = CGRectMake(0, -64, SCREEN_W, SCREEN_H);
    //设置图标
//    homeVC.tabBarItem.badgeValue = @"2";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"zh_sy"];
    //选中图标样式  修改渲染模式
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"xz_sy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:homeVC];
    navHome.tabBarItem.title = @"首页";
    
    
    HomeViewController *partjobVC = [[HomeViewController alloc] init];
    partjobVC.title = @"兼职";
    //设置图标
    partjobVC.tabBarItem.image = [UIImage imageNamed:@"part-times"];
    //选中图标样式  修改渲染模式
    partjobVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"parttime"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navPartjob = [[UINavigationController alloc] initWithRootViewController:partjobVC];
    navPartjob.tabBarItem.title = @"兼职";
    
    
    DiscoveryViewController *discoveryVC = [[DiscoveryViewController alloc] init];
    discoveryVC.title = @"发现新鲜";
    //设置图标
    discoveryVC.tabBarItem.image = [UIImage imageNamed:@"find"];
    //选中图标样式  修改渲染模式
    discoveryVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"finds"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navDiscovery = [[UINavigationController alloc] initWithRootViewController:discoveryVC];
    navDiscovery.tabBarItem.title = @"发现";
    
//    LCCKConversationListViewController *chatVC = [[LCCKConversationListViewController alloc] init];
//    //    MessageListViewController*chatVC = [[MessageListViewController alloc] initWithNibName:nil bundle:nil];
//    
//    chatVC.title = @"果聊";
//    //设置图标
//    chatVC.tabBarItem.image = [UIImage imageNamed:@"zh_lt"];
//    //选中图标样式  修改渲染模式
//    chatVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"xz_lt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UINavigationController *navChat = [[UINavigationController alloc] initWithRootViewController:chatVC];
//    navChat.tabBarItem.title = @"果聊";

    
    NewsScrollViewController *chatVC = [[NewsScrollViewController alloc] init];
//    MessageListViewController*chatVC = [[MessageListViewController alloc] initWithNibName:nil bundle:nil];

    chatVC.title = @"果聊";
    //设置图标
    chatVC.tabBarItem.image = [UIImage imageNamed:@"zh_lt"];
    //选中图标样式  修改渲染模式
    chatVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"xz_lt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navChat = [[UINavigationController alloc] initWithRootViewController:chatVC];
    navChat.tabBarItem.title = @"果聊";
    
    
    MineNewViewController *mineVC = [[MineNewViewController alloc] init];
//    MineViewController *mineVC = [[MineViewController alloc] init];
    mineVC.title = @"我的";
    //设置图标
    mineVC.tabBarItem.image = [UIImage imageNamed:@"zh_wd"];
    //选中图标样式  修改渲染模式
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"xz_wd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navMine = [[UINavigationController alloc] initWithRootViewController:mineVC];
    navMine.tabBarItem.title = @"我的";
    
    
    [self addChildViewController:navHome];
    [self addChildViewController:navPartjob];
    [self addChildViewController:navDiscovery];
    [self addChildViewController:navChat];
    [self addChildViewController:navMine];
    
//    self.tabBar.tintColor = [UIColor greenColor];
    self.tabBar.tintColor = RGBCOLOR(113, 170, 58); // 设置tabbar上的字体颜色
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self setSelectedIndex:3];
//    [self setSelectedIndex:0];
    
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    if (viewController == [tabBarController.childViewControllers objectAtIndex:1]) {
//        
        APPLICATION.keyWindow.backgroundColor = WHITECOLOR;
//
//    }else{
//        
//        APPLICATION.keyWindow.backgroundColor = BLUECOLOR;
//
//    }
    
    
    
    NSInteger index = [tabBarController.childViewControllers indexOfObject:viewController];
    UIView *tabBarBtn = tabBarController.tabBar.subviews[index+1];

    UIImageView *imageV = tabBarBtn.subviews.firstObject;
    
    
//    POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    ani.toValue = [NSValue valueWithCGSize:CGSizeMake(1.2, 1.2)];
//    ani.velocity = [NSValue valueWithCGSize:CGSizeMake(10.f, 10.f)];
//    ani.springBounciness = 8;
//    [imageV.layer pop_addAnimation:ani forKey:@"scale"];
//    [ani setCompletionBlock:^(POPAnimation *ani, BOOL isFinish) {
//        [imageV pop_removeAllAnimations];
//    }];
    
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    shakeAnimation.duration = 0.15f;
    shakeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    shakeAnimation.toValue = [NSNumber numberWithFloat:1.5];
    shakeAnimation.autoreverses = YES;
    [imageV.layer addAnimation:shakeAnimation forKey:nil];
    
    return YES;
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}


-(void)dealloc
{
    [NotificationCenter removeObserver:self name:kNotificationClickNotification object:nil];
}

@end
