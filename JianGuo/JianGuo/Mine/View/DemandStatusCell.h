//
//  DemandStatusCell.h
//  JianGuo
//
//  Created by apple on 17/2/21.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemandStatusLogModel;
@interface DemandStatusCell : UITableViewCell

@property (nonatomic,strong) DemandStatusLogModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *stateL;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end
