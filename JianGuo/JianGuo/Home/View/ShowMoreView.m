//
//  ShowMoreView.m
//  JianGuo
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "ShowMoreView.h"

@implementation ShowMoreView

/**
 *  报名提示view
 */
+(instancetype)aShowMoreView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}
-(void)awakeFromNib
{
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
}

-(void)show
{
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.bgView.transform = CGAffineTransformMakeTranslation(0, self.bgView.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3f animations:^{
        
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        self.bgView.transform = CGAffineTransformIdentity;
    }];
}
-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        self.bgView.transform = CGAffineTransformMakeTranslation(0, self.bgView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

@end
