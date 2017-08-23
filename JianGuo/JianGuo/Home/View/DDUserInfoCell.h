//
//  DDUserInfoCell.h
//  JianGuo
//
//  Created by apple on 17/6/13.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemandDetailModel,SkillDetailModel;
@interface DDUserInfoCell : UITableViewCell
@property (nonatomic,strong) DemandDetailModel *detailModel;
@property (nonatomic,strong) SkillDetailModel *skillDetailM;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *schoolL;
@property (weak, nonatomic) IBOutlet UIButton *followB;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UIImageView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@end
