//
//  PaySelectCell.h
//  JianGuo
//
//  Created by apple on 17/2/18.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *payWayL;
@property (weak, nonatomic) IBOutlet UIImageView *selectView;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
