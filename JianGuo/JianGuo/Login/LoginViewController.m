//
//  LoginViewController.m
//  JianGuo
//
//  Created by apple on 16/3/2.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "LoginViewController.h"
#import "CoreLaunchCool.h"
#import "JGUser.h"
#import "MyTabBarController.h"
#import "CodeLoginViewController.h"
#import "FindPassViewController.h"
#import "JGHTTPClient+LoginOrRegister.h"
#import "RegisterViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDKExtension/SSEBaseUser.h>



@interface LoginViewController()<UITextFieldDelegate>

@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UITextField *phoneTf;
@property (nonatomic,strong) UITextField *passTf;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title = @"登录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.backScrollView.backgroundColor = RGBCOLOR(241, 241, 241);
    self.backScrollView.scrollEnabled = NO;
    self.backScrollView.bounces = YES;
    [self.view addSubview:self.backScrollView];

    
    [self configUI];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

//-(void)loginToAppByWX
//{
//    //weixn的登录
//    JGSVPROGRESSLOADING
//    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
//           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
//     {
//         if (state == SSDKResponseStateSuccess)
//         {
//
//             NSLog(@"uid=%@",user.uid);
//             NSLog(@"%@",user.credential);
//             NSLog(@"token=%@",user.credential.token);
//             NSLog(@"nickname=%@",user.nickname);
//             JGLog(@"iConUrl = %@",user.icon)
//             
//             [JGHTTPClient uploadUserInfoFromQQorWeChatToken:user.credential.token nickName:user.nickname iconUrl:user.icon sex:[NSString stringWithFormat:@"%ld",user.gender] Success:^(id responseObject) {
//                 JGLog(@"%@",responseObject);
//                 [SVProgressHUD dismiss];
//                 [JGUser saveUser:[JGUser shareUser] WithDictionary:responseObject[@"data"] loginType:LoginTypeByWeChat];
//                 APPLICATION.keyWindow.rootViewController = [[MyTabBarController alloc] init];
//                 
//             } failure:^(NSError *error) {
//                 JGLog(@"%@",error)
//             }];
//             
//         }
//         
//         else
//         {
//             NSLog(@"%@",error);
//         }
//         
//     }];
//}

//-(void)loginToAppByQQ
//{
//    //例如QQ的登录
//    JGSVPROGRESSLOADING
//    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
//           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
//     {
//         if (state == SSDKResponseStateSuccess)
//         {
//             NSLog(@"uid=%@",user.uid);
//             NSLog(@"%@",user.credential);
//             NSLog(@"token=%@",user.credential.token);
//             NSLog(@"nickname=%@",user.nickname);
//             JGLog(@"%@",user.icon);
//             
//             [JGHTTPClient uploadUserInfoFromQQorWeChatToken:user.credential.token nickName:user.nickname iconUrl:user.icon sex:[NSString stringWithFormat:@"%ld",user.gender] Success:^(id responseObject) {
//                 JGLog(@"%@",responseObject);
//                 [SVProgressHUD dismiss];
//                 [JGUser saveUser:[JGUser shareUser] WithDictionary:responseObject[@"data"] loginType:LoginTypeByQQ];
//                 APPLICATION.keyWindow.rootViewController = [[MyTabBarController alloc] init];
//                 
//             } failure:^(NSError *error) {
//                 JGLog(@"%@",error)
//             }];
//
//         }
//         
//         else
//         {
//             NSLog(@"%@",error);
//         }
//         
//     }];
//
//}
#pragma mark 注册点击事件
-(void)gotoRegisterVC:(UIButton *)registerBtn
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.phoneNumBlock = ^(NSString *phoneNum){
        self.phoneTf.text = phoneNum;
    };
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark 登录点击事件
-(void)loginByTelNum:(UIButton *)loginBtn
{
    if (self.phoneTf.text.length!=11||![self checkTelNumber:self.phoneTf.text]) {
        [self showAlertViewWithText:@"请输入正确的手机号" duration:1];
        return;
    }
    if (self.passTf.text.length<6) {
        [self showAlertViewWithText:@"密码为 6~32 位" duration:1];
        return;
    }
    
    JGSVPROGRESSLOADING
    
    IMP_BLOCK_SELF(LoginViewController)
    [JGHTTPClient loginByPhoneNum:self.phoneTf.text passWord:self.passTf.text
                              MD5:YES Success:^(id responseObject) {
        [SVProgressHUD dismiss];

        JGLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            [block_self showAlertViewWithText:@"登录成功" duration:1];
            
            [JGUser saveUser:[JGUser shareUser] WithDictionary:responseObject loginType:LoginTypeByPhone];

#warning 到这里已经把用户信息存到本地了
            
            APPLICATION.keyWindow.rootViewController = [[MyTabBarController alloc] init];
        }else{
            [block_self showAlertViewWithText:@"账户或密码错误" duration:1];
        }
        
    } failure:^(NSError *error) {
        
        JGFAILREQUESTCALLBACK
        
    }];
}
#pragma mark 使用手机验证码登录
-(void)loginByPhoneNumAndCode:(UIButton *)codeBtn
{
    CodeLoginViewController *codeVC = [[CodeLoginViewController alloc] init];
    [self.navigationController pushViewController:codeVC animated:YES];
}
#pragma mark 使用密码登录
-(void)forgetPassWord:(UIButton *)forgetBtn
{
    FindPassViewController *findVC = [[FindPassViewController alloc] init];
    [self.navigationController pushViewController:findVC animated:YES];
}
#pragma mark textField 代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark 监听 textFIeld 输入
-(void)ensureRightInPut:(UITextField *)textField
{
    if(textField == self.phoneTf){
        if (self.phoneTf.text.length>11) {
            self.phoneTf.text = [self.phoneTf.text substringToIndex:11];
        }
    }else{//密码
        
    }
}



