//
//  ChatListCell.h
//  JianGuo
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *redView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@end
