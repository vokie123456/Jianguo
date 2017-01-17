//
//  MerCntHeaderView.h
//  JianGuo
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantModel.h"
#import "StarView.h"

@interface MerCntHeaderView : UIView

+(instancetype)aMerchantHeaderView;

@property (nonatomic,strong) MerchantModel *model;

@property (weak, nonatomic) IBOutlet UILabel *commonLabel;;
@property (weak, nonatomic) IBOutlet UILabel *merchentNameL;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *certifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIView *jobCountView;
@property (weak, nonatomic) IBOutlet UIView *peopleCountView;
@property (weak, nonatomic) IBOutlet UIView *funsCountView;
@property (weak, nonatomic) IBOutlet UILabel *jobCountL;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountL;
@property (weak, nonatomic) IBOutlet UILabel *funsCountL;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *merIntroduceView;
@property (weak, nonatomic) IBOutlet UIView *merContentView;
@property (weak, nonatomic) IBOutlet UILabel *merchantcontentL;
@property (weak, nonatomic) IBOutlet UILabel *jobCntNameL;
@property (weak, nonatomic) IBOutlet UILabel *peopleCntNameL;
@property (weak, nonatomic) IBOutlet UILabel *funsNameL;
@property (weak, nonatomic) IBOutlet UILabel *commonScoreL;
@property (weak, nonatomic) IBOutlet StarView *starView;

@end
