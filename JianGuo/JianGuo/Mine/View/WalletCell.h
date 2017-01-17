//
//  WalletCell.h
//  JianGuo
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyRecordModel.h"

@interface WalletCell : UITableViewCell
@property (nonatomic,strong) MoneyRecordModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *tittleL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *worKDateL;
@property (weak, nonatomic) IBOutlet UILabel *remarkL;

@end
