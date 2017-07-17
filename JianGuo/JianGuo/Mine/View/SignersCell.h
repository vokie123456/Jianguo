//
//  SignersCell.h
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SignUsers;
@class SignersCell;
@protocol AgreeUserSomeOneDelegate <NSObject>

-(void)userSomeOne:(NSString *)userId status:(NSString *)status cell:(SignersCell *)cell;
-(void)refreshData;
-(void)chatUser:(NSString *)userId;
-(void)clickIcon:(NSString *)userId;

@end

@interface SignersCell : UITableViewCell

@property (nonatomic,copy) NSString *demandId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthCons;

@property (nonatomic,weak) id<AgreeUserSomeOneDelegate> delegate;
@property (nonatomic,strong) SignUsers *model;
@property (weak, nonatomic) IBOutlet UIButton *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *schoolL;

@property (weak, nonatomic) IBOutlet UIImageView *genderView;

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;


+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
