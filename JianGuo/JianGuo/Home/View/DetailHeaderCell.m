//
//  DetailHeaderCell.m
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "DetailHeaderCell.h"
#import "DateOrTimeTool.h"
#import "NameIdManger.h"
#import "UIImageView+WebCache.h"

@implementation DetailHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(DetailModel *)model
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.job_image] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.partTittleL.text = model.job_name;
//    self.moneyLabel.text = model.money;
    if (model.term.intValue == 5||model.term.intValue == 6) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%@",[NameIdManger getTermNameById:model.term]];
    }else{
        self.moneyLabel.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%.2f",model.money.floatValue],[NameIdManger getTermNameById:model.term]];
    }
    self.peopleCountL.text = [NSString stringWithFormat:@"%@/%@",model.count,model.sum];
    
    NSString *timeStr = [self getAtimeString:model.createTime];
    if (timeStr.length<5) {
        self.issueTimeL.text = timeStr;
    }else{
        self.issueTimeL.text = [[timeStr substringWithRange:NSMakeRange(5, 5)] stringByAppendingString:@" 发布"];
    }
    
}

-(NSString *)getAtimeString:(NSString *)timeStamp
{
    return [[DateOrTimeTool compareDate:timeStamp] stringByAppendingString:@"发布"];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
