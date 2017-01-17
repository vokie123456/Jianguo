//
//  WorkDetailCell.h
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"

@protocol clickMoreBtnDelegate <NSObject>

@optional

-(void)clickMoreBtn:(UIButton *)btn content:(UILabel *)contentL require:(UILabel *)requireL;
@end

@interface WorkDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *workContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *workRequiredLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookMoreBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (nonatomic,strong) DetailModel *model;
@property (nonatomic,weak) id <clickMoreBtnDelegate> delegate;
@end
