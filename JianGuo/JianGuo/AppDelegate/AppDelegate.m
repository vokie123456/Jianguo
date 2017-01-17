//
//  AppDelegate.m
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "AppDelegate.h"
#import "PartTypeModel.h"
#import "CityModel.h"
#import "AreaModel.h"
#import "JGHTTPClient.h"
#import "JGHTTPClient+Mine.h"
#import "JGUser.h"
#import "JGHTTPClient+LoginOrRegister.h"
#import "UIWindow+Extension.h"
#import "MyTabBarController.h"
#import "BaseViewController.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#define SV_APP_EXTENSIONS

@interface AppDelegate ()
@property (nonatomic,strong) AVIMConversation *conversation;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [AVOSCloud setApplicationId:@"AtwJtfIJPKQFtti8D3gNjMmb-gzGzoHsz"
                      clientKey:@"spNrDrtGWAXP633DkMMWT65B"];
    
    
    //获取七牛token
    [JGHTTPClient getQNtokenSuccess:^(id responseObject) {
        JGLog(@"%@",responseObject);
        if ([responseObject[@"message"] isEqualToString:@"200"]) {
            [USERDEFAULTS setObject:responseObject[@"token"] forKey:@"QNtoken"];
        }
    } failure:^(NSError *error) {
        JGLog(@"%@",error);
    }];
    
    //获取城市地区 兼职种类
    [JGHTTPClient getAreaInfoByloginId:USER.login_id Success:^(id responseObject) {

        //保存兼职种类的数组
        [NSKeyedArchiver archiveRootObject:[PartTypeModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"list_t_type"]]  toFile:JGJobTypeArr];
        //保存城市的数组
        [NSKeyedArchiver archiveRootObject:[CityModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"list_t_city2"]] toFile:JGCityArr];
           NSArray *arr = JGKeyedUnarchiver(JGCityArr);

        for (CityModel *model in arr) {
            JGLog(@"%@",model.list_t_area);
            NSArray *a = model.list_t_area;
            AreaModel *m = [a objectAtIndex:0];
            JGLog(@"%@",m.area_name);
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    //设置导航栏
    [self configNavigationBar];
    
    JGUser *user = [JGUser user];
    if (user.loginType) {
        //自动登录
        [self autoLoginWhenRestart];
    }
    
    
    [self setShareSDKaboutThirdLogin:application];

    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = BLUECOLOR;
    
    [self.window switchRootViewController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
/**
 *  设置第三方登录
 */
-(void)setShareSDKaboutThirdLogin:(UIApplication *)application
{
    [ShareSDK registerApp:@"c60e1a484330"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                        @(SSDKPlatformSubTypeWechatTimeline)]
                 onImport:^(SSDKPlatformType platformType)
     {//打开相应App
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {//打开网页web进行授权
         
         switch (platformType)
         {
                 
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx8c1fd6e2e9c4fd49"
                                       appSecret:@"d4624c36b6795d1d99dcf0547af5443d"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1104770733"
                                      appKey:@"atF0KUmGmaBzm1o6"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
}
/**
 *  自动登录
 */
-(void)autoLoginWhenRestart
{
    JGUser *user = [JGUser user];
    
    switch (user.loginType) {
        case LoginTypeByWeChat:
            
            [JGHTTPClient uploadUserInfoFromQQorWeChatToken:user.qqwx_token nickName:nil iconUrl:nil sex:nil Success:^(id responseObject) {
                
                JGLog(@"%@",responseObject);
                if ([responseObject[@"code"] integerValue] == 200) {
                    [JGUser saveUser:[JGUser shareUser] WithDictionary:responseObject loginType:LoginTypeByWeChat];
                }
                
            } failure:^(NSError *error) {
               JGLog(@"%@",error)
            }];
            
            break;
        case LoginTypeByQQ:
            
            [JGHTTPClient uploadUserInfoFromQQorWeChatToken:user.qqwx_token nickName:nil iconUrl:nil sex:nil Success:^(id responseObject) {
                
                JGLog(@"%@",responseObject);
                if ([responseObject[@"code"] integerValue] == 200) {
                    [JGUser saveUser:[JGUser shareUser] WithDictionary:responseObject loginType:LoginTypeByQQ];
                }
                
            } failure:^(NSError *error) {
                JGLog(@"%@",error)
            }];
            
            break;
            
        case LoginTypeByPhone:
            
            NSLog(@"%@  ***************  %@",user.phoneNum,user.passWord);
            [JGHTTPClient loginByPhoneNum:user.phoneNum passWord:user.passWord MD5:NO Success:^(id responseObject) {
                JGLog(@"%@",responseObject);
                if ([responseObject[@"code"] integerValue] == 200) {
                    JGUser *user = [JGUser shareUser];
                    [JGUser saveUser:user WithDictionary:responseObject loginType:LoginTypeByPhone];
                }
                
            } failure:^(NSError *error) {
                JGLog(@"%@",error)
            }];
            
            break;
            
        default:
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)configNavigationBar
{
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5 ; // 底端盖高度
    CGFloat left = 0; // 左端盖宽度
    CGFloat right = 0; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"icon-navigationBar"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITECOLOR}];

}

@end
