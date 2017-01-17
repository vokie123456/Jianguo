//
//  DetailHeaderCell.h
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
@interface DetailHeaderCell : UITableViewCell

@property (nonatomic,strong) DetailModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *partTittleL;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountL;
@property (weak, nonatomic) IBOutlet UILabel *issueTimeL;

@end
