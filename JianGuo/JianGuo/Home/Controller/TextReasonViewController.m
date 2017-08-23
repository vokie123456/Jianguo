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
#import "JGHTTPClient+Skill.h"
#import "JGHTTPClient+DemandOperation.h"

@interface TextReasonViewController ()
@property (weak, nonatomic) IBOutlet UITextView *reasonTV;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end

@implementation TextReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITECOLOR;
    self.reasonTV.placeholder = @"请输入内容...";
    
    switch (self.functionType) {
        case ControllerFunctionTypeRefusePay:{
            
            self.titleL.text = @"拒绝理由:";
            
            break;
        } case ControllerFunctionTypePublisherEvualuate:{
            
            self.titleL.text = @"评价服务";
            
            break;
        } case ControllerFunctionTypeWaiterEvaluate:{
            
            self.titleL.text = @"评价任务";
            
            break;
        } case ControllerFunctionTypePublisherComplain:{
            
            self.titleL.text = @"投诉理由";
            
            break;
        } case ControllerFunctionTypeSkillApplyRefund:{
            
            self.titleL.text = @"申请理由";
            
            break;
        }
        default:
            break;
    }

}
- (IBAction)sure:(id)sender {
    
    switch (self.functionType) {
        case ControllerFunctionTypeRefusePay:{
            
            JGSVPROGRESSLOAD(@"正在请求...");
            [JGHTTPClient refusePayMoneyWithDemandId:self.demandId Success:^(id responseObject) {
                
                [SVProgressHUD dismiss];
                [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
                if ([responseObject[@"code"] integerValue] == 200) {
                    if ([responseObject[@"code"]integerValue] == 200) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self dismiss:nil];
                        });
                    }
                }
                
            } failure:^(NSError *error) {
                
                [self showAlertViewWithText:NETERROETEXT duration:1.f];
                [SVProgressHUD dismiss];
            }];
            
            break;
        } case ControllerFunctionTypePublisherEvualuate:{
            
            JGSVPROGRESSLOAD(@"正在请求...");
            [JGHTTPClient evaluateDemand:self.demandId toUserId:self.userId comment:self.reasonTV.text type:@"2" Success:^(id responseObject) {
                
                [SVProgressHUD dismiss];
                [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
                if ([responseObject[@"code"]integerValue] == 200) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismiss:nil];
                    });
                }
                
            } failure:^(NSError *error) {
                
                [self showAlertViewWithText:NETERROETEXT duration:1.f];
                [SVProgressHUD dismiss];
            }];
            
            break;
        } case ControllerFunctionTypeWaiterEvaluate:{
            
            JGSVPROGRESSLOAD(@"正在请求...");
            [JGHTTPClient evaluateDemand:self.demandId toUserId:self.userId comment:self.reasonTV.text type:@"1" Success:^(id responseObject) {
                
                [SVProgressHUD dismiss];
                [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
                if ([responseObject[@"code"]integerValue] == 200) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismiss:nil];
                    });
                }
                
            } failure:^(NSError *error) {
                
                [self showAlertViewWithText:NETERROETEXT duration:1.f];
                [SVProgressHUD dismiss];
            }];
            
            break;
        } case ControllerFunctionTypePublisherComplain:{
            
            JGSVPROGRESSLOAD(@"正在请求...");
            [JGHTTPClient complainSomeOneWithDemandId:self.demandId userId:self.userId status:@"5" reason:self.reasonTV.text Success:^(id responseObject) {
                
                [SVProgressHUD dismiss];
                [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
                if ([responseObject[@"code"]integerValue] == 200) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismiss:nil];
                    });
                }
                
            } failure:^(NSError *error) {
                
                [self showAlertViewWithText:NETERROETEXT duration:1.f];
                [SVProgressHUD dismiss];
            }];
            
            break;
        } case ControllerFunctionTypeSkillApplyRefund:{
            
            JGSVPROGRESSLOAD(@"正在请求...");
            [JGHTTPClient userApplyForRefundWithOrderNo:self.orderNo reason:self.reasonTV.text Success:^(id responseObject) {
                
                [SVProgressHUD dismiss];
                [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
                if ([responseObject[@"code"]integerValue] == 200) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismiss:nil];
                    });
                }
                
            } failure:^(NSError *error) {
                
                [self showAlertViewWithText:NETERROETEXT duration:1.f];
                [SVProgressHUD dismiss];
            }];
            
            break;
        }
    }
    
//    if (self.isPublisherEvaluate) {//发布者评价服务者
//        [JGHTTPClient complainSomeOneWithDemandId:self.demandId userId:self.userId status:@"5" reason:self.reasonTV.text Success:^(id responseObject) {
//            [SVProgressHUD dismiss];
//            [self showAlertViewWithText:responseObject[@"message"] duration:1];
//            if ([responseObject[@"code"]integerValue] == 200) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self dismiss:nil];
//                });
//            }
//        } failure:^(NSError *error) {
//            [SVProgressHUD dismiss];
//        }];
//
//    }else{//服务者评价发布者
//        [JGHTTPClient signDemandWithDemandId:self.demandId userId:self.userId status:@"3" reason:self.reasonTV.text Success:^(id responseObject) {
//            [SVProgressHUD dismiss];
//            [self showAlertViewWithText:responseObject[@"message"] duration:1];
//            if ([responseObject[@"code"]integerValue] == 200) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self dismiss:nil];
//                });
//            }
//        } failure:^(NSError *error) {
//            [SVProgressHUD dismiss];
//        }];
//    }
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (!sender) {
        if (self.callBackBlock) {
            self.callBackBlock();
        }
    }
    
}

@end
