//
//  TitleCell.m
//  Carpool
//
//  Created by 王俊 on 15/4/1.
//  Copyright (c) 2015年 王俊. All rights reserved.
//

#import "TitleCell.h"

@implementation TitleCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
