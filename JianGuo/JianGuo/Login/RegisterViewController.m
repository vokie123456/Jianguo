//
//  RegisterViewController.m
//  JianGuo
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "WebViewController.h"
#import "TTTAttributedLabel.h"
#import "ProfileViewController.h"

#import "CodeValidateView.h"

#import "JGHTTPClient+LoginOrRegister.h"


#define SECONDCOUNT 60

@interface RegisterViewController()<UITextFieldDelegate,TTTAttributedLabelDelegate>
{
    int count;
    NSTimer *_timer;
}
@property (nonatomic,strong)IBOutlet UITextField *telTF;

@property (nonatomic,strong) IBOutlet UITextField *passTF;

@property (nonatomic,strong) IBOutlet UITextField *surePassTF;

@property (nonatomic,strong) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (nonatomic,copy) NSString *code;

@property (nonatomic,strong) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *agreementL;


@end

@implementation RegisterViewController



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"注册";
    count = SECONDCOUNT;
    
    self.telTF.leftViewMode = UITextFieldViewModeAlways;
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
    self.passTF.leftViewMode = UITextFieldViewModeAlways;
    self.surePassTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.telTF.leftView = [self createLeftViewWithImageName:@"account"];
    self.codeTF.leftView = [self createLeftViewWithImageName:@"verifycode"];
    self.passTF.leftView = [self createLeftViewWithImageName:@"lock"];
    self.surePassTF.leftView = [self createLeftViewWithImageName:@"lock"];
    
    
    [self.agreementL setText:@"注册账号视为同意《校园用户协议》" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
//        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, mutableAttributedString.length)];//这个设置方式不起作用
        
        [mutableAttributedString addAttributes:@{(id)kCTForegroundColorAttributeName:LIGHTGRAYTEXT} range:NSMakeRange(0, mutableAttributedString.length) ];//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
        
        return mutableAttributedString;
    }];
    UIFont *boldSystemFont = [UIFont systemFontOfSize:14];
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
    //添加点击事件
    self.agreementL.enabledTextCheckingTypes = NSTextCheckingTypeLink;

    self.agreementL.linkAttributes = @{(NSString *)kCTFontAttributeName:(__bridge id)font,(id)kCTForegroundColorAttributeName:GreenColor};//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
    CFRelease(font);
    NSRange range= [self.agreementL.text rangeOfString:@"校园用户协议"];
    
    NSURL* url = [NSURL URLWithString:@"http://101.200.205.243:8080/user_agreement.jsp"];
    [self.agreementL addLinkToURL:url withRange:range];
    

}

-(UIView *)createLeftViewWithImageName:(NSString *)name
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 45)];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(17, 13, 16, 18)];
    imgV.image = [UIImage imageNamed:name];
    [view addSubview:imgV];
    return view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (IBAction)sureRegist:(UIButton *)sender {
    
    if (![self.passTF.text isEqualToString:self.surePassTF.text]){
        [self showAlertViewWithText:@"两次密码不一致" duration:1];
        return;
    }else if (self.passTF.text.length<6){
        [self showAlertViewWithText:@"密码为 6~32 位" duration:1];
        return;
    }
    
    JGSVPROGRESSLOAD(@"注册中, 让信息飞一会儿！");
    
    [JGHTTPClient registerByPhoneNum:self.telTF.text passWord:self.passTF.text code:self.codeTF.text type:@"1" Success:^(id responseObject) {
        
        JGLog(@"%@",responseObject);
        //        [_timer invalidate];
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"]integerValue]==200) {
            
            [JGUser saveUser:[JGUser shareUser] WithDictionary:responseObject[@"data"] loginType:LoginTypeByPhone];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//填写基本资料
                ProfileViewController *profileVC = [[ProfileViewController alloc] init];
                [self.navigationController pushViewController:profileVC animated:YES];
            });
            
        }
        
        
    } failure:^(NSError *error) {
        
        [_timer invalidate];
        [SVProgressHUD dismiss];
        
    }];

    
}

- (IBAction)getCode:(UIButton *)sender {
    
    
    if (self.telTF.text.length!=11||![self checkTelNumber:self.telTF.text]) {
        [self showAlertViewWithText:@"请输入正确的手机号" duration:1];
        return;
    }
    
    CodeValidateView *view = [CodeValidateView aValidateViewCompleteBlock:^(NSString *code){
        
        [self.getCodeBtn setBackgroundColor:LIGHTGRAYTEXT];
        self.getCodeBtn.userInteractionEnabled = NO;
        _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeSeconds) userInfo:nil repeats:YES];
        
    } withTel:self.telTF.text type:@"3"];
    
    [view show];
    
}

