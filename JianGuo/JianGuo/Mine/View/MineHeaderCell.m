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
    self.nameL.text = model.name?model.name:(model.nickname?model.nickname:@"未填写");
    
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
- (IBAction)clickPersonIcon:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickPerson:)]) {
       [self.delegate clickPerson:_model.user_id];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
