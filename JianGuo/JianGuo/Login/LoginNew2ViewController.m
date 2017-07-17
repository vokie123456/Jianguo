//
//  LoginNew2ViewController.m
//  JianGuo
//
//  Created by apple on 16/12/27.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "LoginNew2ViewController.h"
#import "RegisterViewController.h"
#import "FindPassViewController.h"
#import <POP.h>
#import <IQKeyboardManager.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDKExtension/SSEBaseUser.h>
#import "JGHTTPClient+LoginOrRegister.h"
#import "BindingTelViewController.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"

#define LoginTypeCount 2
#define leftViewH 18
#define leftViewY 13
#define bottomViewH 80
#define LoginWX @"1"
#define LoginQQ @"2"
#define LoginWB @"3"

@interface LoginNew2ViewController ()<UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UITextField *telTF;
@property (weak, nonatomic) IBOutlet UITextField *passwTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginNew2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    #ifdef DEBUG
//    self.telTF.text = @"13614093590";
    self.passwTF.text = @"123456";
    #else
    
    #endif
    
    [NotificationCenter addObserver:self selector:@selector(changeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"picture"]];
    
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 45)];
    leftView1.backgroundColor = [UIColor clearColor];
    
    
    UIImageView *telLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(10, leftViewY, 16, leftViewH)];
    telLeftView.image = [UIImage imageNamed:@"my"];
    [leftView1 addSubview:telLeftView];
    
    UIView *vLine1 = [[UIView alloc] initWithFrame:CGRectMake(telLeftView.right+10, leftViewY, 1, leftViewH)];
    vLine1.backgroundColor = [UIColor lightGrayColor];
    [leftView1 addSubview:vLine1];
    
    self.telTF.leftViewMode=UITextFieldViewModeAlways;
    self.telTF.leftView = leftView1;
    
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 45)];
    leftView2.backgroundColor = [UIColor clearColor];
    
    
    UIImageView *pwLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(10, leftViewY, 16, leftViewH)];
    pwLeftView.image = [UIImage imageNamed:@"password"];
    [leftView2 addSubview:pwLeftView];
    
    UIView *vLine2 = [[UIView alloc] initWithFrame:CGRectMake(pwLeftView.right+10, leftViewY, 1, leftViewH)];
    vLine2.backgroundColor = [UIColor lightGrayColor];
    [leftView2 addSubview:vLine2];
    
    self.passwTF.leftViewMode=UITextFieldViewModeAlways;
    self.passwTF.leftView = leftView2;
    
    
    /* 第三方登录暂时隐藏起来
     
    SEL selectorQQ = NSSelectorFromString(@"loginByQQ");
    UIView *qqView = [self createThirdLoginBtnWithTitle:@"QQ" imageName:@"qq" selector:selectorQQ frame:CGRectMake(0, SCREEN_H-bottomViewH, SCREEN_W/LoginTypeCount, bottomViewH)];
    [self.view addSubview:qqView];
    
    SEL selectorWX = NSSelectorFromString(@"loginByWX");
    UIView *wxView = [self createThirdLoginBtnWithTitle:@"微信" imageName:@"wechat1" selector:selectorWX frame:CGRectMake(SCREEN_W/LoginTypeCount, SCREEN_H-bottomViewH, SCREEN_W/LoginTypeCount, bottomViewH)];
    [self.view addSubview:wxView];
    
    SEL selectorWB = NSSelectorFromString(@"loginByWB");
    UIView *wbView = [self createThirdLoginBtnWithTitle:@"微博" imageName:@"microblog" selector:selectorWB frame:CGRectMake(2*SCREEN_W/LoginTypeCount, SCREEN_H-bottomViewH, SCREEN_W/LoginTypeCount, bottomViewH)];
    [self.view addSubview:wbView];
     
     */
}

-(void)changeFrame:(NSNotification *)noti
{
    
}

