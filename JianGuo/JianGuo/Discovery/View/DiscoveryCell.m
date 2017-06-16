//
//  DiscoveryCell.m
//  JianGuo
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DiscoveryCell.h"

#import "DiscoveryModel.h"

#import "UIImageView+WebCache.h"

@implementation DiscoveryCell
{
    __weak IBOutlet UIImageView *iconView;
    __weak IBOutlet UILabel *typeL;
    __weak IBOutlet UILabel *titleL;
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    DiscoveryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(DiscoveryModel *)model
{
    titleL.text = model.title;
    typeL.text  = model.categoryName;
    [iconView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"kobe"] options:SDWebImageProgressiveDownload];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
