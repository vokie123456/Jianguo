//
//  EditProfileCell.h
//  JianGuo
//
//  Created by apple on 17/6/21.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileCell : UITableViewCell


+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *leftL;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *rightL;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
