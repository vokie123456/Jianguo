//
//  LoginNewViewController.m
//  JianGuo
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "LoginNewViewController.h"
#import "JGHTTPClient+LoginOrRegister.h"
#import "FindPassViewController.h"
#import "RegisterViewController.h"
#import "WebViewController.h"
//#import "IQKeyboardManager.h"

#define SECONDCOUNT 60

@interface LoginNewViewController ()
{
    int count;
    NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *quicklyLoginBtn;
@property (weak, nonatomic)  UIImageView *selectView;
@property (weak, nonatomic)  UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *pwBtn;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *chechBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UILabel *alertL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetRightCon;

@end

@implementation LoginNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [IQKeyboardManager sharedManager].enable = YES;
    
    self.title = @"登录";
    count = SECONDCOUNT;

    UIButton *registerBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:registerBtn];

    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.alertL.bottom+11, 18, 18)];
    imgView.userInteractionEnabled = YES;
    imgView.image=[UIImage imageNamed:@"icon_xuanzhongda"];
    [self.bgView addSubview:imgView];
    self.selectView = imgView;
    
    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementBtn.frame=CGRectMake(imgView.right, self.alertL.bottom+5, 150, 30);
    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [agreementBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意兼果协议"];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:LIGHTGRAYTEXT range:NSMakeRange(0, 7)];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:BLUECOLOR,NSFontAttributeName:FONT(15)} range:NSMakeRange(7, 4)];
    [agreementBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    [agreementBtn addTarget:self action:@selector(lookAgreement) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:agreementBtn];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.selected = YES;
    selectBtn.frame=CGRectMake(0, self.alertL.bottom, 60, 40);
    [selectBtn addTarget:self action:@selector(selectAgreement:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    if (SCREEN_W == 320) {
        self.rightConstant.constant = 15;
        self.forgetRightCon.constant = 10;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
-(void)lookAgreement
{
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.title = @"用户协议";
    webVC.url = @"http://101.200.205.243:8080/user_agreement.jsp";
    [self.navigationController pushViewController:webVC animated:YES];
}
-(void)selectAgreement:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.selectView.image= [UIImage imageNamed:@"icon_xuanzhongda"];
    }else{
        self.selectView.image= [UIImage imageNamed:@"icon_weixuanzhongda"];
    }
}


- (IBAction)quickLogin:(UIButton *)sender {
    
    [sender setBackgroundColor:WHITECOLOR];
    [self.pwBtn setBackgroundColor:BACKCOLORGRAY];
    self.codeTF.placeholder = @"请输入您的验证码";
    self.alertL.text = @"    未注册过的手机号将会创建兼果账号";
    self.forgetBtn.hidden = YES;
    self.chechBtn.hidden = NO;
    [self.codeTF setText:nil];
    [self.phoneTF setText:nil];
    
}
- (IBAction)passwordLogin:(UIButton *)sender {
    
    [sender setBackgroundColor:WHITECOLOR];
    [self.quicklyLoginBtn setBackgroundColor:BACKCOLORGRAY];
    self.codeTF.placeholder = @"请输入您的密码";
    self.alertL.text = @"    没有密码的老用户可点击\"忘记密码\"来设置密码!";
    self.forgetBtn.hidden = NO;
    self.chechBtn.hidden = YES;
    [self.codeTF setText:nil];
    [self.phoneTF setText:nil];
    
}
- (IBAction)getCode:(UIButton *)sender {
    
    if (self.phoneTF.text.length!=11||![self checkTelNumber:self.phoneTF.text]) {
        [self showAlertViewWithText:@"请输入正确的手机号!" duration:1];
        return;
    }
    
    [self.view endEditing:YES];
    
    [SVProgressHUD showWithStatus:@"让验证码飞一会儿" maskType:SVProgressHUDMaskTypeNone];
    [self.chechBtn setBackgroundColor:RGBACOLOR(200, 200, 200, 1)];
    self.chechBtn.userInteractionEnabled = NO;
    _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeSeconds) userInfo:nil repeats:YES];
    
    [JGHTTPClient getAMessageAboutCodeByphoneNum:self.phoneTF.text type:@"1" imageCode:nil Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        JGLog(@"%@",responseObject[@"code"]);
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [self showAlertViewWithText:@"验证码已成功发送!" duration:1];
            
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
}
- (IBAction)textChanged:(UITextField *)sender {
    
    if (self.phoneTF.text.length>11) {
        self.phoneTF.text = [self.phoneTF.text substringToIndex:11];
    }
    
    if (!self.chechBtn.hidden) {
        if (self.codeTF.text.length>6) {
            self.codeTF.text = [self.codeTF.text substringToIndex:6];
        }
    }
    
}

/**
 *  忘记密码
 */
- (IBAction)forgetBtn:(UIButton *)sender {
    
    FindPassViewController *findVC = [[FindPassViewController alloc] init];
    [self.navigationController pushViewController:findVC animated:YES];
    
}

//点击注册按钮
-(void)gotoRegister
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)login:(UIButton *)sender {
    
    if(!self.chechBtn.hidden){
        
        [self loginByCode];
        
    }else{
        
        [self loginByPassWord];
        
    }
    
}

/**
 *  密码登录
 */
-(void)loginByPassWord
{
    if (self.phoneTF.text.length!=11||![self checkTelNumber:self.phoneTF.text]) {
        [self showAlertViewWithText:@"请输入正确的手机号" duration:1];
        return;
    }
    if (self.codeTF.text.length<6) {
        [self showAlertViewWithText:@"密码为 6~32 位" duration:1];
        return;
    }
    
    JGSVPROGRESSLOADING
    
    IMP_BLOCK_SELF(LoginNewViewController);
    [JGHTTPClient loginByPhoneNum:self.phoneTF.text code:nil passwd:self.codeTF.text type:userType Success:^(id responseObject) {
                                  [SVProgressHUD dismiss];
                                  
                                  JGLog(@"%@",responseObject);
        
        [block_self showAlertViewWithText:responseObject[@"message"] duration:1];
                                  if ([responseObject[@"code"]integerValue] == 200) {
                                      [JGUser saveUser:[JGUser shareUser] WithDictionary:responseObject[@"data"] loginType:LoginTypeByPhone];
                                      [block_self showAlertViewWithText:@"登录成功" duration:1];
                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                          [block_self.navigationController popViewControllerAnimated:YES];
                                          [NotificationCenter postNotificationName:kNotificationLoginSuccessed object:nil];
                                      });
                                  }
                              } failure:^(NSError *error) {
                                  
                                  JGFAILREQUESTCALLBACK
                                  
                              }];
}

