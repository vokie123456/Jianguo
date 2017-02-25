//
//  MyDemandCell.h
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DemandModel;

@protocol MyDemandClickDelegate <NSObject>

-(void)getUsers:(NSString *)demandId;
-(void)deleteDemand:(NSString *)demandId;
-(void)offStoreDemand:(NSString *)demandId;

@end

@interface MyDemandCell : UITableViewCell

@property (nonatomic,strong) DemandModel *model;

@property (nonatomic,assign) BOOL isSelfSign;

@property (nonatomic,weak) id<MyDemandClickDelegate> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UIButton *usersBtn;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *stateL;

@end
