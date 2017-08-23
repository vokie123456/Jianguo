//
//  AddressReadonlyCell.h
//  JianGuo
//
//  Created by apple on 17/8/16.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;

@interface AddressReadonlyCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;

/** model */
@property (nonatomic,strong) AddressModel *model;


@end
