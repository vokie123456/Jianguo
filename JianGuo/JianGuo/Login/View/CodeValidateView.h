//
//  CodeValidateView.h
//  JianGuo
//
//  Created by apple on 17/5/2.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeValidateView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;
@property (weak, nonatomic) IBOutlet UITextField *textF;

+(instancetype)aValidateViewCompleteBlock:(void(^)(NSString *code))completeBlock withTel:(NSString *)tel type:(NSString *)type;

-(void)show;

@end
