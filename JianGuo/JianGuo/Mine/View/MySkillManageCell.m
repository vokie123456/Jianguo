//
//  MySkillManageCell.m
//  JianGuo
//
//  Created by apple on 17/8/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MySkillManageCell.h"
#import "MySkillListModel.h"
#import "MyBuySkillListModel.h"

#import "UIImageView+WebCache.h"
#import "AlertView.h"


@implementation MySkillManageCell
{
    __weak IBOutlet UILabel *alertL;
    
    __weak IBOutlet NSLayoutConstraint *alertLabelheightCons;
    __weak IBOutlet UILabel *typeNameL;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.leftB.hidden = NO;
    self.rightB.hidden = NO;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    MySkillManageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setBuyModel:(MyBuySkillListModel *)buyModel
{
    _buyModel = buyModel;
    
    [self.skillView sd_setImageWithURL:[NSURL URLWithString:buyModel.cover] placeholderImage:[UIImage imageNamed:@"kobe"]];
    self.titleL.text = buyModel.title;
    self.nameL.text = buyModel.nickname;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",buyModel.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.timeL.text = buyModel.createTimeStr;
//    if (buyModel.isAdjust&&buyModel.orderStatus == 1) {
//        alertLabelheightCons.constant = 30;
//        self.alertBottomView.hidden = NO;
//    }else{
//        alertLabelheightCons.constant = 0;
//        self.alertBottomView.hidden = YES;
//    }
    
    alertLabelheightCons.constant = 0;
    self.alertBottomView.hidden = YES;
    typeNameL.text = @"服务者:";
    
    switch (buyModel.orderStatus) {
        case -6:{
            
            self.moneyL.text = @"平台已仲裁";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case -5:{
            
            self.moneyL.text = @"平台仲裁中";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case -4:{
            
            self.moneyL.text = @"已退款";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case -3:{
            
            self.moneyL.text = @"退款申请被拒绝";
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"投诉订单" forState:UIControlStateNormal];
            
            break;
        }
        case -2:{
            
            self.moneyL.text = [NSString stringWithFormat:@"申请退款金额: %.2f 元",buyModel.refundPrice];
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case -1:{
            
            self.moneyL.text = @"订单已取消";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case 0:{
            
            self.moneyL.text = @"订单已结束";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case 1:{
            
            if (buyModel.isAdjust) {
                alertL.text = [NSString stringWithFormat:@"价格已调整为 %.2f 元,等待对方付款",buyModel.realPrice];
                self.moneyL.text = [NSString stringWithFormat:@"%.2f 元",buyModel.orderPrice];
                
            }else{
                self.moneyL.text = [NSString stringWithFormat:@"%.2f 元",buyModel.realPrice];
            }
            [self.leftB setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.rightB setTitle:@"付  款" forState:UIControlStateNormal];
            
            break;
        }
        case 2:{
            
            self.moneyL.text = [NSString stringWithFormat:@"%.2f 元",buyModel.realPrice];
            [self.leftB setTitle:@"申请退款" forState:UIControlStateNormal];
            [self.rightB setTitle:@"催TA干活" forState:UIControlStateNormal];
            
            break;
        }
        case 3:{
            
            self.moneyL.text = [NSString stringWithFormat:@"%.2f 元",buyModel.realPrice];
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"服务完成" forState:UIControlStateNormal];
            
            break;
        }
        case 4:{
            
            self.moneyL.text = [NSString stringWithFormat:@"%.2f 元",buyModel.realPrice];
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"去评价" forState:UIControlStateNormal];
            
            break;
        }
        case 5:{
            
            self.moneyL.text = @"服务已完成";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case 6:{
            
            self.moneyL.text = @"服务已完成";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case 7:{
            
            self.moneyL.text = @"服务已完成";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
    }
    
}

-(void)setModel:(MySkillListModel *)model
{
    _model = model;
    [self.skillView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"kobe"]];
    self.titleL.text = model.title;
    self.nameL.text = model.nickname;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.timeL.text = model.createTimeStr;
    if (model.isAdjust&&model.orderStatus == 1) {
        alertLabelheightCons.constant = 30;
        self.alertBottomView.hidden = NO;
    }else{
        alertLabelheightCons.constant = 0;
        self.alertBottomView.hidden = YES;
    }
    
    switch (model.orderStatus) {
        case -6:{
            
            self.moneyL.text = @"平台已仲裁";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case -5:{
            
            self.moneyL.text = @"平台仲裁中";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case -4:{
            
            self.moneyL.text = @"已退款";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case -3:{
            
            self.moneyL.text = @"已拒绝退款";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case -2:{
            
            self.moneyL.text = [NSString stringWithFormat:@"申请退款金额: %.2f 元",model.refundPrice];
            [self.leftB setTitle:@"拒绝退款" forState:UIControlStateNormal];
            [self.rightB setTitle:@"同意退款" forState:UIControlStateNormal];
            
            break;
        }
        case -1:{
            
            self.moneyL.text = @"订单已取消";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case 0:{
            
            self.moneyL.text = @"订单已结束";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case 1:{
            
            if (model.isAdjust) {
                alertL.text = [NSString stringWithFormat:@"价格已调整为 %.2f 元,等待对方付款",model.realPrice];
                self.moneyL.text = [NSString stringWithFormat:@"%.2f 元",model.orderPrice];
                
            }else{
                self.moneyL.text = [NSString stringWithFormat:@"%.2f 元",model.realPrice];
            }
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"调整价格" forState:UIControlStateNormal];
            
            break;
        }
        case 2:{
            
            self.moneyL.text = [NSString stringWithFormat:@"%.2f 元",model.realPrice];
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"完成服务" forState:UIControlStateNormal];
            
            break;
        }
        case 3:{
            
            self.moneyL.text = [NSString stringWithFormat:@"%.2f 元",model.realPrice];
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"催TA确认" forState:UIControlStateNormal];
            
            break;
        }
        case 4:{
            
            self.moneyL.text = [NSString stringWithFormat:@"%.2f 元",model.realPrice];
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"去评价" forState:UIControlStateNormal];
            
            break;
        }
        case 5:{
            
            self.moneyL.text = [NSString stringWithFormat:@"%.2f 元",model.realPrice];
            self.leftB.hidden = YES;
            [self.rightB setTitle:@"去评价" forState:UIControlStateNormal];
            
            break;
        }
        case 6:{
            
            self.moneyL.text = @"服务已完成";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
        case 7:{
            
            self.moneyL.text = @"服务已完成";
            self.leftB.hidden = YES;
            self.rightB.hidden = YES;
            
            break;
        }
    }

    
}

- (IBAction)chat:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickRight:model:)]) {
        if (_model) {
            [self.delegate clickChat:sender model:_model];
        }else if (_buyModel){
            [self.delegate clickChat:sender model:_buyModel];
        }
    }
    
}

- (IBAction)left:(id)sender {
    
    if (_model) {
        [self.delegate clickLeft:sender model:_model];
    }else if (_buyModel){
        [self.delegate clickLeft:sender model:_buyModel];
    }
    
}

- (IBAction)right:(id)sender {
    
    if (_model) {
        [self.delegate clickRight:sender model:_model];
    }else if (_buyModel){
        [self.delegate clickRight:sender model:_buyModel];
    }
}

- (void)awakeFromNib {
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
