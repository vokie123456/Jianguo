//
//  SkillsExpertBoardCell.m
//  JianGuo
//
//  Created by apple on 17/7/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SkillsExpertBoardCell.h"
#import "UIImageView+WebCache.h"

@implementation SkillsExpertBoardCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(SkillExpertModel *)model
{
    _model = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.nameL.text = model.nickname.length?model.nickname:@"未填写";
    
}

@end
