//
//  ConsumerCell.m
//  JianGuo
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "ConsumerCell.h"
#import "StarView.h"

@implementation ConsumerCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    ConsumerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
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