-(void)getValidateCode:(NSString *)code
{
    [self.getCodeBtn setBackgroundColor:LIGHTGRAYTEXT];
    self.getCodeBtn.userInteractionEnabled = NO;
    _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeSeconds) userInfo:nil repeats:YES];
    
    JGSVPROGRESSLOAD(@"正在发送验证码");
    
    IMP_BLOCK_SELF(RegisterViewController);
    
    [JGHTTPClient getAMessageAboutCodeByphoneNum:self.telTF.text type:@"3" imageCode:code Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        JGLog(@"%@",responseObject[@"code"]);
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"]integerValue]==200) {
            
        }else{
            //                [_timer invalidate];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [block_self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

- (IBAction)unGetCode:(UIButton *)sender {
    
    
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    WebViewController *webVC = [[WebViewController alloc] init];
        webVC.title = @"用户协议";
        webVC.url = [NSString stringWithFormat:@"%@",url];
        [self.navigationController pushViewController:webVC animated:YES];
}

/**
 *  监听textEield的输入
 *
 *  @param textField 输入框
 */
-(IBAction)ensureRightInPut:(UITextField *)textField
{
    if(textField == self.telTF){
        if (self.telTF.text.length>11) {
            self.telTF.text = [self.telTF.text substringToIndex:11];
        }
    }else if (self.passTF.text.length>32){
        self.passTF.text = [self.passTF.text substringToIndex:32];
        [self showAlertViewWithText:@"密码为 6~32 位" duration:1];
    }else if (self.codeTF.text.length>6){
        self.codeTF.text = [self.codeTF.text substringToIndex:6];
        [self showAlertViewWithText:@"验证码为 6 位" duration:1];
    }
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



#pragma mark 下边是注释的旧版代码
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    self.view.backgroundColor = BACKCOLORGRAY;
//    
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    
//    CGFloat top = 5; // 顶端盖高度
//    CGFloat bottom = 5 ; // 底端盖高度
//    CGFloat left = 0; // 左端盖宽度
//    CGFloat right = 0; // 右端盖宽度
//    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
//    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"icon-navigationBar"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
//
//}
//
//
///**
// *  监听textEield的输入
// *
// *  @param textField 输入框
// */
//-(void)ensureRightInPut:(UITextField *)textField
//{
//    if(textField == self.phoneTf){
//        if (self.phoneTf.text.length>11) {
//            self.phoneTf.text = [self.phoneTf.text substringToIndex:11];
//        }
//    }else if (self.passTf.text.length>32){
//        self.passTf.text = [self.passTf.text substringToIndex:32];
//        [self showAlertViewWithText:@"密码为 6~32 位" duration:1];
//    }else if (self.codeTf.text.length>6){
//        self.codeTf.text = [self.codeTf.text substringToIndex:6];
//        [self showAlertViewWithText:@"验证码为 6 位" duration:1];
//    }
//}
//
////确认注册点击事件
//-(void)sureRegister:(UIButton *)sureRegBtn
//{
//    
//    if (![self.passTf.text isEqualToString:self.surePassTf.text]){
//        [self showAlertViewWithText:@"两次密码不一致" duration:1];
//        return;
//    }else if (self.passTf.text.length<6){
//        [self showAlertViewWithText:@"密码为 6~32 位" duration:1];
//        return;
//    }else if (!self.selectBtn.selected) {
//        [self showAlertViewWithText:@"请先阅读并确认《兼果用户协议》!" duration:1];
//        return;
//    }
//    [SVProgressHUD showWithStatus:@"注册中, 让信息飞一会儿！" maskType:SVProgressHUDMaskTypeNone];
//    
//    [JGHTTPClient registerByPhoneNum:self.phoneTf.text passWord:self.passTf.text code:self.codeTf.text type:@"1" Success:^(id responseObject) {
//        
//        JGLog(@"%@",responseObject);
////        [_timer invalidate];
//        [SVProgressHUD dismiss];
//        [self showAlertViewWithText:responseObject[@"message"] duration:1];
//        if ([responseObject[@"code"]integerValue]==200) {
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            });
//            
//        }
//        
//        
//    } failure:^(NSError *error) {
//        
//        [_timer invalidate];
//        [SVProgressHUD dismiss];
//        
//    }];
//}
//
///**
// *  自定义返回按钮
// */
//-(void)customBackBtn
//{
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 12, 21);
//    [backBtn addTarget:self action:@selector(popToLoginVC) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = item;
//}
//
///**
// *  返回上一级页面
// */
//-(void)popToLoginVC
//{
//    [_timer invalidate];
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
///**
// *  检查是否存在手机号，返回值为 1 时有该手机号不发验证码，为 0 时没有该手机号，发验证码
// */
//-(void)getCodeByPhoneNum:(UIButton *)getCodeBtn
//{
//    if (self.phoneTf.text.length!=11||![self checkTelNumber:self.phoneTf.text]) {
//        [self showAlertViewWithText:@"请输入正确的手机号" duration:1];
//        return;
//    }
//    
//    [self.getCodeBtn setBackgroundColor:LIGHTGRAYTEXT];
//    self.getCodeBtn.userInteractionEnabled = NO;
//    _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeSeconds) userInfo:nil repeats:YES];
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
//    
//    IMP_BLOCK_SELF(RegisterViewController);
//    
//    [JGHTTPClient getAMessageAboutCodeByphoneNum:self.phoneTf.text type:@"3" imageCode:nil Success:^(id responseObject) {
//        [SVProgressHUD dismiss];
//        JGLog(@"%@",responseObject[@"code"]);
//        [self showAlertViewWithText:responseObject[@"message"] duration:1];
//        if ([responseObject[@"code"]integerValue]==200) {
//            
//            }else{
////                [_timer invalidate];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [block_self.navigationController popViewControllerAnimated:YES];
//                });
//                
//            }
//        
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        
//        [self showAlertViewWithText:NETERROETEXT duration:1];
//    }];
//
//}
//
//-(void)changeSeconds
//{
//    count--;
//    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%d S",count] forState:UIControlStateNormal];
//    if (count == 0) {
//        [_timer invalidate];
//        count = SECONDCOUNT;
//        [self.getCodeBtn setTitle:@"验证" forState:UIControlStateNormal];
//        [self.getCodeBtn setBackgroundColor:YELLOWCOLOR];
//        self.getCodeBtn.userInteractionEnabled = YES;
//    }
//}
//
//
//-(void)configUI
//{
//    /**
//     父层View
//     */
//    UIView *backGoundView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, SCREEN_W, 170)];
//    backGoundView.backgroundColor = WHITECOLOR;
//    [self.view addSubview:backGoundView];
//    
//    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
//    phoneImg.image = [UIImage imageNamed:@"icon-photo"];
//    [backGoundView addSubview:phoneImg];
//    
//    UITextField *phoneTf = [[UITextField alloc] initWithFrame:CGRectMake(phoneImg.right, 5, SCREEN_W-40, 40)];
//    phoneTf.placeholder = @"请输入您的手机号";
//    phoneTf.delegate = self;
//    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
//    [phoneTf addTarget:self action:@selector(ensureRightInPut:) forControlEvents:UIControlEventEditingChanged];
//    phoneTf.font = [UIFont systemFontOfSize:14];
//    [backGoundView addSubview:phoneTf];
//    self.phoneTf = phoneTf;
//    
//    UIButton *getCodeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
//    getCodeBtn.layer.masksToBounds = YES;
//    getCodeBtn.layer.cornerRadius = 18;
//    getCodeBtn.frame = CGRectMake(phoneTf.right-100, 6, 90, 34);
//    [getCodeBtn setTitle:@"验证" forState:UIControlStateNormal];
//    [getCodeBtn addTarget:self action:@selector(getCodeByPhoneNum:) forControlEvents:UIControlEventTouchUpInside];
//    [getCodeBtn setBackgroundColor:YELLOWCOLOR];
//    [backGoundView addSubview:getCodeBtn];
//    self.getCodeBtn = getCodeBtn;
//    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(phoneImg.right/2, phoneImg.bottom+5, SCREEN_W-phoneImg.right/2, 1)];
//    lineView.backgroundColor = BACKCOLORGRAY;
//    [backGoundView addSubview:lineView];
//    
//    
//    UIImageView *codeImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, phoneImg.bottom+10, 30, 30)];
//    codeImg.image = [UIImage imageNamed:@"icon-password"];
//    [backGoundView addSubview:codeImg];
//    
//    UITextField *codeTf = [[UITextField alloc] initWithFrame:CGRectMake(codeImg.right, phoneTf.bottom, SCREEN_W-160, 40)];
//    codeTf.placeholder = @"请输入验证码";
//    codeTf.delegate = self;
//    codeTf.keyboardType = UIKeyboardTypeASCIICapable;
//    [codeTf addTarget:self action:@selector(ensureRightInPut:) forControlEvents:UIControlEventEditingChanged];
//    //    [passTf setTextColor:LIGHTGRAYTEXT];
//    codeTf.font = [UIFont systemFontOfSize:14];
//    [backGoundView addSubview:codeTf];
//    self.codeTf = codeTf;
//    
//    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(phoneImg.right/2, codeImg.bottom+5, SCREEN_W-phoneImg.right/2, 1)];
//    lineView2.backgroundColor = BACKCOLORGRAY;
//    [backGoundView addSubview:lineView2];
//    
//    UIImageView *passImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, codeImg.bottom+10, 30, 30)];
//    passImg.image = [UIImage imageNamed:@"icon-password"];
//    [backGoundView addSubview:passImg];
//    
//    UITextField *passTf = [[UITextField alloc] initWithFrame:CGRectMake(passImg.right, codeTf.bottom, SCREEN_W-160, 40)];
//    passTf.placeholder = @"请输入您的密码(6~32位)";
//    passTf.delegate = self;
//    passTf.secureTextEntry = YES;
//    passTf.keyboardType = UIKeyboardTypeASCIICapable;
//    [passTf addTarget:self action:@selector(ensureRightInPut:) forControlEvents:UIControlEventEditingChanged];
//    //    [passTf setTextColor:LIGHTGRAYTEXT];
//    passTf.font = [UIFont systemFontOfSize:14];
//    [backGoundView addSubview:passTf];
//    self.passTf = passTf;
//    
//    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(passImg.right/2, passImg.bottom+5, SCREEN_W-phoneImg.right/2, 1)];
//    lineView3.backgroundColor = BACKCOLORGRAY;
//    [backGoundView addSubview:lineView3];
//    
//    UIImageView *surePassImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, passImg.bottom+10, 30, 30)];
//    surePassImg.image = [UIImage imageNamed:@"icon-password2"];
//    [backGoundView addSubview:surePassImg];
//    
//    UITextField *surePassTf = [[UITextField alloc] initWithFrame:CGRectMake(passImg.right, passTf.bottom, SCREEN_W-160, 40)];
//    surePassTf.placeholder = @"请再次输入密码";
//    surePassTf.delegate = self;
//    surePassTf.secureTextEntry = YES;
//    surePassTf.keyboardType = UIKeyboardTypeASCIICapable;
//    [surePassTf addTarget:self action:@selector(ensureRightInPut:) forControlEvents:UIControlEventEditingChanged];
//    //    [passTf setTextColor:LIGHTGRAYTEXT];
//    surePassTf.font = [UIFont systemFontOfSize:14];
//    [backGoundView addSubview:surePassTf];
//    self.surePassTf = surePassTf;
//    
//    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(codeImg.left, backGoundView.bottom+11, 18, 18)];
//    imgView.userInteractionEnabled = YES;
//    imgView.image=[UIImage imageNamed:@"icon_xuanzhongda"];
//    [self.view addSubview:imgView];
//    self.selectView = imgView;
//    
//    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    agreementBtn.frame=CGRectMake(imgView.right, backGoundView.bottom+5, 150, 30);
//    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [agreementBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
//    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意兼果协议"];
//    [attributeStr addAttribute:NSForegroundColorAttributeName value:LIGHTGRAYTEXT range:NSMakeRange(0, 7)];
//    [attributeStr addAttributes:@{NSForegroundColorAttributeName:BLUECOLOR,NSFontAttributeName:FONT(15)} range:NSMakeRange(7, 4)];
//    [agreementBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
//    [agreementBtn addTarget:self action:@selector(lookAgreement) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:agreementBtn];
//    
//    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    selectBtn.selected = YES;
//    selectBtn.frame=CGRectMake(0, backGoundView.bottom, 60, 40);
//    [selectBtn addTarget:self action:@selector(selectAgreement:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:selectBtn];
//    self.selectBtn = selectBtn;
//    
//    //添加“确认注册”按钮
//    UIButton *sureRegBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    sureRegBtn.layer.masksToBounds = YES;
//    sureRegBtn.layer.cornerRadius = 20;
//    sureRegBtn.frame = CGRectMake(40, SCREEN_H==568?self.view.center.y:self.view.center.y-20, SCREEN_W-80, 40);
//    [sureRegBtn setBackgroundColor:YELLOWCOLOR];
//    [sureRegBtn addTarget:self action:@selector(sureRegister:) forControlEvents:UIControlEventTouchUpInside];
//    [sureRegBtn setTitle:@"确认注册" forState:UIControlStateNormal];
//    [self.view addSubview:sureRegBtn];
//}
//
//-(void)lookAgreement
//{
//    WebViewController *webVC = [[WebViewController alloc] init];
//    webVC.title = @"用户协议";
//    webVC.url = @"http://101.200.205.243:8080/user_agreement.jsp";
//    [self.navigationController pushViewController:webVC animated:YES];
//}
//-(void)selectAgreement:(UIButton *)btn
//{
//    btn.selected = !btn.selected;
//    if (btn.selected) {
//        self.selectView.image= [UIImage imageNamed:@"icon_xuanzhongda"];
//    }else{
//        self.selectView.image= [UIImage imageNamed:@"icon_weixuanzhongda"];
//    }
//}

@end
