//
//  LabelCell.m
//  JGBuss
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LabelCell.h"

@implementation LabelCell

-(void)prepareForReuse
{
    self.contentL.backgroundColor = WHITECOLOR;
}

- (void)awakeFromNib {
    
//    self.contentL.layer.cornerRadius = 27/2;
//    self.contentL.layer.masksToBounds = YES;
    
}


-(void)layoutMarginsDidChange
{
//    self.contentL.layer.cornerRadius = 35/2;
//    self.contentL.layer.masksToBounds = YES;
}

@end
