//
//  JianliCell.h
//  JianGuo
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBox.h"

@interface JianliCell : UITableViewCell

@property (nonatomic,copy)  void(^seletIsStudentBlock)(NSString *);
#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UILabel *labelLeft;

@property (nonatomic,strong) UILabel *labelRight;

@property (nonatomic,strong) UIImageView *jiantouView;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIView *lineViewTop;

@property (nonatomic,strong) UITextField *rightTf;

@property (nonatomic,strong) CheckBox *selectYes;

@property (nonatomic,strong) CheckBox *selectNo;

@end
