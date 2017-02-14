//
//  MyTabBarController.m
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MyTabBarController.h"
#import "MineViewController.h"
#import "MineNewViewController.h"
#import "HomeViewController.h"
#import "HomeNewViewController.h"
#import "PartJobViewController.h"
#import "MessageListViewController.h"
#import "ChatMsgViewController.h"
#import "LCChatKit.h"
#import <POP.h>

@interface MyTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    [self setChildController];
    
}
//测试一下分支
-(void)testBranch
{
    JGLog(@"testBranch");
}

-(void)setChildController
{
    HomeNewViewController *homeVC = [[HomeNewViewController alloc] init];
    homeVC.title = @"首页";
    
    homeVC.view.frame = CGRectMake(0, -64, SCREEN_W, SCREEN_H);
    //设置图标
//    homeVC.tabBarItem.badgeValue = @"2";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"zh_sy"];
    //选中图标样式  修改渲染模式
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"xz_sy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:homeVC];
    navHome.tabBarItem.title = @"首页";
    
    
    PartJobViewController *partjobVC = [[PartJobViewController alloc] init];
    partjobVC.title = @"兼职";
    //设置图标
    partjobVC.tabBarItem.image = [UIImage imageNamed:@"zh_jz"];
    //选中图标样式  修改渲染模式
    partjobVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"xz_jz"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navPartjob = [[UINavigationController alloc] initWithRootViewController:partjobVC];
    navPartjob.tabBarItem.title = @"兼职";
    
    
    LCCKConversationListViewController *chatVC = [[LCCKConversationListViewController alloc] init];
//    MessageListViewController*chatVC = [[MessageListViewController alloc] initWithNibName:nil bundle:nil];

    chatVC.title = @"果聊";
    //设置图标
    chatVC.tabBarItem.image = [UIImage imageNamed:@"zh_lt"];
    //选中图标样式  修改渲染模式
    chatVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"xz_lt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navChat = [[UINavigationController alloc] initWithRootViewController:chatVC];
    navChat.tabBarItem.title = @"果聊";
    
    
//    MineNewViewController *mineVC = [[MineNewViewController alloc] init];
    MineViewController *mineVC = [[MineViewController alloc] init];
    mineVC.title = @"我的";
    //设置图标
    mineVC.tabBarItem.image = [UIImage imageNamed:@"zh_wd"];
    //选中图标样式  修改渲染模式
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"xz_wd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navMine = [[UINavigationController alloc] initWithRootViewController:mineVC];
    navMine.tabBarItem.title = @"我的";
    
    
    [self addChildViewController:navHome];
//    [self addChildViewController:navPartjob];
    [self addChildViewController:navChat];
    [self addChildViewController:navMine];
    
//    self.tabBar.tintColor = [UIColor greenColor];
    self.tabBar.tintColor = RGBCOLOR(113, 170, 58); // 设置tabbar上的字体颜色
    
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



@end
