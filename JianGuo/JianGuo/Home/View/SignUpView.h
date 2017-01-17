//
//  SignUpView.h
//  JianGuo
//
//  Created by apple on 16/3/19.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
#import "JianzhiModel.h"

@interface SignUpView : UIView
/**
 *  报名提示view
 */
+(instancetype)aSignUpView;

-(void)show;
@property (nonatomic,strong) JianzhiModel *jzModel;
@property (nonatomic,strong) DetailModel *model;
@property (nonatomic,copy) void(^signupBlock)();
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *workDateL;
@property (weak, nonatomic) IBOutlet UILabel *workTimeL;
@property (weak, nonatomic) IBOutlet UILabel *togetherAddL;
@property (weak, nonatomic) IBOutlet UILabel *togetherTimeL;
@property (weak, nonatomic) IBOutlet UILabel *genderL;
@property (weak, nonatomic) IBOutlet UILabel *moneyTypeL;
@property (weak, nonatomic) IBOutlet UILabel *otherL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *boardView;

@end
