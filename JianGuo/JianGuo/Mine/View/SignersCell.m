//
//  SignersCell.m
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SignersCell.h"
#import "SignUsers.h"
#import "UIImageView+WebCache.h"
#import "DateOrTimeTool.h"


#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "TextReasonViewController.h"
@interface SignersCell()<UIViewControllerTransitioningDelegate>

@end
@implementation SignersCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    SignersCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(SignUsers *)model
{
    _model= model;
    JGLog(@"%@––––>%@",model.head_img_url,model.tel);
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.head_img_url] placeholderImage:[UIImage imageNamed:@"img_renwu"]];
    self.nameL.text = model.nickname?model.nickname:@"未填写";
    NSString *timeNow = [NSString stringWithFormat:@"%@",[NSDate date]];
    NSInteger age = [timeNow substringToIndex:4].integerValue - [model.birth_date substringToIndex:4].integerValue;
    [self.ageBtn setTitle:[NSString stringWithFormat:@"%ld",age] forState:UIControlStateNormal];
//    NSArray *array = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
    self.starL.text = [DateOrTimeTool getConstellation:model.birth_date]?[DateOrTimeTool getConstellation:model.birth_date]:@"未填写";
    
    if (model.enroll_status.integerValue == 1) {
        self.stateL.text = @"待录用";
    }else if (model.enroll_status.integerValue == 2){
        self.stateL.text = @"已录用";
    }else if (model.enroll_status.integerValue == 3){
        self.stateL.text = @"已拒绝";
    }
    
    if (model.enroll_status.integerValue != 1) {
        self.rightCons.constant = 15;
        self.acceptBtn.hidden = YES;
        self.refuseBtn.hidden = YES;
    }
    
}
- (IBAction)acceptSomeOne:(id)sender {//录用
    
    if ([self.delegate respondsToSelector:@selector(userSomeOne: status:)]) {
        [self.delegate userSomeOne:_model.user_id status:@"2"];
    }
    
}
- (IBAction)refuse:(id)sender {//拒绝
    
    TextReasonViewController *reasonVC = [[TextReasonViewController alloc] init];
    reasonVC.transitioningDelegate = self;
    reasonVC.modalPresentationStyle = UIModalPresentationCustom;
    reasonVC.userId = _model.user_id;
    reasonVC.demandId = self.demandId;
    [self.window.rootViewController presentViewController:reasonVC
                                                 animated:YES
                                               completion:NULL];
    
}
- (IBAction)call:(id)sender {
    
    
    
}
- (IBAction)chat:(id)sender {
    
    
    
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
