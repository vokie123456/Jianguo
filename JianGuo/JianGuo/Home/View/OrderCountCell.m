//
//  OrderCountCell.m
//  JianGuo
//
//  Created by apple on 17/7/28.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "OrderCountCell.h"

@implementation OrderCountCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    OrderCountCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}
- (IBAction)reduce:(id)sender {
    
    if (self.countTF.text.integerValue>1) {
        NSInteger count = self.countTF.text.integerValue-1;
        self.countTF.text = [NSString stringWithFormat:@"%ld",count];
        if ([self.delegate respondsToSelector:@selector(countChanged:)]) {
            [self.delegate countChanged:self.countTF.text];
        }
    }
    
}

- (IBAction)add:(id)sender {
    
    if (self.countTF.text.integerValue<99) {
        NSInteger count = self.countTF.text.integerValue+1;
        self.countTF.text = [NSString stringWithFormat:@"%ld",count];
        if ([self.delegate respondsToSelector:@selector(countChanged:)]) {
            [self.delegate countChanged:self.countTF.text];
        }
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
