//
//  DemandListCell.h
//  JianGuo
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemandModel;
@protocol ClickLikeBtnDelegate <NSObject>

-(void)clickLike:(DemandModel *)model;
-(void)clickIcon:(NSString *)userId;
-(void)signDemand:(NSString *)userId;

@end

@class DemandModel;
@interface DemandListCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) id <ClickLikeBtnDelegate>delegate;

@property (nonatomic,copy) void(^sendCellIndex)(id object);
@property (nonatomic,strong) DemandModel *model;

@end
