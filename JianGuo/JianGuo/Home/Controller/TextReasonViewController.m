//
//  TextReasonViewController.m
//  JianGuo
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "TextReasonViewController.h"
#import "UITextView+placeholder.h"
#import "JGHTTPClient+Demand.h"

@interface TextReasonViewController ()
@property (weak, nonatomic) IBOutlet UITextView *reasonTV;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end

@implementation TextReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITECOLOR;
    self.reasonTV.placeholder = @"请输入您的操作理由";
    if (self.isComplain) {
        self.titleL.text = @"投诉理由:";
    }else {
        self.titleL.text = @"拒绝理由:";
    }
}
- (IBAction)sure:(id)sender {
    JGSVPROGRESSLOAD(@"正在请求...");
    if (self.isComplain) {//投诉某人
        [JGHTTPClient complainSomeOneWithDemandId:self.demandId userId:self.userId status:@"5" reason:self.reasonTV.text Success:^(id responseObject) {
            [SVProgressHUD dismiss];
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
            if ([responseObject[@"code"]integerValue] == 200) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismiss:nil];
                });
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }else{//拒绝某人
        [JGHTTPClient signDemandWithDemandId:self.demandId userId:self.userId status:@"3" reason:self.reasonTV.text Success:^(id responseObject) {
            [SVProgressHUD dismiss];
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
            if ([responseObject[@"code"]integerValue] == 200) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismiss:nil];
                });
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.callBackBlock) {
        self.callBackBlock();
    }
    
}

@end
