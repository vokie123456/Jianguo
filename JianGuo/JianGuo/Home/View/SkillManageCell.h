//
//  SkillManageCell.h
//  JianGuo
//
//  Created by apple on 17/8/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"

@protocol SkillManageCellDelegate <NSObject>

-(void)reconfirmWithSkillId:(NSString *)skillId;

@end

@class SkillListModel;
@interface SkillManageCell : UITableViewCell

/** 代理 */
@property (nonatomic,weak) id <SkillManageCellDelegate> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView;

/** 技能模型 */
@property (nonatomic,strong) SkillListModel *model;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UILabel *stateHeaderL;
@property (weak, nonatomic) IBOutlet UIButton *settingB;
@property (weak, nonatomic) IBOutlet UIButton *reconfirmB;

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
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end
