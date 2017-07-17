//
//  EditProfileCell.m
//  JianGuo
//
//  Created by apple on 17/6/21.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "EditProfileCell.h"

@implementation EditProfileCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    EditProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
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
