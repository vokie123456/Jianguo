//
//  MyDemandCell.m
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyDemandCell.h"
#import "DemandModel.h"
#import "UIImageView+WebCache.h"

@implementation MyDemandCell

-(void)setModel:(DemandModel *)model
{
    _model = model;
    self.nameL.text = model.title;
    self.moneyL.text = [NSString stringWithFormat:@"赏金 %@ 元",model.money];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.d_image] placeholderImage:[UIImage imageNamed:@"img_renwu"]];
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    MyDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

- (IBAction)getUsers:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(getUsers:)]) {
        [self.delegate getUsers:_model.id];
    }
    
}
- (IBAction)deleteDemand:(id)sender {
    
    
}

- (IBAction)offStoreDemand:(id)sender {
    
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
