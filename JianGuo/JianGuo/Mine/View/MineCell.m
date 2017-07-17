//
//  MineCell.m
//  JianGuo
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MineCell.h"
#define ToTopInstance 7
#define CELLSUBVIEWHEIGHT 30

@implementation MineCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, ToTopInstance+5, 18, 18)];
//        self.iconView.image = [UIImage imageNamed:@"management"];
        [self.contentView addSubview:self.iconView];
        
        self.labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.right+15, ToTopInstance, 100, CELLSUBVIEWHEIGHT)];
        self.labelLeft.font = FONT(15);
        self.labelLeft.textColor = LIGHTGRAYTEXT;
        [self.contentView addSubview:self.labelLeft];
        
        self.labelRight = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-180, ToTopInstance, 150, CELLSUBVIEWHEIGHT)];
        self.labelRight.textAlignment = NSTextAlignmentRight;
        self.labelRight.textColor = LIGHTGRAYTEXT;
        [self.contentView addSubview:self.labelRight];
        
//        self.jiantouView = [[UIImageView alloc] initWithFrame:CGRectMake(self.labelRight.right+10, ToTopInstance+10, 8, 13)];
//        self.jiantouView.image = [UIImage imageNamed:@"yjiantou"];
//        [self.contentView addSubview:self.jiantouView];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(self.labelLeft.left, self.contentView.frame.size.height-1, SCREEN_W-20, 1)];
        self.lineView.backgroundColor = BACKCOLORGRAY;
        [self.contentView addSubview:self.lineView];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}



@end
