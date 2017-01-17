//
//  BindCell.m
//  JianGuo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "BindCell.h"

@implementation BindCell

- (void)awakeFromNib {
    self.selectView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickBtnOfCell:)]) {
        [self.delegate clickBtnOfCell:sender];
    }
    
}
- (IBAction)unBind:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickUnBandBtn:)]) {
        [self.delegate clickUnBandBtn:sender];
    }
    
}

@end
