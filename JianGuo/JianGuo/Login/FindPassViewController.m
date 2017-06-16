//
//  FindPassViewController.m
//  JianGuo
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "FindPassViewController.h"
#import "MyTabBarController.h"


#import "JGHTTPClient+LoginOrRegister.h"
#import "TTTAttributedLabel.h"

#import "CodeValidateView.h"
#define SECONDCOUNT 60

@interface FindPassViewController()<UITextFieldDelegate>
{
    int count;
    NSTimer *_timer;
}
@property (nonatomic,strong)IBOutlet UITextField *telTF;

@property (nonatomic,strong) IBOutlet UITextField *passTF;

@property (nonatomic,strong) IBOutlet UITextField *surePassTF;

@property (nonatomic,strong) IBOutlet UITextField *codeTF;

@property (nonatomic,copy) NSString *code;

@property (nonatomic,strong) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *agreementL;

@end

@implementation FindPassViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"密码找回";
    count = SECONDCOUNT;
    
    self.telTF.leftViewMode = UITextFieldViewModeAlways;
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
    self.passTF.leftViewMode = UITextFieldViewModeAlways;
    self.surePassTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.telTF.leftView = [self createLeftViewWithImageName:@"account"];
    self.codeTF.leftView = [self createLeftViewWithImageName:@"verifycode"];
    self.passTF.leftView = [self createLeftViewWithImageName:@"lock"];
    self.surePassTF.leftView = [self createLeftViewWithImageName:@"lock"];
    
    
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
        
    } withTel:self.telTF.text type:@"2"];
    
    [view show];
    
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
//    
//    IMP_BLOCK_SELF(FindPassViewController);
//    
//    [JGHTTPClient getAMessageAboutCodeByphoneNum:self.telTF.text type:@"2" imageCode:nil Success:^(id responseObject) {
//        [SVProgressHUD dismiss];
//        JGLog(@"%@",responseObject[@"code"]);
//        [self showAlertViewWithText:responseObject[@"message"] duration:1];
//        if ([responseObject[@"code"]integerValue]==200) {
//            
//        }else{
//            //                [_timer invalidate];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [block_self.navigationController popViewControllerAnimated:YES];
//            });
//            
//        }
//        
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        
//        [self showAlertViewWithText:NETERROETEXT duration:1];
//    }];
    
}
- (IBAction)sureCommit:(UIButton *)sender {
    
    if (![self.passTF.text isEqualToString:self.surePassTF.text]){
        [self showAlertViewWithText:@"两次密码不一致" duration:1];
        return;
    }else if (self.passTF.text.length<6){
        [self showAlertViewWithText:@"密码为 6~32 位" duration:1];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在提交...." maskType:SVProgressHUDMaskTypeNone];
    IMP_BLOCK_SELF(FindPassViewController);
    
    [JGHTTPClient alertThePassWordByPhoneNum:self.telTF.text smsCode:self.codeTF.text newPassWord:self.passTF.text Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        [_timer invalidate];
        JGLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200) {
            
            
            [block_self showAlertViewWithText:@"密码修改成功" duration:1];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [block_self showAlertViewWithText:@"密码修改失败" duration:1];
        }
        
    } failure:^(NSError *error) {
        
        [_timer invalidate];
        [SVProgressHUD dismiss];
        [block_self showAlertViewWithText:NETERROETEXT duration:1];
    }];

    
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
//
///**
// *  提交
// *
// *  @param sureRegBtn 确认提交
// */
//-(void)commitInfo:(UIButton *)commitBtn
//{
//    if (![self.passTf.text isEqualToString:self.surePassTf.text]){
//        [self showAlertViewWithText:@"两次密码不一致" duration:1];
//        return;
//    }else if (self.passTf.text.length<6){
//        [self showAlertViewWithText:@"密码为 6~32 位" duration:1];
//        return;
//    }
//    [SVProgressHUD showWithStatus:@"正在提交...." maskType:SVProgressHUDMaskTypeNone];
//    IMP_BLOCK_SELF(FindPassViewController);
//    
//    [JGHTTPClient alertThePassWordByPhoneNum:self.phoneTf.text smsCode:self.codeTf.text newPassWord:self.passTf.text Success:^(id responseObject) {
//        [SVProgressHUD dismiss];
//        
//        [_timer invalidate];
//        JGLog(@"%@",responseObject);
//        if ([responseObject[@"code"] integerValue] == 200) {
//
// 
//            [block_self showAlertViewWithText:@"密码修改成功" duration:1];
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//            
//        }else{
//            [block_self showAlertViewWithText:@"密码修改失败" duration:1];
//        }
//        
//    } failure:^(NSError *error) {
//        
//        [_timer invalidate];
//        [SVProgressHUD dismiss];
//        [block_self showAlertViewWithText:NETERROETEXT duration:1];
//    }];
//
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
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
///**
// *  获取验证码
// */
//-(void)getCodeByPhoneNum:(UIButton *)getCodeBtn
//{
//    if (self.phoneTf.text.length!=11||![self checkTelNumber:self.phoneTf.text]) {
//        [self showAlertViewWithText:@"请输入正确的手机号" duration:1];
//        return;
//    }
//    
//    [SVProgressHUD showWithStatus:@"让验证码飞一会儿" maskType:SVProgressHUDMaskTypeNone];
//    [self.getCodeBtn setBackgroundColor:LIGHTGRAYTEXT];
//    
//    self.getCodeBtn.userInteractionEnabled = NO;
//    _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeSeconds) userInfo:nil repeats:YES];
//    
//    IMP_BLOCK_SELF(FindPassViewController);
//    
//    
//    [JGHTTPClient getAMessageAboutCodeByphoneNum:self.phoneTf.text type:@"2" imageCode:nil Success:^(id responseObject) {
//        [SVProgressHUD dismiss];
//        JGLog(@"%@",responseObject[@"code"]);
//        
//        [self showAlertViewWithText:responseObject[@"message"] duration:1];
//        
//        if ([responseObject[@"code"] integerValue] == 200) {
//            
//        }else{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [block_self.navigationController popViewControllerAnimated:YES];
//            });
//        }
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
//    codeTf.keyboardType = UIKeyboardTypeNumberPad;
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
//    //添加“确认注册”按钮
//    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    commitBtn.layer.masksToBounds = YES;
//    commitBtn.layer.cornerRadius = 20;
//    commitBtn.frame = CGRectMake(40, SCREEN_H==568?self.view.center.y:self.view.center.y-20, SCREEN_W-80, 40);
//    [commitBtn setBackgroundColor:YELLOWCOLOR];
//    [commitBtn addTarget:self action:@selector(commitInfo:) forControlEvents:UIControlEventTouchUpInside];
//    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
//    [self.view addSubview:commitBtn];
//}


@end
