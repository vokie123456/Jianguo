//
//  MyDemandCell.m
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyDemandCell.h"
#import "DemandModel.h"
#import "UIImageView+WebCache.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "TextReasonViewController.h"
#import "QLAlertView.h"
#import "JGHTTPClient+Demand.h"
#import "QLHudView.h"
#import "NSObject+HudView.h"

@interface MyDemandCell()<UIViewControllerTransitioningDelegate>
@end
@implementation MyDemandCell

-(void)prepareForReuse
{
//    [super prepareForReuse];
    self.stateBtn.hidden = NO;
    self.usersBtn.hidden = YES;
}

-(void)setModel:(DemandModel *)model
{
    _model = model;
    self.nameL.text = model.title;
    self.moneyL.text = [NSString stringWithFormat:@"赏金 %@ 元",model.money];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.d_image] placeholderImage:[UIImage imageNamed:@"img_renwu"]];
    
    if (_isSelfSign) {
        //在 我报名的 里的布局
        [self configSelfSignCell:model];
    }else{
        //在 我发布的 里的布局
        [self configCell:model];
    }
    
}

-(void)configSelfSignCell:(DemandModel *)model
{
    if (model.enroll_status.integerValue == 1) {
        self.stateL.text = @"待录用";
        self.usersBtn.hidden = YES;
        self.stateBtn.hidden = YES;
    }else if (model.enroll_status.integerValue == 3){
        self.stateL.text = @"被拒绝";
        self.usersBtn.hidden = YES;
        self.stateBtn.hidden = YES;
    }else if (model.enroll_status.integerValue == 2){
        switch (model.d_status.integerValue) {
            case 2:{
                
                self.stateL.text = @"待完工";
                [self.stateBtn setTitle:@"确认完成" forState:UIControlStateNormal];
                self.usersBtn.hidden = YES;
                
                break;
            } case 3:{
                
                self.stateL.text = @"待确认完工";
                self.usersBtn.hidden = YES;
                self.stateBtn.hidden = YES;
                
                break;
            } case 4:{
                
                self.stateL.text = @"已完成";
                self.usersBtn.hidden = YES;
                self.stateBtn.hidden = YES;
                
                break;
            } case 5:{
                
                
                self.stateL.text = @"平台仲裁中";
                self.usersBtn.hidden = YES;
                self.stateBtn.hidden = YES;
                
                break;
            } case 6:{
                
                self.stateL.text = @"仲裁完成";
                self.usersBtn.hidden = YES;
                self.stateBtn.hidden = YES;
                
                break;
            }
            default:
                self.usersBtn.hidden = YES;
                self.stateBtn.hidden = YES;
                break;
        }

    }
}

-(void)configCell:(DemandModel *)model
{
    switch (model.d_status.integerValue) {
        case 1:{//需求发布的正常状态(发布者能 查看报名,下架任务)
            
            self.usersBtn.hidden = NO;
            self.stateL.text = @"报名中";
            
            break;
        } case 2:{//需求已经录用一个用户(此时发布者无操作)
            
            self.usersBtn.hidden = YES;
            self.stateBtn.hidden = YES;
            self.stateL.text = @"工作中";
            
            break;
        } case 3:{//参与者完成需求(发布者确认完成,投诉服务者)
            
            self.usersBtn.hidden = NO;
            [self.usersBtn setTitle:@"投   诉" forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"确认完成" forState:UIControlStateNormal];
            self.stateL.text = @"待确认完工";
            
            break;
        } case 4:{//发布者确认完成需求并支付(已完成状态,无操作)
            
            self.usersBtn.hidden = YES;
            self.stateBtn.hidden = YES;
            self.stateL.text = @"已完成";
            
            break;
        } case 5:{//发布者投诉了服务者(平台仲裁中,发布者能联系客服)
            
            [self.stateBtn setTitle:@"联系客服" forState:UIControlStateNormal];
            self.stateL.text = @"平台仲裁中";
            
            break;
        } case 6:{//平台完成仲裁(发布者能联系客服)
            
            [self.stateBtn setTitle:@"联系客服" forState:UIControlStateNormal];
            self.stateL.text = @"已仲裁";
            
            break;
        } case 7:{//发布者下架任务(发布者 无操作)
            
            self.usersBtn.hidden = YES;
            self.stateBtn.hidden = YES;
            self.stateL.text = @"已下架";
            
            break;
        } case 8:{//后台审核未通过需求(发布者 联系客服)
            
            [self.stateBtn setTitle:@"联系客服" forState:UIControlStateNormal];
            self.stateL.text = @"审核未通过";
            
            break;
        }
        default:
            break;
    }
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    MyDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

- (IBAction)getUsers:(UIButton *)sender {
    

    if ([sender.currentTitle containsString:@"报名"]) {//进入报名列表页
        if ([self.delegate respondsToSelector:@selector(getUsers:)]) {
            [self.delegate getUsers:_model.id];
        }
    }else if ([sender.currentTitle containsString:@"投"]){//投诉某人
        
        TextReasonViewController *reasonVC = [[TextReasonViewController alloc] init];
        reasonVC.transitioningDelegate = self;
        reasonVC.modalPresentationStyle = UIModalPresentationCustom;
        reasonVC.demandId = _model.id;
        reasonVC.isComplain = YES;
        [self.window.rootViewController presentViewController:reasonVC
                                                     animated:YES
                                                   completion:NULL];
        
    }
   
    
}
- (IBAction)deleteDemand:(id)sender {
    
    
}

- (IBAction)changeStatus:(UIButton *)sender {
    
    if ([sender.currentTitle containsString:@"完成"]){
        if (self.isSelfSign) {
            [QLAlertView showAlertTittle:@"确认完工吗?" message:nil isOnlySureBtn:NO compeletBlock:^{//发布者确认完成
                [JGHTTPClient updateDemandStatusWithDemandId:_model.id status:@"3" Success:^(id responseObject) {
                    [self showAlertViewWithText:responseObject[@"message"] duration:1];
                } failure:^(NSError *error) {
                    
                }];
            }];
        }else{
            [QLAlertView showAlertTittle:@"确认完成后，平台将会把款项支付给服务者" message:nil isOnlySureBtn:NO compeletBlock:^{//发布者确认完成
                [JGHTTPClient updateDemandStatusWithDemandId:_model.id status:@"4" Success:^(id responseObject) {
                    [self showAlertViewWithText:responseObject[@"message"] duration:1];
                } failure:^(NSError *error) {
                    
                }];
            }];
        }
    }else if ([sender.currentTitle containsString:@"下架"]){
        [QLAlertView showAlertTittle:@"下架后，所有的报名者将自动拒绝，确定要下架吗?" message:nil isOnlySureBtn:NO compeletBlock:^{//发布者下架需求
            [JGHTTPClient updateDemandStatusWithDemandId:_model.id status:@"7" Success:^(id responseObject) {
                [QLHudView showAlertViewWithText:responseObject[@"message"] duration:1];
            } failure:^(NSError *error) {
                
            }];
        }];
    }
    
}



- (void)awakeFromNib {
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
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

@end
