//
//  OrderTitleCell.h
//  JianGuo
//
//  Created by apple on 17/7/28.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTitleCell : UITableViewCell


+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@end
