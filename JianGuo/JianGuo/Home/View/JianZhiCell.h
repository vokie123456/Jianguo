//
//  JianZhiCell.h
//  JianGuo
//
//  Created by apple on 16/3/12.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawAnimationView.h"
@class JianzhiModel;
@interface JianZhiCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UILabel *leftCountL;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeView;
@property (weak, nonatomic) IBOutlet UIImageView *dateView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *partTittleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet DrawAnimationView *animationView;
@property (nonatomic,strong) JianzhiModel *model;

@end
