//
//  StudentInfoCell.m
//  JianGuo
//
//  Created by apple on 16/11/23.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "StudentInfoCell.h"
#import "UITextView+placeholder.h"

@implementation StudentInfoCell

- (void)awakeFromNib {
    self.introduceTF.font = FONT(14);
    self.introduceTF.placeholder = @"输入您的简介更容易被录用哦!";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
