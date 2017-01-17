//
//  PayDetailCell.m
//  JianGuo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "PayDetailCell.h"
#import "DateOrTimeTool.h"

@implementation PayDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(MoneyRecordModel *)model
{
    _model = model;
    
    self.timeL.text = [[DateOrTimeTool getDateStringBytimeStamp:model.createTime.longLongValue] substringFromIndex:5];
    self.moneyL.text = [@"-" stringByAppendingString:model.money];
    switch (model.status.intValue) {
        case 0:
            self.exportTypeL.text = @"即将到账";
            break;
        case 1:
            if (model.type.intValue == 0) {
                self.exportTypeL.text = @"已转出到支付宝";
            }else if (model.type.intValue == 1){
                self.exportTypeL.text = @"已转出到银行卡";
            }
            break;
        case 2:
            self.exportTypeL.text = model.note;
            break;
    }
}

@end
