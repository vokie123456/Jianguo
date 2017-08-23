//
//  MakeEvaluateViewController.m
//  JianGuo
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MakeEvaluateViewController.h"
#import "UITextView+placeholder.h"

#import "JGHTTPClient+Skill.h"

@interface MakeEvaluateViewController ()

@property (weak, nonatomic) IBOutlet UIButton *star1;
@property (weak, nonatomic) IBOutlet UIButton *star2;
@property (weak, nonatomic) IBOutlet UIButton *star3;
@property (weak, nonatomic) IBOutlet UIButton *star4;
@property (weak, nonatomic) IBOutlet UIButton *star5;

@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (weak, nonatomic) IBOutlet UILabel *scoreL;

/** 分数 */
@property (nonatomic,strong) NSString *score;


@end

@implementation MakeEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"写评分";
    
    self.textV.placeholder = @"请对本次服务做出评价!";
    
//    self.scoreL.text = @"很差";

}


- (IBAction)clickStar:(UIButton *)sender {
    
    
    [self.star1 setBackgroundImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
    [self.star2 setBackgroundImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
    [self.star3 setBackgroundImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
    [self.star4 setBackgroundImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
    [self.star5 setBackgroundImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
    
    if (sender.tag == 101) {
        [self.star1 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        self.scoreL.text = @"很差";
    }else if (sender.tag == 102){
        
        [self.star1 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        [self.star2 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        self.scoreL.text = @"差";
        
    }else if (sender.tag == 103){
        
        [self.star1 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        [self.star2 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        [self.star3 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        self.scoreL.text = @"一般";
    }else if (sender.tag == 104){
        
        [self.star1 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        [self.star2 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        [self.star3 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        [self.star4 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        self.scoreL.text = @"好";
        
    }else if (sender.tag == 105){
        
        [self.star1 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        [self.star2 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        [self.star3 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        [self.star4 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        [self.star5 setBackgroundImage:[UIImage imageNamed:@"stars"] forState:UIControlStateNormal];
        self.scoreL.text = @"很好";
    }
    self.score = [NSString stringWithFormat:@"%ld",sender.tag-100];
    
}

-(IBAction)commit:(id)sender
{
    if (self.score.integerValue) {
        [self showAlertViewWithText:@"请打分!" duration:1.5];
        return;
    }
    
    [JGHTTPClient makeEvaluateWithOrderNo:self.orderNo score:self.score content:self.textV.text type:self.type Success:^(id responseObject) {
        
        [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if (self.callBackBlock) {
                self.callBackBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:2];
    }];
}


@end
