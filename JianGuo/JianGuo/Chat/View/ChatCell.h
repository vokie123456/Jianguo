//
//  ChatCell.h
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell

@property (nonatomic,strong) UIImageView *rightIcon;
@property (nonatomic,strong) UIImageView *leftIcon;
@property (nonatomic, strong) UIImageView* leftBubble;
@property (nonatomic, strong) UIImageView* rightBubble;
@property (nonatomic, strong) UILabel* leftLabel;
@property (nonatomic, strong) UILabel* rightLabel;
@property (nonatomic, strong) UILabel* timeLabel;


@end
