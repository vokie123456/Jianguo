//
//  MineChatCell.m
//  JianGuo
//
//  Created by apple on 17/2/23.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MineChatCell.h"

@implementation MineChatCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    MineChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
