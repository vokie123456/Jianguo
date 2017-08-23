//
//  AddressReadonlyCell.m
//  JianGuo
//
//  Created by apple on 17/8/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "AddressReadonlyCell.h"
#import "AddressModel.h"

@implementation AddressReadonlyCell

{
    __weak IBOutlet UILabel *nameL;
    
    __weak IBOutlet UILabel *telL;
    __weak IBOutlet UILabel *addressL;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    AddressReadonlyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(AddressModel *)model
{
    _model = model;
    nameL.text = [NSString stringWithFormat:@"联系人: %@",model.consignee];
    telL.text = model.mobile;
    addressL.text = model.location;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
