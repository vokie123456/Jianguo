//
//  AppDelegate.m
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//
#import "AppDelegate.h"
#import "RealNameModel.h"
#import "MobClick.h"
#import "JPUSHService.h"
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
#import "LoginNew2ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "QLAlertView.h"
#import "UpdateView.h"
#import "LCChatKit.h"
#import "ChatUser.h"
#import "LimitModel.h"
#import "LabelModel.h"
#import "WelfareModel.h"
#import "JGLCCKInputPickImage.h"
#import <BeeCloud.h>
#define SV_APP_EXTENSIONS

static NSString *BeeCloudAppID = @"3a9ecbbb-d431-4cd8-9af9-5e44ba504f9a";
static NSString *BeeCloudAppSecret = @"e202e675-e79e-45ed-af1b-113b53c46d5b";
static NSString *BeeCloudTESTAppSecret = @"9b144fec-e105-443e-87f0-54b6c70f1c56";
static NSString *BeeCloudMasterSecret = @"f5bd5b9b-62f4-4fdb-9a3b-4bba4caea88a";
static NSString *WX_appID = @"wx8c1fd6e2e9c4fd49";

@interface AppDelegate ()
@property (nonatomic,strong) AVIMConversation *conversation;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 上一次的使用版本（存储在沙盒中的版本号）
//    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"];
//    if ([@"3.0.10" compare:lastVersion options:NSNumericSearch] == NSOrderedDescending ) {
//        [JGUser deleteuser];
//    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:WHITECOLOR];
    
    
    [BeeCloud initWithAppID:BeeCloudAppID andAppSecret:BeeCloudAppSecret];
    //    [BeeCloud initWithAppID:@"c5d1cba1-5e3f-4ba0-941d-9b0a371fe719" andAppSecret:@"4bfdd244-574d-4bf3-b034-0c751ed34fee" sandbox:YES];
    
    //查看当前模式
    // 返回YES代表沙箱测试模式；NO代表生产模式
    [BeeCloud getCurrentMode];
    
    //初始化微信官方APP支付
    //此处的微信appid必须是在微信开放平台创建的移动应用的appid，且必须与在『BeeCloud控制台-》微信APP支付』配置的"应用APPID"一致，否则会出现『跳转到微信客户端后只显示一个确定按钮的现象』。
    [BeeCloud initWeChatPay:WX_appID];
    
    application.applicationIconBadgeNumber = 0;
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [USERDEFAULTS setObject:userInfo forKey:@"push"];
        [USERDEFAULTS synchronize];
        [NotificationCenter postNotificationName:kNotificationGetNewNotiNews object:nil];
    }
    
    [self checkVersionToUpdate];
    
    [MobClick startWithAppkey:@"5730641c67e58e8ef800123e" reportPolicy:BATCH channelId:nil];
 
    
    [AVOSCloud setApplicationId:@"AtwJtfIJPKQFtti8D3gNjMmb-gzGzoHsz" clientKey:@"spNrDrtGWAXP633DkMMWT65B"];
//    发布时改为YES
    [JPUSHService setupWithOption:launchOptions appKey:@"b7d6a9432f425319c952ffd3" channel:@"Publish channel" apsForProduction:YES];
    
    [NotificationCenter addObserver:self selector:@selector(login) name:kNotificationLoginSuccessed object:nil];
    
    [AVOSCloud registerForRemoteNotification];
    
   
   //从自己公司的服务器获取一些数据
    [self getData];
    
    //设置导航栏
    [self configNavigationBar];
    
    if (USER.login_id.integerValue) {
        //自动登录
        [self autoLoginWhenRestart];
        
//        TransitionViewController *rootVC = [[TransitionViewController alloc] init];
//        rootVC.image = [UIImage imageNamed:[self getLaunchImageName]];
//        self.window.rootViewController = rootVC;
//        
//        
//        return YES;
        
    }
    
    
    [self setShareSDKaboutThirdLogin:application];

    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = BACKCOLORGRAY;
    
    [self.window switchRootViewController];
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


