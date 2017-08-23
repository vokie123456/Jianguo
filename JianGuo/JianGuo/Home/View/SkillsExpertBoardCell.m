//
//  SkillsExpertBoardCell.m
//  JianGuo
//
//  Created by apple on 17/7/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SkillsExpertBoardCell.h"
#import "UIImageView+WebCache.h"
#import "JGHTTPClient+Demand.h"

@implementation SkillsExpertBoardCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(SkillExpertModel *)model
{
    _model = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.nameL.text = model.masterTitle.length?model.masterTitle:@"未填写";
    [self.followB setTitle:model.isFollow?@"已关注":@"+关注" forState:UIControlStateNormal];
    
}
- (IBAction)following:(UIButton *)sender {
    
    NSString *status;
    if (_model.isFollow) {
        status = @"0";
        return;
    }else{
        status = @"1";
    }
    
    [JGHTTPClient followUserWithUserId:[NSString stringWithFormat:@"%ld",_model.uid] status:status Success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [self.followB setTitle:status.integerValue?@"已关注":@"+关注" forState:UIControlStateNormal];
            _model.isFollow = status.integerValue;
        }else{
            [self showAlertViewWithText:responseObject[@"message"] duration:1.5f];
        }
        
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1.5];
    }];
    
}

@end
