//
//  OpinionsViewController.m
//  JianGuo
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "OpinionsViewController.h"
#import "UITextView+placeholder.h"
#import "JGHTTPClient+Mine.h"

static NSString *placeholder = @"请输入您的意见,我们将不断优化";

@interface OpinionsViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITextView *opinionTV;
@property (nonatomic,strong) UITextField *phoneOrQQTF;
@property (nonatomic,strong) UIButton *btn;

@end

@implementation OpinionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.opinionTV = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_W, 115)];
    self.opinionTV.delegate =self;
    self.opinionTV.font = FONT(14);
    self.opinionTV.placeholder = placeholder;
    [self.view addSubview:self.opinionTV];
    
    UIView *rightPlaeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.opinionTV.bottom+20, SCREEN_W, 40)];
    rightPlaeView.backgroundColor = WHITECOLOR;
    [self.view addSubview:rightPlaeView];
    
    UITextField *phoneOrQQTF = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, SCREEN_W-10, 40)];
    phoneOrQQTF.font = FONT(14);
    phoneOrQQTF.delegate = self;
    phoneOrQQTF.backgroundColor = WHITECOLOR;
    [phoneOrQQTF addTarget:self action:@selector(editChange:) forControlEvents:UIControlEventEditingChanged];
    phoneOrQQTF.placeholder = @"请输入您的手机号";
    [rightPlaeView addSubview:phoneOrQQTF];
    self.phoneOrQQTF = phoneOrQQTF;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, rightPlaeView.bottom+30, SCREEN_W-60, 40);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [btn setBackgroundColor:GreenColor];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commitOpinion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.btn = btn;
}

-(void)commitOpinion:(UIButton *)btn
{
    if ([self.opinionTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0) {
        
        [JGHTTPClient commitOpinionsByTel:USER.login_id text:self.opinionTV.text Success:^(id responseObject) {
            if ([responseObject[@"code"] intValue] == 200) {
                [self showAlertViewWithText:@"提交成功" duration:1];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        } failure:^(NSError *error) {
            [self showAlertViewWithText:NETERROETEXT duration:1];
        }];
        
    }else{
        [self showAlertViewWithText:@"请填写必要内容" duration:1];
        return;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    //str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去掉字符串两头的空格和换行符
    if ([self.opinionTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0) {
        
        [self.btn setBackgroundColor:GreenColor];
    }
}
-(void)editChange:(UITextField *)textField
{
    if ([self.phoneOrQQTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0&&[self.opinionTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0) {
        
        [self.btn setBackgroundColor:GreenColor];
    }else if ([self.phoneOrQQTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0||[self.opinionTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [self.btn setBackgroundColor:GreenColor];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.opinionTV endEditing:YES];
    [self.phoneOrQQTF endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.opinionTV endEditing:YES];
    [self.phoneOrQQTF endEditing:YES];
    return YES;
}


@end
