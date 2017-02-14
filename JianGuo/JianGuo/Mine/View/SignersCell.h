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

-(void)userSomeOne:(NSString *)userId;

@end

@interface SignersCell : UITableViewCell


@property (nonatomic,weak) id<AgreeUserSomeOneDelegate> delegate;
@property (nonatomic,strong) SignUsers *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *schoolL;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
