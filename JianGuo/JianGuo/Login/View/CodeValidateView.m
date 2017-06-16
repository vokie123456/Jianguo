//
//  CodeValidateView.m
//  JianGuo
//
//  Created by apple on 17/5/2.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "CodeValidateView.h"
#import "JGHTTPClient+LoginOrRegister.h"

#import "NSObject+HudView.h"

#import <UIImageView+WebCache.h>
#import <IQKeyboardManager.h>
@interface CodeValidateView()<UITextFieldDelegate>
{
    
    __weak IBOutlet UIView *bgView;
    void (^completeBlock)(NSString *code);
    NSString *tel;
    NSString *type;

}

@end
@implementation CodeValidateView


+(instancetype)aValidateViewCompleteBlock:(void(^)(NSString *code))completeBlock withTel:(NSString *)tel type:(NSString *)type
{
    CodeValidateView *view = [[[NSBundle mainBundle] loadNibNamed:@"CodeValidateView" owner:nil options:nil]lastObject];
    
    view -> tel = tel;
    
    view -> type = type;
    
    view -> completeBlock = completeBlock;

    return view;
    
}

-(void)show
{
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [self sendSubviewToBack:self.textF];
    self.textF.delegate = self;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0f];
    self.frame = APPLICATION.keyWindow.bounds;
    [APPLICATION.keyWindow addSubview:self];
    [self loadValidateView];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8f];
    } completion:^(BOOL finished) {
        [self.textF becomeFirstResponder];
    }];
}

-(void)loadValidateView
{
    self.codeImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@image/code?tel=%@",APIURLCOMMON,tel]]]];
}

-(void)dismiss
{
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.textF resignFirstResponder];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length>1) {
        return NO;
    }
    
    NSCharacterSet *setToRemove =[[ NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"]
                                  invertedSet ];
    NSString *stringChar = [[string componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    
    if (string.length == 1) {
        
        if (!stringChar.length) {
            return NO;
        }
        if (range.location == 0) {
            self.labelOne.text = stringChar;
        }else if (range.location == 1){
            self.labelTwo.text = stringChar;
        }else if (range.location == 2){
            self.labelThree.text = stringChar;
        }else if (range.location == 3){
            self.labelFour.text = stringChar;
            [self getCode:[NSString stringWithFormat:@"%@%@",textField.text,stringChar]];
        }else{
            return NO;
        }
        
        return YES;
    }else{
        if (range.location == 0) {
            self.labelOne.text = stringChar;
        }else if (range.location == 1){
            self.labelTwo.text = stringChar;
        }else if (range.location == 2){
            self.labelThree.text = stringChar;
        }else if (range.location == 3){
            self.labelFour.text = stringChar;
            [self getCode:[NSString stringWithFormat:@"%@%@",textField.text,stringChar]];
        }else{
            return NO;
        }
        
        return YES;
    }
    
    
}

-(void)getCode:(NSString *)code
{
    JGSVPROGRESSLOAD(@"正在发送验证码");
    [JGHTTPClient getAMessageAboutCodeByphoneNum:tel type:type imageCode:code Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        JGLog(@"%@",responseObject[@"code"]);
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"]integerValue]==200) {
            
            completeBlock(@"");
            [self dismiss];
            
        }else{
            self.textF.text = nil;
            self.labelOne.text = self.labelTwo.text = self.labelThree.text = self.labelFour.text = nil;
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
        self.textF.text = nil;
        self.labelOne.text = self.labelTwo.text = self.labelThree.text = self.labelFour.text = nil;
    }];
}


- (IBAction)close:(UIButton *)sender {
    
    [self dismiss];
    
}
- (IBAction)refresh:(UIButton *)sender {
    
    [self loadValidateView];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textF becomeFirstResponder];
}

@end
