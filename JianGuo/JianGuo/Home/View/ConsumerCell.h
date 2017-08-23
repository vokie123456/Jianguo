//
//  ConsumerCell.h
//  JianGuo
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarView,ConsumerEvaluationsModel;

@interface ConsumerCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
/** model */
@property (nonatomic,strong) ConsumerEvaluationsModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *schoolL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *evaluateContentL;
@property (weak, nonatomic) IBOutlet UILabel *scoreL;
@property (weak, nonatomic) IBOutlet StarView *starView;

@end
