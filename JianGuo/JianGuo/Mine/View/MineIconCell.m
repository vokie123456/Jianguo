//
//  MineIconCell.m
//  JianGuo
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MineIconCell.h"

@implementation MineIconCell

- (void)awakeFromNib {
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    
}
- (IBAction)delete:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(deleteCell:)]) {
        [self.delegate deleteCell:sender];
    }
    
}

@end
