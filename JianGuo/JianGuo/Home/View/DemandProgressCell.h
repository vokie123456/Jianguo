//
//  DemandProgressCell.h
//  JianGuo
//
//  Created by apple on 17/2/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemandModel;
@interface DemandProgressCell : UITableViewCell

@property (nonatomic,strong) DemandModel *model;
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
