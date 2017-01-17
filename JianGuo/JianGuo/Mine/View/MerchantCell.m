//
//  MerchantCell.m
//  JianGuo
//
//  Created by apple on 16/3/25.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MerchantCell.h"
#import "UIImageView+WebCache.h"

@implementation MerchantCell

- (void)awakeFromNib {
    
}

-(void)setModel:(MerchantModel *)model
{
    _model = model;
    
    self.compactNameL.text = model.name;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.name_image] placeholderImage:[UIImage imageNamed:@"img_renwu"]];
    self.beingCountL.text = [NSString stringWithFormat:@"%@个在招职位",model.post];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
