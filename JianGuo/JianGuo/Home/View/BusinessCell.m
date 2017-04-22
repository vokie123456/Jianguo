//
//  BusinessCell.m
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+WebCache.h"
#import "DetailModel.h"

@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(DetailModel *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.head_img_url] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.nameLb.text = model.contact_name?model.contact_name:@"未填写";
    
    if ([model.contact_name containsString:@"合作商家"]||model.permissions.integerValue==1||model.permissions.integerValue == 2) {
        self.renzhengView.hidden = YES;
        self.beingCountL.hidden = NO;
    }else{
        self.renzhengView.hidden = NO;
        self.beingCountL.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)call:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(callPhoneNum:)]) {
        [self.delegate callPhoneNum:_model.tel];
    }
    
    
}

@end
