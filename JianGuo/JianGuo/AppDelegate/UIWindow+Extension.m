//
//  UIWindow+Extension.m
//  黑马微博2期
//
//  Created by apple on 14-10-12.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "MyTabBarController.h"
#import "LoginViewController.h"
#import "LoginNewViewController.h"
#import "UserGuideViewController.h"
#import "JGUser.h"

@implementation UIWindow (Extension)
- (void)switchRootViewController
{
    
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
        
        JGUser *user = [JGUser user];
        if (!user.loginType) {//当没有登录过的时候才会显示登录页
            
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            self.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
            self.rootViewController = [[MyTabBarController alloc] init];
        }else{
            //登录过直接进入Tab页面
            self.rootViewController = [[MyTabBarController alloc] init];
        }
        
        
        
    } else { // 这次打开的版本和上一次不一样，显示新特性
        
        //.....
        
        UserGuideViewController *guideVC = [[UserGuideViewController alloc] init];
        self.rootViewController = guideVC;
        
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end

