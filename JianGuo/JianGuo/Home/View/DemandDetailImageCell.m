//
//  DemandDetailImageCell.m
//  JianGuo
//
//  Created by apple on 17/6/12.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandDetailImageCell.h"

@implementation DemandDetailImageCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    DemandDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    // Initialization code
    self.iconView.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
