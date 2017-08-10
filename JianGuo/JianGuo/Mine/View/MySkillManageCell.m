//
//  MySkillManageCell.m
//  JianGuo
//
//  Created by apple on 17/8/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MySkillManageCell.h"


@implementation MySkillManageCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    MySkillManageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

- (IBAction)chat:(id)sender {
}

- (IBAction)left:(id)sender {
}

- (IBAction)right:(id)sender {
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
