//
//  MySkillManageCell.h
//  JianGuo
//
//  Created by apple on 17/8/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SkillManageDelegate <NSObject>

-(void)clickChat:(id)sender;
-(void)clickLeft:(id)sender;
-(void)clickRight:(id)sender;

@end

@interface MySkillManageCell : UITableViewCell



+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) id<SkillManageDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *skillView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIButton *chatB;
@property (weak, nonatomic) IBOutlet UIButton *leftB;
@property (weak, nonatomic) IBOutlet UIButton *rightB;

@end
