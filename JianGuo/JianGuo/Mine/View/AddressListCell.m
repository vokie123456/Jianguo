//
//  AddressListCell.m
//  JianGuo
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "AddressListCell.h"

#import "AddressModel.h"

#import "QLAlertView.h"

@implementation AddressListCell
{
    __weak IBOutlet UILabel *nameL;
    
    __weak IBOutlet UILabel *telL;
    __weak IBOutlet UILabel *addressL;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(AddressModel *)model
{
    _model = model;
    nameL.text = model.consignee;
    telL.text = model.mobile;
    addressL.text = model.location;
    
    if (model.isDefault) {
        
    }else{
        
    }
    
}


- (void)awakeFromNib {
    
    addressL.text = @"我就是自适应的内容的大小,具体地址该怎么显示啊看见的回复开始交电话费可是对方啊看见的回复卡电话费阿卡多缴费卡机";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)eidt:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(editAddress:)]) {
        [self.delegate editAddress:_model];
    }
    
}
- (IBAction)delete:(id)sender {
    
    [QLAlertView showAlertTittle:@"确定删除地址吗?" message:nil isOnlySureBtn:NO compeletBlock:^{
        
        if ([self.delegate respondsToSelector:@selector(deleteAddress:)]) {
            [self.delegate deleteAddress:_model];
        }
    }];
}
- (IBAction)setDefaultAddress:(id)sender {
    
    
}

@end
