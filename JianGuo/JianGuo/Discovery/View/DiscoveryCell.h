//
//  DiscoveryCell.h
//  JianGuo
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiscoveryModel;
@interface DiscoveryCell : UITableViewCell

@property (nonatomic,strong) DiscoveryModel *model;
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
