//
//  CodeLoginViewController.m
//  JianGuo
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "CodeLoginViewController.h"
#import "JGHTTPClient+LoginOrRegister.h"
#import "JGHTTPClient+Mine.h"
#import "MyTabBarController.h"
#import "WebViewController.h"

#define SECONDCOUNT 60

@interface CodeLoginViewController()<UITextFieldDelegate>
{
    int count;
    NSTimer *_timer;
}
@property (nonatomic,strong) UITextField *codeTf;

@property (nonatomic,strong) UITextField *phoneTf;

@property (nonatomic,strong) UIButton *loginBtn;

@property (nonatomic,strong) UIButton *getCodeBtn;

@property (nonatomic,strong) UIImageView *selectView;

@property (nonatomic,strong) UIButton *selectBtn;
@end

@implementation CodeLoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    if (self.isFromRealName) {
        self.title = @"绑定手机";
    }else if (self.isChangePhoneNum){
        self.title = @"更换手机号";
    }else{
        self.title = @"验证码登录";
    }
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
    if (self.phoneTf.text.length>11) {
        self.phoneTf.text = [self.phoneTf.text substringToIndex:11];
    }
    if (self.codeTf.text.length>6) {
        self.codeTf.text = [self.codeTf.text substringToIndex:6];
    }
}

/**
 *  获取验证码
 */
-(void)getCodeByPhoneNum:(UIButton *)getCodeBtn
{
    if (self.phoneTf.text.length!=11||![self checkTelNumber:self.phoneTf.text]) {
        [self showAlertViewWithText:@"请输入正确的手机号!" duration:1];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"让验证码飞一会儿" maskType:SVProgressHUDMaskTypeNone];
    
    
    if (self.isChangePhoneNum) {
        [JGHTTPClient checkIsHadThePhoneNum:self.phoneTf.text Success:^(id responseObject) {
            
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
             
                if ([responseObject[@"is_tel"] intValue] == 1) {
                    [self showAlertViewWithText:@"该手机号已注册,不能绑定改手机号!" duration:1];
                }else{
                    [self showAlertViewWithText:@"验证码已成功发送!" duration:1];
                    [self.getCodeBtn setBackgroundColor:RGBACOLOR(200, 200, 200, 1)];
                    self.getCodeBtn.userInteractionEnabled = NO;
                    _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeSeconds) userInfo:nil repeats:YES];
                }
                
            }
            
        } failure:^(NSError *error) {
            JGLog(@"%@",error);
            [SVProgressHUD dismiss];
            
            [self showAlertViewWithText:NETERROETEXT duration:1];
        }];
    }else
    [JGHTTPClient getCodeByPhoneNum:self.phoneTf.text Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] isEqualToString:@"200"]) {

            [self showAlertViewWithText:@"验证码已成功发送!" duration:1];
            
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

//登录点击事件
-(void)loginByTelNum:(UIButton *)loginBtn
{
    if ([[self.phoneTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] !=11 ||![self checkTelNumber:self.phoneTf.text]){
        [self showAlertViewWithText:@"请输入正确的手机号!" duration:1];
        return;
    }else if (self.codeTf.text.length == 0){
        [self showAlertViewWithText:@"请输入验证码!" duration:1];
        return;
    }else if (!self.selectBtn.selected) {
        [self showAlertViewWithText:@"请先阅读并确认《兼果用户协议》!" duration:1];
        return;
    }

    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeNone];
    
    IMP_BLOCK_SELF(CodeLoginViewController)
    
//    [JGHTTPClient loginByPhoneNumQuickly:self.phoneTf.text code:self.codeTf.text Success:^(id responseObject) {
//        [SVProgressHUD dismiss];
//        
//        JGLog(@"%@",responseObject);
//        if ([responseObject[@"code"] isEqualToString:@"200"]) {
//            [JGUser saveUser:[JGUser shareUser] WithDictionary:responseObject loginType:LoginTypeByPhone];
//            [block_self showAlertViewWithText:@"登录成功" duration:1];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [block_self.navigationController popViewControllerAnimated:YES];
//                [NotificationCenter postNotificationName:kNotificationLoginSuccessed object:nil];
//            });
////            [USERDEFAULTS removeObjectForKey:@"text"];
//        }else{
//            [block_self showAlertViewWithText:responseObject[@"message"] duration:1];
//        }
//        
//        
//        
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        [self showAlertViewWithText:NETERROETEXT duration:1];
//    }];
}
/**
 *  确认更换手机号
 */
-(void)changePhoneNum:(UIButton *)btn
{
    if ([[self.phoneTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] !=11 ||![self checkTelNumber:self.phoneTf.text]){
        [self showAlertViewWithText:@"请输入正确的手机号!" duration:1];
        return;
    }else if (self.codeTf.text.length == 0){
        [self showAlertViewWithText:@"请输入验证码!" duration:1];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在请求..." maskType:SVProgressHUDMaskTypeNone];
    [JGHTTPClient changePhoneNumByLoginId:USER.login_id phoneNum:self.phoneTf.text smsCode:self.codeTf.text Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"] intValue] == 200) {
            JGUser *user = [JGUser user];
            user.tel = self.phoneTf.text;
            [JGUser saveUser:user WithDictionary:nil loginType:LoginTypeByPhone];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self .navigationController popToRootViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
        
    }];
}

/**
 *  验证手机号点击事件
 */
-(void)binding:(UIButton *)btn
{
    
    if (![[USERDEFAULTS objectForKey:@"text"] isEqualToString:self.codeTf.text]) {
        [self showAlertViewWithText:@"验证码不正确！" duration:1];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在验证..." maskType:SVProgressHUDMaskTypeNone];
    IMP_BLOCK_SELF(CodeLoginViewController)
    [JGHTTPClient bindingYourPhoneNumByPhoneNum:self.phoneTf.text loginId:[JGUser user].login_id Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        JGLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            [USERDEFAULTS removeObjectForKey:@"text"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [block_self.navigationController popViewControllerAnimated:YES];
            });
            
            JGUser *user = [JGUser user];
            user.tel = self.phoneTf.text;
            [JGUser saveUser:user WithDictionary:nil loginType:0];
        }else{
        }
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];    }];
}

