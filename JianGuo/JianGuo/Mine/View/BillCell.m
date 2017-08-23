//
//  BillCell.m
//  JianGuo
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "BillCell.h"
#import "MoneyRecordModel.h"
#import "UIImageView+WebCache.h"
#import "DateOrTimeTool.h"

@implementation BillCell

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.iconView.image = nil;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.leftConst.constant = 5;
}

/**
 1;//兼职工资
 3://完成任务工资
 5;//充值
 7;//用户下架任务退回的钱
 –––––––––––––––––––––
 2;//提现
 4;//商家支出工资款（商家端记录信息备用）
 6;//用户发布需求冻结（发需求扣款记录）
 
 –––––––––––––––––––––
 16 技能订单收入   
 17 技能订单退款收入
 -1 技能订单支出
 
 */
-(void)setModel:(MoneyRecordModel *)model
{
    _model = model;
    if (model.type.integerValue == 6) {//兼职工资
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.logImg]] placeholderImage:[UIImage imageNamed:@"cash"]];
    }else if (model.type.integerValue == 1||model.type.integerValue == 3||model.type.integerValue == 5||model.type.integerValue == 7||model.type.integerValue == 17||model.type.integerValue == 16||model.type.integerValue == -1){//充值
        if (model.type.integerValue == 5) {
            self.iconView.image = [UIImage imageNamed:@"addMoney"];
        }else if (model.type.integerValue == -1){//提现
            self.iconView.image = [UIImage imageNamed:@"cash"];
        }else{
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.logImg]] placeholderImage:[UIImage imageNamed:@"addMoney"]];
        }
    }else if (model.type.integerValue == 2){//提现
        self.iconView.image = [UIImage imageNamed:@"cash"];
    }
    if (model.type.integerValue == 2) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
        self.leftConst.constant = 25;
    }
    
    self.titleL.text = model.logName;
    self.timeL.text = [[DateOrTimeTool getDateStringBytimeStamp:model.createTime.floatValue] substringFromIndex:5];
    
    if (model.type.integerValue == 1||model.type.integerValue == 5||model.type.integerValue == 3||model.type.integerValue == 7||model.type.integerValue == 17||model.type.integerValue == 16) {//加钱
        self.moneyL.text = [NSString stringWithFormat:@"+ %.2f",model.money.floatValue];
    }else{//减钱
        self.moneyL.text = [NSString stringWithFormat:@"- %.2f",model.money.floatValue];
    }
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
