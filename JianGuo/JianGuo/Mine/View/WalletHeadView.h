//
//  WalletHeadView.h
//  JianGuo
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletModel.h"


@interface WalletHeadView : UIView

+(instancetype)aWalletHeadView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UIImageView *horiLineView;
@property (weak, nonatomic) IBOutlet UIImageView *verLinrView;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet UIButton *giveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;

@property (nonatomic,strong) WalletModel *model;
@end
