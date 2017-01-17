//
//  CheckBox.m
//  JianGuo
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "CheckBox.h"
#import "JianliCell.h"
@interface CheckBox()


@end
@implementation CheckBox


+(instancetype)aCheckBox
{
    CheckBox *checkBox = [[[NSBundle mainBundle] loadNibNamed:@"CheckBox" owner:@"JianliCell" options:nil]lastObject];
    return checkBox;
}

@end
