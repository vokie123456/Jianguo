//
//  BindingTelViewController.m
//  JianGuo
//
//  Created by apple on 16/12/29.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "BindingTelViewController.h"
#import "JGHTTPClient+LoginOrRegister.h"
#import "ProfileViewController.h"

#import "CodeValidateView.h"

#define SECONDCOUNT 60

@interface BindingTelViewController ()
{
    int count;
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UITextField *telTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBindBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@end

@implementation BindingTelViewController

-(void)setProperDict:(NSDictionary *)properDict
{
    _properDict = properDict;
    self.uid = properDict[@"uid"];
    self.type = properDict[@"type"];
    self.nickname = properDict[@"nickname"];
    self.iconUrl = properDict[@"iconUrl"];
    self.sex = properDict[@"sex"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    count = SECONDCOUNT;
    
    self.telTF.leftViewMode = UITextFieldViewModeAlways;
    self.telTF.leftView = [self createLeftView];
    
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
    self.codeTF.leftView = [self createLeftView];
    
}

-(UIView *)createLeftView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    return view;
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
        
    } withTel:USER.tel type:@"1"];
    
    [view show];
    
//    JGSVPROGRESSLOAD(@"正在发送验证码");
//    
//    [JGHTTPClient getAMessageAboutCodeByphoneNum:self.telTF.text type:@"1" imageCode:nil Success:^(id responseObject) {
//        [SVProgressHUD dismiss];
//        [self showAlertViewWithText:responseObject[@"message"] duration:1];
//        
//        
//        
//    } failure:^(NSError *error) {
//        
//        [SVProgressHUD dismiss];
//        
//        [self showAlertViewWithText:NETERROETEXT duration:1];
//    }];
    
}
- (IBAction)sureBinding:(UIButton *)sender {
    
    JGSVPROGRESSLOAD(@"正在绑定手机号")
    [JGHTTPClient bindingPhoneNumByUid:self.uid tel:self.telTF.text loginType:self.type sex:self.sex code:self.codeTF.text nickname:self.nickname iconUrl:self.iconUrl Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"]integerValue] == 200) {//去填写资料
            
            ProfileViewController *profileVC = [[ProfileViewController alloc] init];
            [self.navigationController pushViewController:profileVC animated:YES];
        }
        
        
    } failure:^(NSError *error) {
        
        
        [_timer invalidate];
        [SVProgressHUD dismiss];
    }];
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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


@end
