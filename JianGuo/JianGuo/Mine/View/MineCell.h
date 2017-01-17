//
//  MineCell.h
//  JianGuo
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCell : UITableViewCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UILabel *labelLeft;

@property (nonatomic,strong) UILabel *labelRight;

@property (nonatomic,strong) UIImageView *jiantouView;

@property (nonatomic,strong) UIView *lineView;

@end
