//
//  SkillsCell.h
//  JianGuo
//
//  Created by apple on 17/7/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
@class SkillListModel;

@interface SkillsCell : UITableViewCell


+(instancetype)cellWithTableView:(UITableView *)tableView;

/** 技能模型 */
@property (nonatomic,strong) SkillListModel *model;
@property (weak, nonatomic) IBOutlet UILabel *skillL;
@property (weak, nonatomic) IBOutlet UIButton *collectionB;
@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *serviceIntroduceL;
@property (weak, nonatomic) IBOutlet UILabel *userIntroduceL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *saleCountL;
@property (weak, nonatomic) IBOutlet UILabel *timeSchoolL;
@property (weak, nonatomic) IBOutlet UILabel *likeCountL;
@property (weak, nonatomic) IBOutlet UILabel *commentCountL;
@property (weak, nonatomic) IBOutlet UILabel *scanCountL;
@property (weak, nonatomic) IBOutlet StarView *starView;


@end
