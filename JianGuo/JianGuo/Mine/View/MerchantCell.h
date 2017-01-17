//
//  MerchantCell.h
//  JianGuo
//
//  Created by apple on 16/3/25.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantModel.h"

@interface MerchantCell : UITableViewCell

@property (nonatomic,strong) MerchantModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *compactNameL;
@property (weak, nonatomic) IBOutlet UILabel *beingCountL;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
