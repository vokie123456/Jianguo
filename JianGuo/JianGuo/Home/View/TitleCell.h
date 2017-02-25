//
//  TitleCell.h
//  Carpool
//
//  Created by 王俊 on 15/4/1.
//  Copyright (c) 2015年 王俊. All rights reserved.
//

#import "UITableViewCellEx.h"
#define kTitleCellId     (@"TitleCell")
#define kTitleCellHeight (50)

@interface TitleCell : UITableViewCellEx

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@end
