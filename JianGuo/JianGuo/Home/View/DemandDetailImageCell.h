//
//  DemandDetailImageCell.h
//  JianGuo
//
//  Created by apple on 17/6/12.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemandDetailImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