-(UIView *)createThirdLoginBtnWithTitle:(NSString *)title imageName:(NSString *)imageName selector:(SEL)selector frame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = CGRectMake(0, 0, 40, 40);
    iconBtn.center = CGPointMake(frame.size.width/2, frame.size.height/2-10);
    [iconBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:iconBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, iconBtn.bottom+5, view.width, 20)];
    label.text = title;
    label.font = FONT(12);
    label.textColor = WHITECOLOR;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    return view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    POPSpringAnimation *scalAni = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];
    scalAni.fromValue = [NSValue valueWithCGSize:CGSizeMake(5, 5)];
    scalAni.toValue = [NSValue valueWithCGSize:CGSizeMake(70, 70)];
    scalAni.springBounciness = 20;
    scalAni.springSpeed = 15;
    [self.logoView pop_addAnimation:scalAni forKey:nil];
    [scalAni setCompletionBlock:^(POPAnimation *ani, BOOL finish) {
        if (finish) {
            [self.logoView pop_removeAllAnimations];
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//注册事件
- (IBAction)regist:(UIButton *)sender {
    RegisterViewController *registVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}
//忘记密码事件
- (IBAction)forgetPassword:(UIButton *)sender {
    
    FindPassViewController *findVC = [[FindPassViewController alloc] init];
    [self.navigationController pushViewController:findVC animated:YES];
    
}
//登录事件
- (IBAction)login:(UIButton *)sender {
    
    if (self.telTF.text.length!=11||![self checkTelNumber:self.telTF.text]) {
        [self showAlertViewWithText:@"请输入正确的手机号" duration:1];
        return;
    }
    if (self.passwTF.text.length<6) {
        [self showAlertViewWithText:@"密码为 6~32 位" duration:1];
        return;
    }
    
    JGSVPROGRESSLOADING
    
    IMP_BLOCK_SELF(LoginNew2ViewController);
    [JGHTTPClient loginByPhoneNum:self.telTF.text code:nil passwd:self.passwTF.text type:userType Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        JGLog(@"%@",responseObject);
        
        [block_self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"]integerValue] == 200) {
            [JGUser saveUser:[JGUser shareUser] WithDictionary:responseObject[@"data"] loginType:LoginTypeByPhone];
            [block_self showAlertViewWithText:@"登录成功" duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [block_self dismissViewControllerAnimated:YES completion:nil];
                [NotificationCenter postNotificationName:kNotificationLoginSuccessed object:nil];
            });
        }
    } failure:^(NSError *error) {
        
        JGFAILREQUESTCALLBACK
        
    }];
    
}

-(void)loginByQQ
{
    //QQ的登录
    JGSVPROGRESSLOADING
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             JGLog(@"iConUrl = %@",user.icon)
             
             [JGHTTPClient uploadUserInfoFromThirdWithUuid:user.uid loginType:LoginQQ Success:^(id responseObject) {
                 JGLog(@"%@",responseObject);
                 [SVProgressHUD dismiss];
                 
                 if ([responseObject[@"code"] integerValue]==201) {
                     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                     [dic setObject:[user.rawData[@"sex"] integerValue]==1?@"2":@"1" forKey:@"sex"];//微信返回的性别跟公司的性别规则不同
                     [dic setObject:user.uid forKey:@"uid"];
                     [dic setObject:user.nickname forKey:@"nickname"];
                     [dic setObject:user.url forKey:@"iconUrl"];
                     [dic setObject:LoginQQ forKey:@"type"];
                     [self jumpToBindingVC:dic];
                 }
                 
                 
             } failure:^(NSError *error) {
                 JGLog(@"%@",error)
             }];
             
         }
         
         else
         {
             [SVProgressHUD dismiss];
             [self showAlertViewWithText:@"QQ授权失败!" duration:1];
             NSLog(@"%@",error);
         }
         
     }];
}
-(void)loginByWX
{
    //weixn的登录
    JGSVPROGRESSLOADING
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             JGLog(@"iConUrl = %@",user.icon)
             
             [JGHTTPClient uploadUserInfoFromThirdWithUuid:user.rawData[@"unionid"] loginType:LoginWX Success:^(id responseObject) {
                 JGLog(@"%@",responseObject);
                 [SVProgressHUD dismiss];
                 
                 if ([responseObject[@"code"] integerValue]==201) {
                     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                     [dic setObject:[user.rawData[@"sex"] integerValue]==1?@"2":@"1" forKey:@"sex"];//微信返回的性别跟公司的性别规则不同
                     [dic setObject:user.rawData[@"unionid"] forKey:@"uid"];
                     [dic setObject:user.rawData[@"nickname"] forKey:@"nickname"];
                     [dic setObject:user.rawData[@"headimgurl"] forKey:@"iconUrl"];
                     [dic setObject:LoginWX forKey:@"type"];
                     [self jumpToBindingVC:dic];
                 }
                 
             } failure:^(NSError *error) {
                 JGLog(@"%@",error)
             }];
             
         }
         
         else
         {
             [SVProgressHUD dismiss];
             [self showAlertViewWithText:@"微信授权失败!" duration:1];
             NSLog(@"%@",error);
         }
         
     }];

}
-(void)loginByWB
{
    [self jumpToBindingVC:nil];
}
- (IBAction)dismiss:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)jumpToBindingVC:(NSDictionary *)dic
{
    BindingTelViewController *modalViewController = [BindingTelViewController new];
    modalViewController.transitioningDelegate = self;
    modalViewController.modalPresentationStyle = UIModalPresentationCustom;
    modalViewController.properDict = dic;
    [self.navigationController presentViewController:modalViewController
                                            animated:YES
                                          completion:NULL];
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

@end
