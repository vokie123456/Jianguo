//
//  SkillsCell.m
//  JianGuo
//
//  Created by apple on 17/7/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SkillsCell.h"
#import "SkillListModel.h"

#import "JGHTTPClient+Skill.h"

#import "UIImageView+WebCache.h"

@implementation SkillsCell

-(void)prepareForReuse
{
    [self.collectionB setBackgroundImage:[UIImage imageNamed:@"stars1"] forState:UIControlStateNormal];
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    SkillsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(SkillListModel *)model
{
    _model = model;
    self.skillL.text = model.masterTitle;
    self.titleL.text = model.title;
    self.starView.score = model.averageScore;
    self.nameL.text = model.masterTitle;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.timeSchoolL.text = [NSString stringWithFormat:@"%@ | %@",model.createTimeStr,model.schoolName.length?model.schoolName:model.cityName];
    self.saleCountL.text = [NSString stringWithFormat:@"已售: %ld",model.saleCount];
    self.likeCountL.text = [NSString stringWithFormat:@"%ld",model.likeCount];
    self.commentCountL.text = [NSString stringWithFormat:@"%ld",model.commentCount];
    self.scanCountL.text = [NSString stringWithFormat:@"%ld",model.viewCount];
    [self.skillImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.cover]] placeholderImage:[UIImage imageNamed:@"kobe"]];
    self.serviceIntroduceL.text = [NSString stringWithFormat:@"服务介绍: %@",model.skillDesc];
    self.moneyL.text = [NSString stringWithFormat:@"%.2f元",model.price];
    if (model.isFavourite) {
        [self.collectionB setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    }else{
        [self.collectionB setBackgroundImage:[UIImage imageNamed:@"stars1"] forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    
    
    
}
- (IBAction)collection:(UIButton *)sender {
    
    NSString *status;
    if (_model.isFavourite) {
        status = @"0";
    }else{
        status = @"1";
    }
    sender.userInteractionEnabled = NO;
    [JGHTTPClient collectionSkillById:[NSString stringWithFormat:@"%ld",_model.skillId] status:status Success:^(id responseObject) {
        
        sender.userInteractionEnabled = YES;
        if ([responseObject[@"code"] integerValue] == 200) {
            _model.isFavourite = status.integerValue;
            if (_model.isFavourite) {
                [sender setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
            }else{
                [sender setBackgroundImage:[UIImage imageNamed:@"stars1"] forState:UIControlStateNormal];
            }
        }
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1.5f];
        sender.userInteractionEnabled = YES;
    }];
    
}


@end
