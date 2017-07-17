//
//  TextFieldCell.m
//  driverapp_iOS
//
//  Created by 江海天 on 15/7/23.
//  Copyright (c) 2015年 dasmaster. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell

+ (TextFieldCell *)aTextFieldCell
{
	TextFieldCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:nil options:nil] lastObject];
	return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)textChanged:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textChanged:)]) {
        [self.delegate textChanged:textField];
    }
}


@end
