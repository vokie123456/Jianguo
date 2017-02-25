//
//  MySignDemandCell.m
//  JianGuo
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MySignDemandCell.h"
#import "DemandModel.h"
#import "UIImageView+WebCache.h"

@interface MySignDemandCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@end

@implementation MySignDemandCell

-(void)setModel:(DemandModel *)model
{
    _model = model;
    self.titleL.text = model.title?model.title:@"未填写";
    self.moneyL.text = [NSString stringWithFormat:@"赏金 %@ 元",model.money];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.d_image] placeholderImage:[UIImage imageNamed:@"img_renwu"]];
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    MySignDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
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
