//
//  GetCashProgressCell.m
//  JianGuo
//
//  Created by apple on 17/4/11.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "GetCashProgressCell.h"
#import "DemandStatusModel.h"
#import "DateOrTimeTool.h"

@implementation GetCashProgressCell

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.timeL.hidden = NO;
    self.iconView.image = [UIImage imageNamed:@"markk"];
    

}

- (void)awakeFromNib {
    self.contentView.backgroundColor = WHITECOLOR;
}

-(void)setModel:(DemandStatusModel *)model
{
    self.contentL.text = model.content;
    if (model.time.length) {
        if ([model.content isEqualToString:@"已提交"]) {
            
            self.timeL.text = [[DateOrTimeTool getDateStringBytimeStamp:model.time.floatValue] stringByAppendingString:@"\n提交后24小时内完成提现,请耐心等待"];
        }else if ([model.content isEqualToString:@"提现申请被驳回"]){
            self.timeL.text = [[DateOrTimeTool getDateStringBytimeStamp:model.time.floatValue] stringByAppendingString:@"\n您可以联系客服咨询详情!"];
            
        }
        else{
            self.timeL.text = [DateOrTimeTool getDateStringBytimeStamp:model.time.floatValue];
        }
    }else{
        self.timeL.hidden = YES;
    }
    if (model.isFinished) {
        
        self.timeL.textColor = GreenColor;
        self.contentL.textColor = GreenColor;
        self.iconView.image = [UIImage imageNamed:@"mark"];
    }else{
        
        self.timeL.textColor = [UIColor lightGrayColor];
        self.contentL.textColor = [UIColor darkGrayColor];
        self.iconView.image = [UIImage imageNamed:@"markk"];
    }
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    GetCashProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
