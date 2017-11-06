//
//  MyBuyManageCell.h
//  JianGuo
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBuySkillListModel.h"

@protocol MyBuySkillManageDelegate <NSObject>

-(void)clickChat:(id)sender model:(id)model;
-(void)clickLeft:(id)sender model:(id)model;
-(void)clickRight:(id)sender model:(id)model;

@end

@interface MyBuyManageCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

/** 我购买的model */
@property (nonatomic,strong) MyBuySkillListModel *buyModel;

@property (nonatomic,weak) id<MyBuySkillManageDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *skillView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIButton *chatB;
@property (weak, nonatomic) IBOutlet UIButton *leftB;
@property (weak, nonatomic) IBOutlet UIButton *rightB;
@property (weak, nonatomic) IBOutlet UILabel *stateL;

@end
