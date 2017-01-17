//
//  ChatListCell.m
//  JianGuo
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "ChatListCell.h"

@implementation ChatListCell

- (void)awakeFromNib {
    
    self.leftIcon.layer.masksToBounds = YES;
    self.leftIcon.layer.cornerRadius = 20;
    self.redView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
