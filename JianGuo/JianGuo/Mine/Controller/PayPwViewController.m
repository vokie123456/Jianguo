//
//  PayPwViewController.m
//  JianGuo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "PayPwViewController.h"
#import "JGHTTPClient+LoginOrRegister.h"
#import "JGHTTPClient+Mine.h"
#define SECONDCOUNT 60

@interface PayPwViewController ()<UITextFieldDelegate>
{
    int count;
    NSTimer *_timer;
}
@property (nonatomic,strong) UITextField *phoneTf;

@property (nonatomic,strong) UITextField *passTf;

@property (nonatomic,strong) UITextField *surePassTf;

@property (nonatomic,strong) UITextField *codeTf;

@property (nonatomic,strong) UIButton *getCodeBtn;

@end

@implementation PayPwViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置钱包密码";
    count = SECONDCOUNT;
    [self customBackBtn];
    [self configUI];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = BACKCOLORGRAY;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5 ; // 底端盖高度
    CGFloat left = 0; // 左端盖宽度
    CGFloat right = 0; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"icon-navigationBar"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    
}
/**
 *  监听textEield的输入
 *
 *  @param textField 输入框
 */
-(void)ensureRightInPut:(UITextField *)textField
{
    if(textField == self.phoneTf){
        if (self.phoneTf.text.length>11) {
            self.phoneTf.text = [self.phoneTf.text substringToIndex:11];
        }
    }else if (self.codeTf.text.length>6){
        self.codeTf.text = [self.codeTf.text substringToIndex:6];
        [self showAlertViewWithText:@"验证码为 6 位" duration:1];
    }else if (self.passTf.text.length>6){
        self.codeTf.text = [self.codeTf.text substringToIndex:6];
        [self showAlertViewWithText:@"密码为 6 位" duration:1];
    }else if (self.surePassTf.text.length>6){
        self.codeTf.text = [self.codeTf.text substringToIndex:6];
        [self showAlertViewWithText:@"密码为 6 位" duration:1];
    }
}

/**
 *  提交
 *
 *  @param sureRegBtn 确认提交
 */
