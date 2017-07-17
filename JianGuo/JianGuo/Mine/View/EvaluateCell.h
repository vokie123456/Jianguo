//
//  EvaluateCell.h
//  JianGuo
//
//  Created by apple on 17/6/21.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvaluateModel;
@interface EvaluateCell : UITableViewCell

@property (nonatomic,strong) EvaluateModel *model;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *commentTypeL;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *schoolL;
@property (weak, nonatomic) IBOutlet UILabel *commentContentL;
@property (weak, nonatomic) IBOutlet UILabel *demandTitleL;
@property (weak, nonatomic) IBOutlet UILabel *demandDesL;
@property (weak, nonatomic) IBOutlet UILabel *demandTypeL;

@end
