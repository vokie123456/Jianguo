//
//  ChatCell.m
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (void)awakeFromNib {
    //气泡素材
    UIImage* leftImage = [UIImage imageNamed:@"message_receiver_background_normal"];
    UIImage* rightImage = [UIImage imageNamed:@"message_sender_background_highlight"];
    leftImage = [leftImage stretchableImageWithLeftCapWidth:30 topCapHeight:35];
    rightImage = [rightImage stretchableImageWithLeftCapWidth:30 topCapHeight:35];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W/2-40, 0, 80, 15)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.backgroundColor = LIGHTGRAYTEXT;
    timeLabel.textColor = WHITECOLOR;
    timeLabel.font = FONT(10);
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    
    //左边头像
    self.leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
    self.leftIcon.layer.cornerRadius = 16;
    self.leftIcon.layer.masksToBounds = YES;
    self.leftIcon.backgroundColor = YELLOWCOLOR;
    [self.contentView addSubview:self.leftIcon];
    //左边气泡
    self.leftBubble = [[UIImageView alloc] initWithFrame:CGRectMake(self.leftIcon.right+5, 5, 10, 10)];
    self.leftBubble.image = leftImage;
    [self.contentView addSubview:self.leftBubble];
    
    //右边头像
    self.rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-45, 10, 35, 35)];
    self.rightIcon.layer.cornerRadius = 16;
    self.rightIcon.layer.masksToBounds = YES;
    self.rightIcon.backgroundColor = BLUECOLOR;
    [self.contentView addSubview:self.rightIcon];
    
    //右边气泡
    self.rightBubble = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-80, 5, 10, 10)];
    self.rightBubble.image = rightImage;
    [self.contentView addSubview:self.rightBubble];
    
    //左边label
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 10, 10)];
    self.leftLabel.numberOfLines = 0;
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    self.leftLabel.font = [UIFont systemFontOfSize:15.0];
    [self.leftBubble addSubview:self.leftLabel];
    
    //右边label
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 10, 10)];
    self.rightLabel.numberOfLines = 0;
    self.rightLabel.font = [UIFont systemFontOfSize:15.0];
    [self.rightBubble addSubview:self.rightLabel];

}


@end
