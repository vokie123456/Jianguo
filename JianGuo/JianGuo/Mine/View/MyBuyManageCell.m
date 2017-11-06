//
//  MyBuyManageCell.m
//  JianGuo
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyBuyManageCell.h"

#import "UIImageView+WebCache.h"
#import "AlertView.h"

@implementation MyBuyManageCell


-(void)prepareForReuse
{
    [super prepareForReuse];
    self.leftB.hidden = NO;
    self.rightB.hidden = NO;
}

-(void)setBuyModel:(MyBuySkillListModel *)buyModel
{
    _buyModel = buyModel;
    [self.skillView sd_setImageWithURL:[NSURL URLWithString:buyModel.cover] placeholderImage:[UIImage imageNamed:@"kobe"]];
    self.titleL.text = buyModel.title;
    self.nameL.text = [NSString stringWithFormat:@"购买者: %@", USER.nickname];
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    MyBuyManageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

@end
