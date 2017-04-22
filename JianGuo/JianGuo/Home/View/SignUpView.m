//
//  SignUpView.m
//  JianGuo
//
//  Created by apple on 16/3/19.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "SignUpView.h"
#import "UIView+AlertView.h"
#import "DateOrTimeTool.h"
#import "NameIdManger.h"

@interface SignUpView()

@property (nonatomic,strong) NSMutableString *labelStr;

@end

@implementation SignUpView



-(NSMutableString *)labelStr
{
    if (!_labelStr) {
        _labelStr = [NSMutableString stringWithString:@""];
    }
    return _labelStr;
}

/**
 *  报名提示view
 */
+(instancetype)aSignUpView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SignUpView" owner:nil options:nil]lastObject];
}
-(void)awakeFromNib
{
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
}

-(void)show
{
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.boardView.transform = CGAffineTransformMakeTranslation(0, self.boardView.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3f animations:^{
        
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        self.boardView.transform = CGAffineTransformIdentity;
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        self.boardView.transform = CGAffineTransformMakeTranslation(0, self.boardView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

- (IBAction)closeClick:(UIButton *)sender
{
    [self dismiss];
}
//确定报名
- (IBAction)sureToSignUp:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        self.boardView.transform = CGAffineTransformMakeTranslation(0, self.boardView.height);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        if (self.signupBlock) {
            self.signupBlock();
        }
        
    }];
}

-(void)setJzModel:(JianzhiModel *)jzModel
{
    self.moneyL.text = [NSString stringWithFormat:@"%@/天",jzModel.money];
}

-(void)setModel:(DetailModel *)model
{
    _model= model;
    CGRect rect = self.addressL.frame;
    
    self.addressL.text = model.address;
    
    CGSize size = [self.addressL.text boundingRectWithSize:CGSizeMake(SCREEN_W == 320?140:MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(14)} context:nil].size;
    rect.size.width = size.width;
    self.addressL.frame = rect;
    
//    CGRect locRect = self.locationView.frame;
//    locRect.origin.x = self.addressLabel.right;
//    
//    self.locationView.frame = locRect;//之前修改frame后view没效果,是因为没关掉AutoLayout
    
    //    [self.contentView layoutSubviews];
    
//    self.moneyL.text = model.money;
    
    if (model.term.intValue == 5||model.term.intValue == 6) {
        self.moneyL.text = [NSString stringWithFormat:@"%@",[NameIdManger getTermNameById:model.term]];
    }else{
        self.moneyL.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%.2f",model.money.floatValue],[NameIdManger getTermNameById:model.term]];
    }
    
    self.workDateL.text = [self getWorkDateStrStartTime:model.start_date endTime:model.end_date];
    self.workTimeL.text = [self getWorkTimeStr:model.begin_time endTime:model.end_time];
    self.togetherAddL.text = model.set_place;
    self.togetherTimeL.text = model.set_time;
    self.genderL.text = [NameIdManger getgenderNameById:model.limit_sex];;
    
    if (model.permissions.integerValue==3) {//只有商家是内部商家时才是线上结算
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[model.mode_name stringByAppendingString:@"【平台结算】"]];
        [string addAttributes:@{NSForegroundColorAttributeName:RedColor}  range:NSMakeRange(string.length-6, 6)];
        
        self.moneyTypeL.attributedText = string;
        
    }else{//其他的都是线下的结算方式
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[model.mode_name stringByAppendingString:@"【商家自结】"]];
        [string addAttributes:@{NSForegroundColorAttributeName:RedColor}  range:NSMakeRange(string.length-6, 6)];
        
        self.moneyTypeL.attributedText = string;
    }
    
    for (NSString *str in model.limits_name) {
        
        self.labelStr = (NSMutableString *)[self.labelStr stringByAppendingString:[str stringByAppendingString:@"   "]];
        
    }
    
    if ([self.labelStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        self.otherL.text = self.labelStr;
    }else{
        self.otherL.text = @"无限制条件";
        self.otherL.textColor = LIGHTGRAYTEXT;
    }
    
}
/**
 *  工资结算方式
 */
-(NSString *)moneyType:(NSString *)term
{
    NSInteger type = [term integerValue];
    switch (type) {
        case 1:
            return @"月结";
            break;
        case 2:
            return @"周结";
            break;
        case 3:
            return @"日结";
            break;
        case 4:
            return @"小时结";
            break;
            
        default:
            return nil;
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

-(NSString *)getWorkTimeStr:(NSString *)startTime endTime:(NSString *)endTime
{
    NSString *startDate = [DateOrTimeTool getDateStringBytimeStamp:[startTime longLongValue]];
    
    NSString *endDate = [DateOrTimeTool getDateStringBytimeStamp:[endTime longLongValue]];
    
    NSString *startStr = [[NSString stringWithFormat:@"%@", startDate] substringFromIndex:12];
    
    NSString *endStr = [[NSString stringWithFormat:@"%@", endDate]substringFromIndex:12];
    return [startStr stringByAppendingString:[NSString stringWithFormat:@"-%@",endStr]];
}

@end
