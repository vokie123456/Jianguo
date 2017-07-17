//
//  WorkDetailCell.m
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "WorkDetailCell.h"
#import "UIView+AlertView.h"

@implementation WorkDetailCell

- (void)awakeFromNib {
    CGRect rect1 = self.topLineView.frame;
    rect1.size.width = SCREEN_W;
    self.topLineView.frame = rect1;
    
    CGRect rect2 = self.bottomLineView.frame;
    rect2.size.width = SCREEN_W;
    self.bottomLineView.frame = rect2;
}

-(void)setModel:(DetailModel *)model
{
    _model = model;
    CGRect rectCon = self.workContentLabel.frame;
    CGFloat labelW;
    if (SCREEN_W == 320) {
        labelW = 227;
    }else if (SCREEN_W == 375){
        labelW = 280;
    }else if (SCREEN_W == 414){
        labelW = 320;
    }
    CGSize sizeCon = [model.content?model.content:@"未填写" boundingRectWithSize:CGSizeMake(labelW, 70) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(14)} context:nil].size;
    rectCon.size.width = sizeCon.width;
    rectCon.size.height = sizeCon.height;
    self.workContentLabel.frame = rectCon;
    
    self.workContentLabel.text = model.content;
    
    CGRect rectReq = self.workRequiredLabel.frame;
    CGSize sizeReq = [model.require?model.require:@"未填写" boundingRectWithSize:CGSizeMake(labelW, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(14)} context:nil].size;
    rectReq.size.width = sizeReq.width;
    rectReq.size.height = sizeReq.height;
    self.workRequiredLabel.frame = rectReq;
    
    self.workRequiredLabel.text = model.require;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)toseeMore:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickMoreBtn:content:require:)]) {
        [self.delegate clickMoreBtn:sender content:self.workContentLabel require:self.workRequiredLabel];
    }
    
    
}

@end
