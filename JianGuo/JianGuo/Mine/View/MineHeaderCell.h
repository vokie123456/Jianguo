//
//  MineHeaderCell.h
//  JianGuo
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignUsers;
@protocol ClickPersonDelegate <NSObject>

-(void)clickPerson:(NSString *)userId;

@end

@interface MineHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *unLoginL;

@property (nonatomic,strong) SignUsers *model;
@property (nonatomic,weak) id <ClickPersonDelegate> delegate;
@property (nonatomic,strong) NSString *data;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *ageBtn;
@property (weak, nonatomic) IBOutlet UILabel *starL;

@end