#pragma mark 推送设置
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
    
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation setDeviceProfile:@"Dev_JGApp"];
    [currentInstallation saveInBackground];
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    JGLog(@"%@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    [JPUSHService setBadge:application.applicationIconBadgeNumber];
    
    [NotificationCenter postNotificationName:kNotificationGetNewNotiNews object:nil];
    
    if(application.applicationState==UIApplicationStateActive)
        
    {//前台运行时，收到推送的通知会弹出alertview提醒
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.repeatInterval=0;
        localNotification.userInfo = userInfo;
        localNotification.timeZone = [NSTimeZone localTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
        [application scheduleLocalNotification:localNotification];
        
        
    }
    
    else if (application.applicationState==UIApplicationStateInactive)
        
    {//点击推送通知进入界面的时候
        
        if (USER.tel.length==11) {
            
            
            NSArray *array = [[userInfo objectForKey:@"aps"] allKeys];
            if ([array containsObject:@"type"]||[[userInfo allKeys] containsObject:@"type"]) {
                UITabBarController *tabVc = (UITabBarController *)self.window.rootViewController;
                [tabVc setSelectedIndex:0];
                [NotificationCenter postNotificationName:kNotificationClickNotification object:userInfo];
            }else{
                
                UITabBarController *tabVc = (UITabBarController *)self.window.rootViewController;
                [tabVc setSelectedIndex:1];
                
            }
            
        }
        
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if(application.applicationState==UIApplicationStateActive)
        
    {//前台运行时，收到推送的通知会弹出alertview提醒
        
    }
    
    else if (application.applicationState==UIApplicationStateInactive)
        
    {//点击推送通知进入界面的时候
        
        if (USER.tel.length==11) {
            
            NSArray *array = [[notification.userInfo objectForKey:@"aps"] allKeys];
            if ([array containsObject:@"type"]||[[notification.userInfo allKeys] containsObject:@"type"]) {
                UITabBarController *tabVc = (UITabBarController *)self.window.rootViewController;
                [tabVc setSelectedIndex:0];
                [NotificationCenter postNotificationName:kNotificationClickNotification object:notification.userInfo];
            }else{
                UITabBarController *tabVc = (UITabBarController *)self.window.rootViewController;
                [tabVc setSelectedIndex:1];
                
            }
        }
    }

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    JGLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  
    [JPUSHService setBadge:0];
    
    NSInteger num=application.applicationIconBadgeNumber;
    if(num!=0){
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        [currentInstallation setBadge:0];
        [currentInstallation saveEventually];
        application.applicationIconBadgeNumber=0;

    }
    [application cancelAllLocalNotifications];
    
    [self checkVersionToUpdate];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if (application.applicationIconBadgeNumber>0) {  //badge number 不为0，说明程序有那个圈圈图标
        JGLog(@"我可能收到了推送");
        //这里进行有关处理
        
        [NotificationCenter postNotificationName:kNotificationGetNewNotiNews object:nil];
        
        [application setApplicationIconBadgeNumber:0];   //将图标清零。
    }
    
    application.applicationIconBadgeNumber = 0;
    
}

//收到登录成功的通知
-(void)login
{
    
    [LCChatKit setAppId:@"AtwJtfIJPKQFtti8D3gNjMmb-gzGzoHsz" appKey:@"spNrDrtGWAXP633DkMMWT65B"];   
    
    //设置别名
    [JPUSHService setTags:nil alias:[NSString stringWithFormat:@"jg%@",USER.login_id] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        JGLog(@"%@,%@",iTags,iAlias);
    }];
    
    //添加输入框底部插件，如需更换图标标题，可子类化，然后调用 `+registerSubclass`
    [LCCKInputViewPluginTakePhoto registerSubclass];
    [JGLCCKInputPickImage registerSubclass];
//    [LCCKInputViewPluginLocation registerSubclass];
   
    [[LCChatKit sharedInstance] setFetchProfilesBlock:^(NSArray<NSString *> *userIds, LCCKFetchProfilesCompletionHandler completionHandler) {
        
        if (userIds.count == 0) {
            NSInteger code = 0;
            NSString *errorReasonText = @"User ids is nil";
            NSDictionary *errorInfo = @{
                                        @"code":@(code),
                                        NSLocalizedDescriptionKey : errorReasonText,
                                        };
            NSError *error = [NSError errorWithDomain:@"LCChatKit"
                                                 code:code
                                             userInfo:errorInfo];
            !completionHandler ?: completionHandler(nil, error);
            return;
        }
        
        NSMutableArray *users = [NSMutableArray arrayWithCapacity:userIds.count];
//#warning 注意：以下方法循环模拟了通过 userIds 同步查询 user 信息的过程，这里需要替换为 App 的 API 同步查询
//        
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userIds options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userIds options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        JGLog(@"%@",userIds);
        
        [JGHTTPClient getGroupChatUserInfoByLoginId:jsonStr Success:^(id responseObject) {
            
            JGLog(@"%@",responseObject[@"data"]);
         
            if ([responseObject[@"code"]intValue] == 200) {
                
                NSArray *userArr = responseObject[@"data"];
                for (NSDictionary *userDic in userArr) {
                    NSURL *avatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[userDic objectForKey:@"avatarUrl"]]];
                    ChatUser *user_ = [ChatUser userWithUserId:[userDic objectForKey:@"userId"] name:[userDic objectForKey:@"name"] avatarURL:avatarURL clientId:[NSString stringWithFormat:@"%@",[userDic objectForKey:@"userId"]]];
                    [users addObject:user_];
                }
                !completionHandler ?: completionHandler([users copy], nil);
                if (users.count>1) {
                    NSString *title;
                    for (ChatUser *chatUser in users) {
                        if (![[LCChatKit sharedInstance].clientId isEqualToString:chatUser.userId]) {
                            title = chatUser.name;
                        }
                    }
                    [NotificationCenter postNotificationName:kNotificationGotChatUserInfon object:title];
                }
            }
            
        } failure:^(NSError *error) {
            JGLog(@"%@",error);
        }];
        
    }];

    [[LCChatKit sharedInstance] openWithClientId:[NSString stringWithFormat:@"%@",USER.login_id] callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            JGLog(@"client 打开成功!!!");
        }else{
            JGLog(@"client 打开失败!!!");
            JGLog(@"error == %@",error);
        }
    }];
    
    [[LCChatKit sharedInstance] setDidSelectConversationsListCellBlock:^(NSIndexPath *indexPath, AVIMConversation *conversation, LCCKConversationListViewController *controller) {
        NSLog(@"conversation selected");
        LCCKConversationViewController *conversationVC = [[LCCKConversationViewController alloc] initWithConversationId:conversation.conversationId];
        conversationVC.hidesBottomBarWhenPushed = YES;
        [controller.navigationController pushViewController:conversationVC animated:YES];
    }];
    
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

