//
//  SkillManageCell.m
//  JianGuo
//
//  Created by apple on 17/8/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SkillManageCell.h"

#import "SkillListModel.h"

#import "JGHTTPClient+Skill.h"

#import "UIImageView+WebCache.h"
#import "QLAlertView.h"

@implementation SkillManageCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    SkillManageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
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
    self.timeSchoolL.text = [NSString stringWithFormat:@"%@|%@",model.createTimeStr,model.schoolName.length?model.schoolName:model.cityName];
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
    
    if (model.status) {
        self.stateL.text = @"已暂停接单";
        self.stateL.textColor = [UIColor redColor];
        [self.settingB setTitle:@"恢复接单" forState:UIControlStateNormal];
    }else if (model.status == 0){
        self.stateL.text = @"正常接单中";
        self.stateL.textColor = GreenColor;
        [self.settingB setTitle:@"暂停接单" forState:UIControlStateNormal];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)manageSkill:(UIButton *)sender {
    
    [QLAlertView showAlertTittle:@"确认执行此操作?" message:nil isOnlySureBtn:NO compeletBlock:^{
    
        NSString *status;
        if (_model.status) {
            status = @"0";
        }else{
            status = @"1";
        }
        sender.userInteractionEnabled = NO;
        
        JGSVPROGRESSLOAD(@"请求中...");
        [JGHTTPClient changeSkillStatusById:[NSString stringWithFormat:@"%ld",_model.skillId] status:status Success:^(id responseObject) {
            
            [SVProgressHUD dismiss];
            sender.userInteractionEnabled = YES;
            [self showAlertViewWithText:responseObject[@"message"] duration:1.5f];
            if ([responseObject[@"code"] integerValue] == 200) {
                _model.status = status.integerValue;
                if (_model.status) {
                    self.stateL.text = @"已暂停接单";
                    self.stateL.textColor = [UIColor redColor];
                    [sender setTitle:@"恢复接单" forState:UIControlStateNormal];
                }else{
                    self.stateL.text = @"正常接单中";
                    self.stateL.textColor = GreenColor;
                    [sender setTitle:@"暂停接单" forState:UIControlStateNormal];
                }
            }
        } failure:^(NSError *error) {
            
            [SVProgressHUD dismiss];
            [self showAlertViewWithText:NETERROETEXT duration:2.f];
            sender.userInteractionEnabled = YES;
        }];
        
    }];
    
    
    
}

@end
