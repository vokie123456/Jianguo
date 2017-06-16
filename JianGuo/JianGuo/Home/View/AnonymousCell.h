//
//  AnonymousCell.h
//  JianGuo
//
//  Created by apple on 17/6/5.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnonymousCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIButton *selectB;

@end
