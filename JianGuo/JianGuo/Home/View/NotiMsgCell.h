//
//  NotiMsgCell.h
//  JianGuo
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotiNewsModel.h"

@interface NotiMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet UILabel *remarkL;
@property (weak, nonatomic) IBOutlet UIView *bgView;





@property (nonatomic,strong) NotiNewsModel *model;

@end
