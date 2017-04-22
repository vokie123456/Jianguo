//
//  DetailsCell.m
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "DetailsCell.h"
#import "DateOrTimeTool.h"
#import "NameIdManger.h"

@interface DetailsCell()

@property (nonatomic,strong) NSMutableString *labelStr;

@end

@implementation DetailsCell

-(NSMutableString *)labelStr
{
    if (!_labelStr) {
        _labelStr = [NSMutableString stringWithString:@""];
    }
    return _labelStr;
}

- (void)awakeFromNib {
    
    
}

-(void)setModel:(DetailModel *)model
{
    _model = model;
    self.addressLabel.text = [model.address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    /*  用于动态调整定位按钮的位置
     CGRect rect = self.addressLabel.frame;
     CGSize size = [self.addressLabel.text boundingRectWithSize:CGSizeMake(SCREEN_W == 320?140:SCREEN_W-self.addressLabel.right, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(14)} context:nil].size;
     rect.size.width = size.width;
     self.addressLabel.frame = rect;
     
     CGRect locRect = self.locationView.frame;
     locRect.origin.x = self.addressLabel.right;
     
     self.locationView.frame = locRect;//之前修改frame后view没效果,是因为没关掉AutoLayout
     */
    
    
//    [self.contentView layoutSubviews];
    
    self.workDateLabel.text = [self getWorkDateStrStartTime:model.start_date endTime:model.end_date];
    self.workTimeLabel.text = [self getWorkTimeStr:model.begin_time endTime:model.end_time];
    self.togetherAddressL.text = model.set_place;
    self.togetherTimeL.text = model.set_time;
    self.genderLabel.text = [NameIdManger getgenderNameById:model.limit_sex];
    if (model.permissions.integerValue==3) {//只有商家是内部商家时才是线上结算
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[model.mode_name?model.mode_name:@"" stringByAppendingString:@"【平台结算】"]];
        [string addAttributes:@{NSForegroundColorAttributeName:RedColor}  range:NSMakeRange(string.length-6, 6)];
        
        self.moneyTypeL.attributedText = string;
        
    }else{//其他的都是线下的结算方式
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[model.mode_name?model.mode_name:@"" stringByAppendingString:@"【商家自结】"]];
        [string addAttributes:@{NSForegroundColorAttributeName:RedColor}  range:NSMakeRange(string.length-6, 6)];
        self.moneyTypeL.attributedText = string;
    }
    
    for (NSString *str in model.limits_name) {
        
        self.labelStr = (NSMutableString *)[self.labelStr stringByAppendingString:[str stringByAppendingString:@"   "]];
        
    }
    
    if ([self.labelStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        self.otherLabel.text = self.labelStr;
    }else{
        self.otherLabel.text = @"无限制条件";
        self.otherLabel.textColor = LIGHTGRAYTEXT;
    }
 

}



/**
 *  工资结算方式
 */
-(NSString *)moneyType:(NSString *)term
{
    NSInteger type = [term integerValue];
    switch (type) {
        case 0:
            return @"月结";
            break;
        case 1:
            return @"周结";
            break;
        case 2:
            return @"日结";
            break;
        case 3:
            return @"旅行";
            break;
            
        default:
            return nil;
    }
}
/**
 *  判断对性别的要求
 */
-(NSString *)getLimitAboutGender:(NSString *)gender
{
    if (gender.intValue == 0) {
        return @"只招女生";
    }else if (gender.intValue == 1){
        return @"只招男生";
    }else{
        return @"男女不限";
    }
}

/**
 *  工作时间计算
 */
-(NSString *)getWorkDateStrStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSString *startDate = [DateOrTimeTool getDateStringBytimeStamp:[startTime floatValue]];
    
    NSString *endDate = [DateOrTimeTool getDateStringBytimeStamp:[endTime floatValue]];
    
    NSString *startStr = [self getWantedTimeFormatter:startDate];
    
    NSString *endStr = [self getWantedTimeFormatter:endDate];
    
    return  [startStr stringByAppendingString:[NSString stringWithFormat:@"至 %@",endStr]];
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

-(NSString *)getWorkTimeStr:(NSString *)startTime endTime:(NSString *)endTime
{
    NSString *startDate = [DateOrTimeTool getDateStringBytimeStamp:[startTime longLongValue]];
    
    NSString *endDate = [DateOrTimeTool getDateStringBytimeStamp:[endTime longLongValue]];
    
    NSString *startStr = [[NSString stringWithFormat:@"%@", startDate] substringFromIndex:11];
    
    NSString *endStr = [[NSString stringWithFormat:@"%@", endDate]substringFromIndex:11];
    return [startStr stringByAppendingString:[NSString stringWithFormat:@" 至 %@",endStr]];
}

@end
