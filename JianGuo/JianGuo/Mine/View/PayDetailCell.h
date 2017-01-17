//
//  PayDetailCell.h
//  JianGuo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyRecordModel.h"

@interface PayDetailCell : UITableViewCell
@property (nonatomic,strong) MoneyRecordModel *model;

@property (weak, nonatomic) IBOutlet UILabel *exportTypeL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *drawCashL;


@end
