//
//  DemandDetailCell.h
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemandDetailCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *leftL;
@property (weak, nonatomic) IBOutlet UILabel *rightL;

@end
