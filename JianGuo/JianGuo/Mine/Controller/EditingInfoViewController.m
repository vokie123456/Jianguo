//
//  EditInfoViewController.m
//  JGBuss
//
//  Created by apple on 17/4/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "EditingInfoViewController.h"
#import "JGHTTPClient+Mine.h"

@interface EditingInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textV;

@end

@implementation EditingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"编辑";
    
    self.textV.text = self.string;
    
    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setTitle:@"完成" forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_r setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    
    
    btn_r.frame = CGRectMake(0, 0, 40, 30);
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

-(void)saveInfo
{
    if (self.editCompletCallBack) {
        self.editCompletCallBack(self.textV.text);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    switch (self.type) {
        case 0:{//修改团队名称
            
//            [JGHTTPClient updateMineInfoWithteamName:self.textV.text tel:nil email:nil address:nil intrduce:nil Success:^(id responseObject) {
//                
//                [self showAlertViewWithText:responseObject[@"message"] duration:1];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//                
//            } failure:^(NSError *error) {
//                
//            }];
            
            break;
        } case 1:{//修改联系电话
            
            
//            [JGHTTPClient updateMineInfoWithteamName:nil tel:self.textV.text email:nil address:nil intrduce:nil Success:^(id responseObject) {
//                
//                [self showAlertViewWithText:responseObject[@"message"] duration:1];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//                
//            } failure:^(NSError *error) {
//                
//            }];
            
            break;
        } case 2:{//修改联系邮箱
            
            
//            [JGHTTPClient updateMineInfoWithteamName:nil tel:nil email:self.textV.text address:nil intrduce:nil Success:^(id responseObject) {
//                
//                [self showAlertViewWithText:responseObject[@"message"] duration:1];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//                
//            } failure:^(NSError *error) {
//                
//            }];
//            
            break;
        } case 3:{//修改联系地址
            
//            
//            [JGHTTPClient updateMineInfoWithteamName:nil tel:nil email:nil address:self.textV.text intrduce:nil Success:^(id responseObject) {
//                
//                [self showAlertViewWithText:responseObject[@"message"] duration:1];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//                
//            } failure:^(NSError *error) {
//                
//            }];
//            
            break;
        } case 4:{//修改团队介绍
            
//            
//            [JGHTTPClient updateMineInfoWithteamName:nil tel:nil email:nil address:nil intrduce:self.textV.text Success:^(id responseObject) {
//                
//                [self showAlertViewWithText:responseObject[@"message"] duration:1];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//                
//            } failure:^(NSError *error) {
//                
//            }];
            
            break;
        }
        default:
            break;
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textV becomeFirstResponder];
}


@end
