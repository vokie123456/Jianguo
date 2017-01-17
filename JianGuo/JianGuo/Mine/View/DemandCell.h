//
//  DemandCell.h
//  JianGuo
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemandCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *hideNameBtn;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