-(void)configUI
{
    UIView *backGoundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.isFromJianZhiDetail?0:64, SCREEN_W, 90)];
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
    [getCodeBtn setBackgroundColor:GreenColor];
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

    
    
    if (!self.isChangePhoneNum) {
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(codeImg.left, backGoundView.bottom+11, 18, 18)];
        imgView.userInteractionEnabled = YES;
        imgView.image=[UIImage imageNamed:@"icon_xuanzhongda"];
        [self.view addSubview:imgView];
        self.selectView = imgView;
        
        UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        agreementBtn.frame=CGRectMake(imgView.right, backGoundView.bottom+5, 150, 30);
        agreementBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [agreementBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意兼果协议"];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:LIGHTGRAYTEXT range:NSMakeRange(0, 7)];
        [attributeStr addAttributes:@{NSForegroundColorAttributeName:GreenColor,NSFontAttributeName:FONT(15)} range:NSMakeRange(7, 4)];
        [agreementBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
        [agreementBtn addTarget:self action:@selector(lookAgreement) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:agreementBtn];
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.selected = YES;
        selectBtn.frame=CGRectMake(0, backGoundView.bottom, 60, 40);
        [selectBtn addTarget:self action:@selector(selectAgreement:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectBtn];
        self.selectBtn = selectBtn;
    }
    
    //登录
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 20;
    [loginBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake(40, backGoundView.bottom+40, SCREEN_W-80, 40);
    if(self.isFromRealName){
        [loginBtn addTarget:self action:@selector(binding:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn setTitle:@"验证手机" forState:UIControlStateNormal];
    }else if (self.isChangePhoneNum){
        [loginBtn addTarget:self action:@selector(changePhoneNum:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn setTitle:@"确认" forState:UIControlStateNormal];
    }else{
        [loginBtn addTarget:self action:@selector(loginByTelNum:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
    [loginBtn setBackgroundColor:GreenColor];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
}

/**
 *  自定义返回按钮
 */
-(void)customBackBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.showsTouchWhenHighlighted = YES;
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
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)changeSeconds
{
    count--;
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%d S",count] forState:UIControlStateNormal];
    if (count == 0) {
        [_timer invalidate];
        count = SECONDCOUNT;
        [self.getCodeBtn setTitle:@"验证" forState:UIControlStateNormal];
        [self.getCodeBtn setBackgroundColor:GreenColor];
        self.getCodeBtn.userInteractionEnabled = YES;
    }
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTf) {
        return [self validateNumber:string];
    }else{
        return YES;
    }
    
}

/**
 *  限制输入手机号
 */
- (BOOL)validateNumber:(NSString*)number{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


@end
