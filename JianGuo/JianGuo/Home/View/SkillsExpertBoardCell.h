//
//  SkillsExpertBoardCell.h
//  JianGuo
//
//  Created by apple on 17/7/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SkillExpertModel.h"

@interface SkillsExpertBoardCell : UICollectionViewCell

/** 达人模型 */
@property (nonatomic,strong) SkillExpertModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *followB;

@end
