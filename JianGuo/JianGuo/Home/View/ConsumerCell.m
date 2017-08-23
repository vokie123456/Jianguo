//
//  ConsumerCell.m
//  JianGuo
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "ConsumerCell.h"
#import "StarView.h"
#import "ConsumerEvaluationsModel.h"

#import "UIImageView+WebCache.h"

@implementation ConsumerCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    ConsumerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(ConsumerEvaluationsModel *)model
{
    _model = model;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
    _nameL.text = model.nickname;
    _schoolL.text = model.schoolName;
    _timeL.text = model.createTimeStr;
    _evaluateContentL.text = model.content;
    _starView.score = model.score;
    _scoreL.text = [NSString stringWithFormat:@"%.1f分",model.score];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
