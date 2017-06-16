//
//  AnonymousCell.m
//  JianGuo
//
//  Created by apple on 17/6/5.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "AnonymousCell.h"

@implementation AnonymousCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    AnonymousCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)clickAnonymous:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"dui"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    }
}

@end
