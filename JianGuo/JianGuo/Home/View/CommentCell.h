//
//  CommentCell.h
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTTAttributedLabel;
@class CommentModel;
@interface CommentCell : UITableViewCell
@property (nonatomic,strong) CommentModel *model;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
