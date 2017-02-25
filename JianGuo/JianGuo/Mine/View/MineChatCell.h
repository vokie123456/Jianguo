//
//  MineChatCell.h
//  JianGuo
//
//  Created by apple on 17/2/23.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineChatCell : UITableViewCell


+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *leftL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@end
