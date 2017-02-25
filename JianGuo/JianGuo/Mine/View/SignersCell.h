//
//  SignersCell.h
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SignUsers;

@protocol AgreeUserSomeOneDelegate <NSObject>

-(void)userSomeOne:(NSString *)userId status:(NSString *)status;

@end

@interface SignersCell : UITableViewCell

@property (nonatomic,copy) NSString *demandId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCons;

@property (nonatomic,weak) id<AgreeUserSomeOneDelegate> delegate;
@property (nonatomic,strong) SignUsers *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *ageBtn;
@property (weak, nonatomic) IBOutlet UILabel *starL;
@property (weak, nonatomic) IBOutlet UILabel *stateL;


@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
