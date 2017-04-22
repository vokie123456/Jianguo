//
//  BillCell.h
//  JianGuo
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoneyRecordModel;
@interface BillCell : UITableViewCell

@property (nonatomic,strong) MoneyRecordModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConst;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