/**
 *  验证码登录
 */
-(void)loginByCode
{
    if ([[self.phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] !=11 ||![self checkTelNumber:self.phoneTF.text]){
        [self showAlertViewWithText:@"请输入正确的手机号!" duration:1];
        return;
    }else if (self.codeTF.text.length == 0){
        [self showAlertViewWithText:@"请输入验证码!" duration:1];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeNone];
    
    IMP_BLOCK_SELF(LoginNewViewController);
    
    [JGHTTPClient loginByPhoneNum:self.phoneTF.text code:self.codeTF.text passwd:nil type:userType Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        JGLog(@"%@",responseObject);
        [block_self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"] integerValue] == 200) {
            [JGUser saveUser:[JGUser shareUser] WithDictionary:responseObject[@"data"] loginType:LoginTypeByPhone];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.isFromSettingVC) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [block_self.navigationController popViewControllerAnimated:YES];
                }
                [NotificationCenter postNotificationName:kNotificationLoginSuccessed object:nil];
            });
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
    
}

-(void)changeSeconds
{
    count--;
    [self.chechBtn setTitle:[NSString stringWithFormat:@"%d S",count] forState:UIControlStateNormal];
    if (count == 0) {
        [_timer invalidate];
        count = SECONDCOUNT;
        [self.chechBtn setTitle:@"验证" forState:UIControlStateNormal];
        [self.chechBtn setBackgroundColor:YELLOWCOLOR];
        self.chechBtn.userInteractionEnabled = YES;
    }
}



@end
