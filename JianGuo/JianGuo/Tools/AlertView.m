//
//  AlertView.m
//  JianGuo
//
//  Created by apple on 17/8/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "AlertView.h"
#import "NSObject+HudView.h"

static const NSTimeInterval animationDuration = 0.3;
static const CGFloat scale = 0.001f;

@implementation AlertView
{
    __weak IBOutlet UIView *alertView;
    void(^_block)(NSString *price);
    __weak IBOutlet UITextField *moneyTF;
}

+(instancetype)aAlertViewCallBackBlock:(void(^)(NSString *))block
{
    AlertView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    view->_block = block;
    return view;
}

-(void)show
{
    self.backgroundColor = [UIColor clearColor];
    alertView.transform = CGAffineTransformMakeScale(scale, scale);
    alertView.alpha = 0.3;
    self.frame = APPLICATION.keyWindow.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    [APPLICATION.keyWindow addSubview:self];
    
    [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        alertView.transform = CGAffineTransformMakeScale(1.2*(SCREEN_W/375), 1.2*(SCREEN_W/375));
        alertView.alpha = 1;
        
    } completion:^(BOOL finished) {
        [moneyTF becomeFirstResponder];
    }];
    
    moneyTF.delegate = self;
}

- (IBAction)close:(id)sender {
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        alertView.transform = CGAffineTransformMakeScale(scale, scale);
        alertView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

- (IBAction)sure:(id)sender {
    
    if (moneyTF.text.length) {
        if (_block) {
            _block(moneyTF.text);
        }
    }
    if (moneyTF.text.length==0) {
        [self showAlertViewWithText:@"请输入调整后价格!" duration:1.5f];
        return;
    }
    [self close:nil];
    
}
- (IBAction)limit:(id)sender {
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{//textField 的text内容是不包括当前输入的字符的字符串,string就是当前输入的字符<即 texgField.text+string 就是最终显示的内容>
    if ([textField.text rangeOfString:@"."].location!=NSNotFound) {//包含'.'
        if ([[textField.text componentsSeparatedByString:@"."].lastObject length]>=2) {
            if ([@"0123456789." containsString:string]) {
                return NO;
            }else
                return YES;
        }else if ([string isEqualToString:@"."]){
            return NO;
        }
    }
    return YES;
}

@end