-(void)commitInfo:(UIButton *)commitBtn
{
    if ([USERDEFAULTS objectForKey:@"text"] != self.codeTf.text) {
        [self showAlertViewWithText:@"验证码错误" duration:1];
        return;
    }else if (![self.passTf.text isEqualToString:self.surePassTf.text]){
        [self showAlertViewWithText:@"两次密码不一致" duration:1];
        return;
    }else if (self.passTf.text.length!=6){
        [self showAlertViewWithText:@"密码为 6 位" duration:1];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在提交...." maskType:SVProgressHUDMaskTypeNone];
    IMP_BLOCK_SELF(PayPwViewController);
    
    [JGHTTPClient alertPayPasswordByloginId:USER.login_id password:self.passTf.text Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [block_self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
}

/**
 *  自定义返回按钮
 */
-(void)customBackBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 12, 21);
    [backBtn addTarget:self action:@selector(popToLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
}

/**
 *  返回上一级页面
 */
-(void)popToLoginVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  获取验证码
 */
-(void)getCodeByPhoneNum:(UIButton *)getCodeBtn
{
    if (self.phoneTf.text.length!=11||![self checkTelNumber:self.phoneTf.text]) {
        [self showAlertViewWithText:@"请输入正确的手机号" duration:1];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"让验证码飞一会儿" maskType:SVProgressHUDMaskTypeNone];
    [self.getCodeBtn setBackgroundColor:LIGHTGRAYTEXT];
    
    self.getCodeBtn.userInteractionEnabled = NO;
    _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeSeconds) userInfo:nil repeats:YES];
    
    IMP_BLOCK_SELF(PayPwViewController);
    
    
    [JGHTTPClient getAMessageAboutCodeByphoneNum:self.phoneTf.text type:@"" Success:^(id responseObject) {
        
        JGLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        if ([responseObject[@"is_tel"] isEqualToString:@"1"]) {
            [USERDEFAULTS setObject:responseObject[@"text"] forKey:@"text"];
            [USERDEFAULTS synchronize];
            
        }
        
    } failure:^(NSError *error) {
        JGLog(@"%@",error);
        [SVProgressHUD dismiss];
        [block_self showAlertViewWithText:NETERROETEXT duration:1];
        
    }];

    
}

-(void)changeSeconds
{
    count--;
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%d S",count] forState:UIControlStateNormal];
    if (count == 0) {
        [_timer invalidate];
        count = SECONDCOUNT;
        [self.getCodeBtn setTitle:@"验证" forState:UIControlStateNormal];
        [self.getCodeBtn setBackgroundColor:YELLOWCOLOR];
        self.getCodeBtn.userInteractionEnabled = YES;
    }
}

-(void)configUI
{
    /**
     父层View
     */
    UIView *backGoundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 170)];
    backGoundView.backgroundColor = WHITECOLOR;
    [self.view addSubview:backGoundView];
    
    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    phoneImg.image = [UIImage imageNamed:@"icon-photo"];
    [backGoundView addSubview:phoneImg];
    
    UITextField *phoneTf = [[UITextField alloc] initWithFrame:CGRectMake(phoneImg.right, 5, SCREEN_W-40, 40)];
    phoneTf.placeholder = @"请输入您的手机号";
    phoneTf.delegate = self;
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    [phoneTf addTarget:self action:@selector(ensureRightInPut:) forControlEvents:UIControlEventEditingChanged];
    phoneTf.font = [UIFont systemFontOfSize:14];
    [backGoundView addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    UIButton *getCodeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    getCodeBtn.layer.masksToBounds = YES;
    getCodeBtn.layer.cornerRadius = 18;
    getCodeBtn.frame = CGRectMake(phoneTf.right-100, 6, 90, 34);
    [getCodeBtn setTitle:@"验证" forState:UIControlStateNormal];
    [getCodeBtn addTarget:self action:@selector(getCodeByPhoneNum:) forControlEvents:UIControlEventTouchUpInside];
    [getCodeBtn setBackgroundColor:YELLOWCOLOR];
    [backGoundView addSubview:getCodeBtn];
    self.getCodeBtn = getCodeBtn;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(phoneImg.right/2, phoneImg.bottom+5, SCREEN_W-phoneImg.right/2, 1)];
    lineView.backgroundColor = BACKCOLORGRAY;
    [backGoundView addSubview:lineView];
    
    
    UIImageView *codeImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, phoneImg.bottom+10, 30, 30)];
    codeImg.image = [UIImage imageNamed:@"icon-password"];
    [backGoundView addSubview:codeImg];
    
    UITextField *codeTf = [[UITextField alloc] initWithFrame:CGRectMake(codeImg.right, phoneTf.bottom, SCREEN_W-160, 40)];
    codeTf.placeholder = @"请输入验证码";
    codeTf.delegate = self;
    codeTf.keyboardType = UIKeyboardTypeNumberPad;
    [codeTf addTarget:self action:@selector(ensureRightInPut:) forControlEvents:UIControlEventEditingChanged];
    //    [passTf setTextColor:LIGHTGRAYTEXT];
    codeTf.font = [UIFont systemFontOfSize:14];
    [backGoundView addSubview:codeTf];
    self.codeTf = codeTf;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(phoneImg.right/2, codeImg.bottom+5, SCREEN_W-phoneImg.right/2, 1)];
    lineView2.backgroundColor = BACKCOLORGRAY;
    [backGoundView addSubview:lineView2];
    
    UIImageView *passImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, codeImg.bottom+10, 30, 30)];
    passImg.image = [UIImage imageNamed:@"icon-password"];
    [backGoundView addSubview:passImg];
    
    UITextField *passTf = [[UITextField alloc] initWithFrame:CGRectMake(passImg.right, codeTf.bottom, SCREEN_W-160, 40)];
    passTf.placeholder = @"请输入您的密码(6位)";
    passTf.delegate = self;
    passTf.secureTextEntry = YES;
    passTf.keyboardType = UIKeyboardTypeNumberPad;
    [passTf addTarget:self action:@selector(ensureRightInPut:) forControlEvents:UIControlEventEditingChanged];
    //    [passTf setTextColor:LIGHTGRAYTEXT];
    passTf.font = [UIFont systemFontOfSize:14];
    [backGoundView addSubview:passTf];
    self.passTf = passTf;
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(passImg.right/2, passImg.bottom+5, SCREEN_W-phoneImg.right/2, 1)];
    lineView3.backgroundColor = BACKCOLORGRAY;
    [backGoundView addSubview:lineView3];
    
    UIImageView *surePassImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, passImg.bottom+10, 30, 30)];
    surePassImg.image = [UIImage imageNamed:@"icon-password2"];
    [backGoundView addSubview:surePassImg];
    
    UITextField *surePassTf = [[UITextField alloc] initWithFrame:CGRectMake(passImg.right, passTf.bottom, SCREEN_W-160, 40)];
    surePassTf.placeholder = @"请再次输入密码";
    surePassTf.delegate = self;
    surePassTf.secureTextEntry = YES;
    surePassTf.keyboardType = UIKeyboardTypeNumberPad;
    [surePassTf addTarget:self action:@selector(ensureRightInPut:) forControlEvents:UIControlEventEditingChanged];
    //    [passTf setTextColor:LIGHTGRAYTEXT];
    surePassTf.font = [UIFont systemFontOfSize:14];
    [backGoundView addSubview:surePassTf];
    self.surePassTf = surePassTf;
    
    //添加“确认注册”按钮
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 20;
    commitBtn.frame = CGRectMake(40, SCREEN_H==568?self.view.center.y:self.view.center.y-20, SCREEN_W-80, 40);
    [commitBtn setBackgroundColor:YELLOWCOLOR];
    [commitBtn addTarget:self action:@selector(commitInfo:) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setTitle:@"确认设置" forState:UIControlStateNormal];
    [self.view addSubview:commitBtn];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end

