//
//  LimitTimeCell.m
//  JianGuo
//
//  Created by apple on 17/6/5.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "LimitTimeCell.h"

#import "TimePickerView.h"
#import "NSObject+HudView.h"

#import "NSDate+Addition.h"

@interface LimitTimeCell()<UITextFieldDelegate>

@end

@implementation LimitTimeCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    LimitTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

- (IBAction)alert:(UIButton *)sender {
    
    TimePickerView *timePickerView = [TimePickerView aTimePickerViewWithBlock:^(NSString *timeString) {
        self.timeLimitL.text = timeString;
        
        [NotificationCenter postNotificationName:kNotificationRefreshCellHeight object:timeString];
        
    }];
    timePickerView.isArriveStore = YES;
    [timePickerView show];
    
}
- (IBAction)cancel:(id)sender {
    
    [NotificationCenter postNotificationName:kNotificationRefreshCellHeight object:nil];
}
- (IBAction)setting:(UIButton *)sender {
    
    TimePickerView *timePickerView = [TimePickerView aTimePickerViewWithBlock:^(NSString *timeString) {
        self.timeLimitL.text = timeString;
//        NSString *left = [timeString substringToIndex:[timeString rangeOfString:@"("].location];
//        NSString *right = [timeString substringFromIndex:[timeString rangeOfString:@")"].location+2];
//        NSString *formatDateString = [NSString stringWithFormat:@"20%@ %@", left, right];
//        NSDate *date = [NSDate stringToDate:formatDateString format:@"yyyy年MM月dd日 HH:mm"];
        
        [NotificationCenter postNotificationName:kNotificationRefreshCellHeight object:timeString];

    }];
    timePickerView.isArriveStore = YES;
    [timePickerView show];
    
}

- (void)awakeFromNib {
    
    self.moneyTF.delegate = self;
    self.cancelB.hidden = YES;
    self.alertB.hidden = YES;
    self.setB.hidden = NO;
    
}

- (IBAction)moneyChanged:(UITextField *)sender {
    
    if (self.moneyChangedBlock) {
        self.moneyChangedBlock(sender.text);
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{//textField 的text内容是不包括当前输入的字符的字符串,string就是当前输入的字符<即 texgField.text+string 就是最终显示的内容>
    if ([textField.text rangeOfString:@"."].location!=NSNotFound) {//包含'.'
        if ([[textField.text componentsSeparatedByString:@"."].lastObject length]>=2) {
            if ([@"0123456789." containsString:string]) {
                return NO;
            }else
                return YES;
        }else if ([string isEqualToString:@"."]){
            return NO;
        }
    }
    return YES;
}


- (IBAction)textChange:(UITextField *)sender {
    
    if (self.moneyTF == sender) {
        
        NSInteger length = sender.text.length;
        
        
        
        //数字开头不能是 ..小数点
        if (length==1&&[sender.text isEqualToString:@"."]) {
            sender.text = nil;
        }
        
        //限制不能连续输入 ..小数点, 数字中只能出现一个 ..小数点
        if ([sender.text containsString:@".."]) {
            sender.text = [sender.text substringToIndex:length-2];
            return;
        }
        
        if (length>1) {//
            if ([[sender.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]&&![[sender.text substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]) {
                sender.text = @"0";
            }
            if ([[sender.text substringToIndex:length-2] containsString:@"."]&&[[sender.text substringWithRange:NSMakeRange(length-1, 1)] isEqualToString:@"."]&&length>2) {
                
                sender.text = [sender.text substringToIndex:length-2];
            }
            
        }
        
        if (length>4) {
            NSString *string = [sender.text substringWithRange:NSMakeRange(length-4, 1)];
            if ([string isEqualToString:@"."] ) {
                sender.text = [sender.text substringToIndex:length-1];
            }
        }
    }
    
    if ([[sender.text componentsSeparatedByString:@"."] firstObject].length>5) {
        sender.text = [sender.text substringToIndex:5];
        [self showAlertViewWithText:@"土豪,赏金已经不少了!" duration:1];
        return;
    }
    
    if (self.moneyChangedBlock) {
        self.moneyChangedBlock(sender.text);
    }
    
}



@end
