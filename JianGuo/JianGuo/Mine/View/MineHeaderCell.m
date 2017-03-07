//
//  MineHeaderCell.m
//  JianGuo
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MineHeaderCell.h"
#import "SignUsers.h"
#import <UIButton+AFNetworking.h>
#import "DateOrTimeTool.h"

@implementation MineHeaderCell

-(void)setModel:(SignUsers *)model
{
    _model = model;
    [self.iconBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model.head_img_url] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.nameL.text = model.nickname?model.nickname:@"未填写";
    
    NSString *timeNow = [NSString stringWithFormat:@"%@",[NSDate date]];
    NSInteger age = [timeNow substringToIndex:4].integerValue - [model.birth_date substringToIndex:4].integerValue;
    [self.ageBtn setTitle:[NSString stringWithFormat:@"%ld",age] forState:UIControlStateNormal];
//    NSArray *array = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
    if (model.sex.integerValue == 1) {//女
        [self.ageBtn setImage:[UIImage imageNamed:@"girlclear"] forState:UIControlStateNormal];
    }else{
        [self.ageBtn setImage:[UIImage imageNamed:@"boyclear"] forState:UIControlStateNormal];
    }
    self.starL.text = [DateOrTimeTool getConstellation:model.birth_date]?[DateOrTimeTool getConstellation:model.birth_date]:@"未填写";
    
    
}

-(void)setData:(NSString *)data
{
    
    if (USER.login_id&&USER.login_id.integerValue!=0) {
        [self.iconBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:USER.iconUrl] placeholderImage:[UIImage imageNamed:@"myicon"]];
        
        if (USER.birthDay.length) {
            NSString *timeNow = [NSString stringWithFormat:@"%@",[NSDate date]];
            NSInteger age = [timeNow substringToIndex:4].integerValue - [USER.birthDay substringToIndex:4].integerValue;
            [self.ageBtn setTitle:[NSString stringWithFormat:@"%ld",age] forState:UIControlStateNormal];
            
        }else{
            [self.ageBtn setTitle:[NSString stringWithFormat:@"%@",@"无"] forState:UIControlStateNormal];
        }
        if (USER.gender.integerValue == 1) {//女
            [self.ageBtn setImage:[UIImage imageNamed:@"girlclear"] forState:UIControlStateNormal];
        }else{
            [self.ageBtn setImage:[UIImage imageNamed:@"boyclear"] forState:UIControlStateNormal];
        }
        //            NSArray *array = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
        self.starL.text = [DateOrTimeTool getConstellation:USER.birthDay]?[DateOrTimeTool getConstellation:USER.birthDay]:@"未填写";
        self.nameL.text = USER.nickname;
    }else{
        self.ageBtn.hidden = YES;
        self.starL.hidden = YES;
        self.nameL.text = @"未登录";
        self.unLoginL.hidden = NO;
    }
    
    
}

- (IBAction)clickPersonIcon:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickPerson:)]) {
        [self.delegate clickPerson:_model.b_user_id];
    }
    
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
