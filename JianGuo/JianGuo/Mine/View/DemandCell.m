//
//  DemandCell.m
//  JianGuo
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandCell.h"

@implementation DemandCell



+(instancetype)cellWithTableView:(UITableView *)tableView
{
    DemandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"demandCell"];
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
- (IBAction)hideName:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"buttonn"] forState:UIControlStateNormal];
    }else
        [sender setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    
}

@end
