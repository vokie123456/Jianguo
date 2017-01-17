//
//  DemandDetailCell.m
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandDetailCell.h"
static NSString *identifier = @"DemandDetailCell";
@implementation DemandDetailCell

-(void)prepareForReuse
{
    self.rightL.text = nil;
    self.rightL.textColor = LIGHTGRAYTEXT;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    DemandDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
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