/**
 *  设置第三方登录
 */
-(void)setShareSDKaboutThirdLogin:(UIApplication *)application
{
    [ShareSDK registerApp:@"c60e1a484330"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSinaWeibo),
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
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
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
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
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
            
            [JGHTTPClient uploadUserInfoFromThirdWithUuid:user.token loginType:@"" Success:^(id responseObject) {
                
                JGLog(@"%@",responseObject);
                if ([responseObject[@"code"] integerValue] == 200) {
                    [JGUser saveUser:[JGUser shareUser] WithDictionary:responseObject loginType:LoginTypeByWeChat];
                }
                
            } failure:^(NSError *error) {
                JGLog(@"%@",error)
            }];
            
            break;
        case LoginTypeByQQ:
            
            [JGHTTPClient uploadUserInfoFromThirdWithUuid:user.token loginType:@"" Success:^(id responseObject) {
                
                JGLog(@"%@",responseObject);
                if ([responseObject[@"code"] integerValue] == 200) {
                    [JGUser saveUser:[JGUser shareUser] WithDictionary:responseObject[@"data"] loginType:LoginTypeByQQ];
                }
                
            } failure:^(NSError *error) {
                JGLog(@"%@",error)
            }];
            
            break;
            
        case LoginTypeByPhone:
            
            [JGHTTPClient loginAutoByPhoneNum:USER.tel token:USER.token Success:^(id responseObject) {
                
                JGLog(@"%@",responseObject);
                if ([responseObject[@"code"] integerValue] == 200) {
                    JGUser *user = [JGUser shareUser];
                    [JGUser saveUser:user WithDictionary:responseObject[@"data"] loginType:LoginTypeByPhone];
                    [self login];
                }else{
                    
                    
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
                    
                    MyTabBarController *tabVC = (MyTabBarController *)self.window.rootViewController;
                    UINavigationController *navVC = tabVC.childViewControllers.firstObject;

                    LoginNew2ViewController *loginVC = [[LoginNew2ViewController alloc] init];
                    loginVC.hidesBottomBarWhenPushed = YES;
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                    [navVC presentViewController:nav animated:YES completion:nil];
                }
                
            } failure:^(NSError *error) {
                JGLog(@"%@",error)
//                NSString *string = @"网络错误,请去检查您的网络设置";
//                NSTimeInterval time = MIN((float)string.length*0.06 + 0.5, 5.0);
//                [SVProgressHUD showErrorWithStatus:string];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginNewViewController alloc] init]];
//                });
                
                
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
                
                MyTabBarController *tabVC = (MyTabBarController *)self.window.rootViewController;
                UINavigationController *navVC = tabVC.childViewControllers.firstObject;
                LoginNew2ViewController *loginVC = [[LoginNew2ViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [navVC presentViewController:nav animated:YES completion:nil];
                
            }];
/*
            [JGHTTPClient loginByPhoneNum:user.tel passWord:user.passWord MD5:NO Success:^(id responseObject) {
                JGLog(@"%@",responseObject);
                if ([responseObject[@"code"] integerValue] == 200) {
                    JGUser *user = [JGUser shareUser];
                    [JGUser saveUser:user WithDictionary:responseObject loginType:LoginTypeByPhone];
                    [self login];
                    //升级更新
                    //TODO: 版本更新
                    NSString *version = [[responseObject objectForKey:@"data"] objectForKey:@"version_ios"];
                    NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];

                    if ([version compare:bundleVersion options:NSNumericSearch] == NSOrderedDescending) {//升级了
                            UpdateView *updateView = [UpdateView aUpdateViewCancelBlock:^{
                                
                            } sureBlock:^{
                                NSString * urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"1067634315"];
                                NSURL * url = [NSURL URLWithString:urlStr];
                                
                                if ([[UIApplication sharedApplication] canOpenURL:url])
                                {
                                    [[UIApplication sharedApplication] openURL:url];
                                }
                            }];
                            [updateView show];
                        }
                    }
                    
                
                
            } failure:^(NSError *error) {
                JGLog(@"%@",error)
            }];
*/            
            break;
            
    }
}
-(void)getData
{
    //获取城市地区 兼职种类
    [JGHTTPClient getAreaInfoByloginId:USER.login_id Success:^(id responseObject) {
        
        //保存兼职种类的数组
        [NSKeyedArchiver archiveRootObject:[PartTypeModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"type_list"]]  toFile:JGJobTypeArr];
        //保存城市的数组
        
        [NSKeyedArchiver archiveRootObject:[CityModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"city_list"]] toFile:JGCityArr];
        
        
        //保存限制条件数组
        [NSKeyedArchiver archiveRootObject:[LimitModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"limit_list"]] toFile:JGLimitArr];
        
        //保存福利条件数组
        [NSKeyedArchiver archiveRootObject:[WelfareModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"welfare_list"]] toFile:JGWelfareArr];
        
        //保存标签条件数组
        [NSKeyedArchiver archiveRootObject:[LabelModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"label_list"]] toFile:JGLabelArr];
        
        [NotificationCenter postNotificationName:kNotificationGetCitySuccess object:nil];
        //怕请求比较慢,所以在请求成功的时候如果热门页面获取失败
        //了可以再发送一次请求
        
    } failure:^(NSError *error) {
        
    }];
    
}
/**
 *  检查版本更新
 */
-(void)checkVersionToUpdate
{
    
    [JGHTTPClient checkVersionSuccess:^(id responseObject) {
        
        if (responseObject) {
            NSString *version = [responseObject[@"data"] objectForKey:@"ios_user_version"];
            NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            
            if ([version compare:bundleVersion options:NSNumericSearch] == NSOrderedDescending) {//升级了
                UpdateView *updateView = [UpdateView aUpdateViewCancelBlock:^{
                    
                } sureBlock:^{
                    
                    NSString * urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",@"1067634315"];//跳到appStore的详情区
                    NSURL * url = [NSURL URLWithString:urlStr];
                    
                    if ([[UIApplication sharedApplication] canOpenURL:url])
                    {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
                [updateView show];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//为保证从支付宝，微信返回本应用，须绑定openUrl. 用于iOS9之前版本
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
    }
    return YES;
}
//iOS9之后apple官方建议使用此方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
    }
    return YES;
}

@end
