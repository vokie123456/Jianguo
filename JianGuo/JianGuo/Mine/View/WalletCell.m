//
//  WalletCell.m
//  JianGuo
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "WalletCell.h"
#import "UIImageView+WebCache.h"
#import "DateOrTimeTool.h"

@implementation WalletCell

-(void)prepareForReuse
{
    
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(MoneyRecordModel *)model
{
    _model = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.job_image] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.tittleL.text = model.job_name;
    if (model.note.length&&![model.note isKindOfClass:[NSNull class]]&&![model.note isEqualToString:@"null"]) {
        self.remarkL.text = [@"备注:" stringByAppendingString:model.note];
    }
    self.worKDateL.text = [self getWorkTimeStrStartTime:model.start_date endTime:model.end_date];
    self.moneyL.text = [@"+" stringByAppendingString:model.money];
    
}
/**
 *  工作时间计算
 */
-(NSString *)getWorkTimeStrStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSString *startDate = [DateOrTimeTool getDateStringBytimeStamp:[startTime floatValue]];
    
    NSString *endDate = [DateOrTimeTool getDateStringBytimeStamp:[endTime floatValue]];
    
    NSString *startStr = [self getWantedTimeFormatter:startDate];
    
    NSString *endStr = [self getWantedTimeFormatter:endDate];
    
    return  [startStr stringByAppendingString:[NSString stringWithFormat:@"-%@",endStr]];
}

/**
 *  截取日期中想要的部分
 */
-(NSString *)getWantedTimeFormatter:(NSString*)date
{
    NSString *str = [NSString stringWithFormat:@"%@",date];
    
    NSRange range = (NSRange){5,6};
    
    NSString *dateStr = [str substringWithRange:range];
    
    return dateStr;
    
    
}

@end
