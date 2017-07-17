//
//  MyDemandToFinishCell.h
//  JianGuo
//
//  Created by apple on 17/6/28.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemandSignModel;

@interface MySignDemandCell : UITableViewCell


@property (nonatomic,strong) DemandSignModel *model;

@property (nonatomic,assign) BOOL isSelfSign;


+(instancetype)cellWithTableView:(UITableView *)tableView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLimitHeightCons;
@property (weak, nonatomic) IBOutlet UILabel * titleL;
@property (weak, nonatomic) IBOutlet UILabel * moneyL;
@property (weak, nonatomic) IBOutlet UILabel * timeL;
@property (weak, nonatomic) IBOutlet UILabel * typeL;
@property (weak, nonatomic) IBOutlet UILabel *descriptionL;
@property (weak, nonatomic) IBOutlet UIButton *leftB;
@property (weak, nonatomic) IBOutlet UIButton *rightB;

@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UILabel *timeLimitL;

@end
