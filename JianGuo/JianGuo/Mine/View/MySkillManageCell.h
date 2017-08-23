//
//  MySkillManageCell.h
//  JianGuo
//
//  Created by apple on 17/8/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MySkillListModel,MyBuySkillListModel;
@protocol MySkillManageDelegate <NSObject>

-(void)clickChat:(id)sender model:(id)model;
-(void)clickLeft:(id)sender model:(id)model;
-(void)clickRight:(id)sender model:(id)model;

@end


@interface MySkillManageCell : UITableViewCell



+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) id<MySkillManageDelegate> delegate;

/** 我的model */
@property (nonatomic,strong) MySkillListModel *model;
/** 我购买的model */
@property (nonatomic,strong) MyBuySkillListModel *buyModel;

@property (weak, nonatomic) IBOutlet UIImageView *skillView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIButton *chatB;
@property (weak, nonatomic) IBOutlet UIButton *leftB;
@property (weak, nonatomic) IBOutlet UIButton *rightB;
@property (weak, nonatomic) IBOutlet UIView *alertBottomView;

@end
