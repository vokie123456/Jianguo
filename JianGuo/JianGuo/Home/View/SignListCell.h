//
//  SignListCell.h
//  JianGuo
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JianzhiModel.h"
@protocol ClickCancelBtnDeleagte <NSObject>

-(void)clickLeftBtn:(UIButton *)btn;
-(void)clickRightBtn:(UIButton *)btn;
@end
@interface SignListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *stateImgView;
@property (weak, nonatomic) IBOutlet UIImageView *stateRightView;
@property (nonatomic,strong) JianzhiModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *tittleL;
@property (weak, nonatomic) IBOutlet UILabel *workDateL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *remarkL;

@property (nonatomic,weak) id <ClickCancelBtnDeleagte> delegate;
-(void)updateConstraint;



@end
