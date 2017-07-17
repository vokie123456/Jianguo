//
//  MyDemandCell.h
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DemandPostModel;

@protocol MyDemandClickDelegate <NSObject>

-(void)getUsers:(NSString *)demandId;
-(void)deleteDemand:(NSString *)demandId;
-(void)offStoreDemand:(NSString *)demandId;
-(void)refreshData;

@end

@interface MyDemandCell : UITableViewCell

@property (nonatomic,strong) DemandPostModel *model;

@property (nonatomic,assign) BOOL isSelfSign;

@property (nonatomic,weak) id<MyDemandClickDelegate> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLimitHeightCons;
@property (weak, nonatomic) IBOutlet UILabel * titleL;
@property (weak, nonatomic) IBOutlet UILabel * moneyL;
@property (weak, nonatomic) IBOutlet UILabel * timeL;
@property (weak, nonatomic) IBOutlet UILabel * typeL;
@property (weak, nonatomic) IBOutlet UILabel *descriptionL;
@property (weak, nonatomic) IBOutlet UIButton *leftB;
@property (weak, nonatomic) IBOutlet UIButton *rightB;

@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UILabel *timeLimitL;

@end
