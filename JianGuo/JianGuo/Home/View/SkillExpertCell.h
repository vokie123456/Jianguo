//
//  SkillExpertCell.h
//  JianGuo
//
//  Created by apple on 17/7/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SkillExpertBoardDelegate <NSObject>

-(void)clickPersonIcon:(id)model;

@end

@interface SkillExpertCell : UITableViewCell

/** 委托 */
@property (nonatomic,weak) id <SkillExpertBoardDelegate> delegate;
/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end