/**
 *  布局UI
 */
-(void)configUI
{
    JGLog(@"%f",SCREEN_H/568);
    //头部ImageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 1)];
    imageView.image = [UIImage imageNamed:@"bg-chahua"];
    [self.backScrollView addSubview:imageView];
    
    //手机号和密码输入
    UIView *phoneAndPassView = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.bottom, SCREEN_W, 90)];
    
    phoneAndPassView.backgroundColor = WHITECOLOR;
    
    [self.backScrollView addSubview:phoneAndPassView];
    
    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    phoneImg.image = [UIImage imageNamed:@"icon-photo"];
    [phoneAndPassView addSubview:phoneImg];
    
    UITextField *phoneTf = [[UITextField alloc] initWithFrame:CGRectMake(phoneImg.right, 5, SCREEN_W-40, 40)];
    phoneTf.placeholder = @"请输入您的手机号";
    phoneTf.delegate = self;
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    [phoneTf addTarget:self action:@selector(ensureRightInPut:) forControlEvents:UIControlEventEditingChanged];
    phoneTf.font = [UIFont systemFontOfSize:14];
    [phoneAndPassView addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(phoneImg.right/2, phoneImg.bottom+5, SCREEN_W-phoneImg.right/2, 1)];
    lineView.backgroundColor = BACKCOLORGRAY;
    [phoneAndPassView addSubview:lineView];
    
    
    UIImageView *passImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, phoneImg.bottom+10, 30, 30)];
    passImg.image = [UIImage imageNamed:@"icon-password"];
    [phoneAndPassView addSubview:passImg];
    
    UITextField *passTf = [[UITextField alloc] initWithFrame:CGRectMake(passImg.right, phoneTf.bottom, SCREEN_W-160, 40)];
    passTf.placeholder = @"密码";
    passTf.delegate = self;
    passTf.returnKeyType = UIReturnKeyDone;
    passTf.secureTextEntry = YES;
    passTf.keyboardType = UIKeyboardTypeDefault;
    [passTf addTarget:self action:@selector(ensureRightInPut:) forControlEvents:UIControlEventEditingChanged];
//    [passTf setTextColor:LIGHTGRAYTEXT];
    passTf.font = [UIFont systemFontOfSize:14];
    [phoneAndPassView addSubview:passTf];
    self.passTf = passTf;
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(passTf.right, phoneTf.bottom+5, 120, 30);
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
//    [forgetBtn setTintColor:LIGHTGRAYTEXT];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetBtn addTarget:self action:@selector(forgetPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [phoneAndPassView addSubview:forgetBtn];
    
    
    //使用”手机验证码登录“的按钮
    UIButton *btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCode setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    btnCode.frame = CGRectMake(SCREEN_W-120, phoneAndPassView.bottom, 120, 50);
    [btnCode setTitle:@"使用手机验证码登录" forState:UIControlStateNormal];
    [btnCode addTarget:self action:@selector(loginByPhoneNumAndCode:) forControlEvents:UIControlEventTouchUpInside];
    btnCode.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:btnCode];
    
    //登录&注册按钮
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 20;
    [loginBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake(30, btnCode.bottom, SCREEN_W-60, 40);
    [loginBtn addTarget:self action:@selector(loginByTelNum:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:YELLOWCOLOR];
    [self.backScrollView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.layer.masksToBounds = YES;
    [registerBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    registerBtn.layer.cornerRadius = 20;
    registerBtn.frame = CGRectMake(30, loginBtn.bottom+10, SCREEN_W-60, 40);
    [registerBtn addTarget:self action:@selector(gotoRegisterVC:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:RGBCOLOR(192, 192, 192)];
    [self.backScrollView addSubview:registerBtn];
    
    
    //第三方登录
    UIView *thirdloginView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-120, SCREEN_W, 120)];
    thirdloginView.backgroundColor = BACKCOLORGRAY;
    [self.backScrollView addSubview:thirdloginView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_W, 30)];
    label.text = @"使用其它账号登录";
    label.textColor = LIGHTGRAYTEXT;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [thirdloginView addSubview:label];
    
    
    
    UIButton *wxbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wxbtn.frame = CGRectMake(thirdloginView.center.x-45, label.bottom, 35, 35);
    [wxbtn setBackgroundImage:[UIImage imageNamed:@"icon-weixin"] forState:UIControlStateNormal];
    [wxbtn addTarget:self action:@selector(loginToAppByWX) forControlEvents:UIControlEventTouchUpInside];
    [thirdloginView addSubview:wxbtn];
    
    UIButton *qqbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqbtn setBackgroundImage:[UIImage imageNamed:@"icon-qq"] forState:UIControlStateNormal];
    qqbtn.frame = CGRectMake(thirdloginView.center.x+10, label.bottom, 35, 35);
    [qqbtn addTarget:self action:@selector(loginToAppByQQ) forControlEvents:UIControlEventTouchUpInside];
    [thirdloginView addSubview:qqbtn];
    
    
}


@end
