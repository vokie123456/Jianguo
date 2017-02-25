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

-(void)setModel:(MoneyRecordModel *)model
{
    _model = model;
    if (model.type.integerValue == 1||model.type.integerValue == 6) {//兼职工资
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.logImg] placeholderImage:[UIImage imageNamed:@"cash"]];
    }else if (model.type.integerValue == 5){//充值
        self.iconView.image = [UIImage imageNamed:@"addMoney"];
    }else if (model.type.integerValue == 2){//提现
        self.iconView.image = [UIImage imageNamed:@"cash"];
    }
    self.titleL.text = model.logName;
    self.timeL.text = [[DateOrTimeTool getDateStringBytimeStamp:model.createTime.floatValue] substringFromIndex:5];
    
    if (model.type.integerValue == 1||model.type.integerValue == 5) {//加钱
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
