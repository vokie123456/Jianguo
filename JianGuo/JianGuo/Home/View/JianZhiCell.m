//
//  JianZhiCell.m
//  JianGuo
//
//  Created by apple on 16/3/12.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JianZhiCell.h"
#import "JianzhiModel.h"
#import "UIImageView+WebCache.h"
#import "DateOrTimeTool.h"
#import "NameIdManger.h"
@interface JianZhiCell()
{
    
}
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeViewWidth;

@end
@implementation JianZhiCell

-(void)awakeFromNib
{
    self.animationView.hidden = YES;
    self.typeViewWidth.constant = 0;
    if (SCREEN_W == 320) {
        self.partTittleLabel.font = FONT(14);
        
        CGRect rect = self.genderLabel.frame;
        rect.origin.x += 10;
        self.genderLabel.frame = rect;
        
        CGRect rect2 = self.partTittleLabel.frame;
        rect2.size.width = 150;
        self.partTittleLabel.frame = rect2;
    }
    self.iconView.layer.cornerRadius = 19;
    self.iconView.layer.masksToBounds = YES;
    
}

-(void)setModel:(JianzhiModel *)model
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.job_image] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.partTittleLabel.text = model.job_name;
    self.moneyTypeLabel.text = [self moneyType:model.mode];
    self.workTimeLabel.text = [self getWorkTimeStrStartTime:model.start_date endTime:model.end_date];
    self.addressLabel.text = model.address;
    self.genderLabel.image = [self getAimage:model.limit_sex];
   
    if (model.term.intValue == 5||model.term.intValue==6) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%@",[NameIdManger getTermNameById:model.term]];
    }else{
        if ([model.money containsString:@"."]) {
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f%@",model.money.floatValue,[NameIdManger getTermNameById:model.term]];
        }else{
            self.moneyLabel.text = [NSString stringWithFormat:@"%@%@",model.money,[NameIdManger getTermNameById:model.term]];
        }
    }
    self.animationView.studentNum = model.count.floatValue/model.sum.floatValue;
    if (model.count.intValue>=model.sum.intValue) {
        self.percentLabel.text = @"已招满";
    }else{
        self.percentLabel.text = [NSString stringWithFormat:@"%@/%@",model.count,model.sum];
    }
    if(model.max.intValue==1){
//        self.typeView.hidden = NO;
        self.typeViewWidth.constant = 18;
    }
    if (model.status.intValue != 0) {
//        self.dateView.hidden = NO;
    }
    NSInteger sum = model.sum.integerValue;
    if (sum<=10) {
        sum += 5;
        
    }else{
        sum = sum*1.4;
    }
    NSInteger count = model.user_count.integerValue;
    if (sum<=model.user_count.integerValue) {
        [self.stateBtn setImage:[UIImage imageNamed:@"enoughIcon"] forState:UIControlStateNormal];
        [self.stateBtn setTitle:@"已经招满" forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.leftCountL.hidden = YES;
    }else{
        if (model.status.intValue!=1) {
            [self.stateBtn setImage:[UIImage imageNamed:@"enoughIcon"] forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"已经招满" forState:UIControlStateNormal];
            [self.stateBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            self.leftCountL.hidden = YES;
        }else{
            [self.stateBtn setImage:[UIImage imageNamed:@"noEnoughIcon"] forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"正在招聘" forState:UIControlStateNormal];
            [self.stateBtn setTitleColor:RedColor forState:UIControlStateNormal];
            
            self.leftCountL.hidden = NO;
            
            NSMutableAttributedString *leftStr;
            NSInteger num;
            num = sum - count;
            leftStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"仅剩 %ld 个名额",num]];
            [leftStr addAttributes:@{NSForegroundColorAttributeName:RedColor,NSFontAttributeName:FONT(15)}  range:NSMakeRange(3, leftStr.length-7)];
            self.leftCountL.attributedText = leftStr;
            
        }
            
    }
    
    [self.scanBtn setTitle:[NSString stringWithFormat:@"%ld",model.browse_count.integerValue*7] forState:UIControlStateNormal];
}


/**
 *  返回性别图标
 */
-(UIImage *)getAimage:(NSString *)sex
{
    if (sex.integerValue == 0||sex.intValue == 30) {//只招女
        return [UIImage imageNamed:@"icon_woman"];
    }else if (sex.integerValue == 1||sex.intValue == 31){//只招男
        return [UIImage imageNamed:@"icon_man"];
    }else{//男女不限
        return [UIImage imageNamed:@"icon_xingbie"];
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
        case 4:
            return @"完工结";  
            break;
            
        default:
            return nil;
    }
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


@end
