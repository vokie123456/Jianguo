//
//  WalletHeadView.m
//  JianGuo
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "WalletHeadView.h"

#define BottomFuBiaoHeight 8

@implementation WalletHeadView

+(instancetype)aWalletHeadView
{
  
    WalletHeadView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
      return headerView;
}

-(void)awakeFromNib
{
    CGFloat height;
    if (SCREEN_W == 320) {
        height = 295*(SCREEN_W/375)+35;
    }else if (SCREEN_W == 375){
        height = 295*(SCREEN_W/375);
    }else if (SCREEN_W == 414){
        height = 295*(SCREEN_W/375)-20;
    }
    self.frame = CGRectMake(0, 0, SCREEN_W, height);
    self.bgImgView.frame = CGRectMake(0, 0, SCREEN_W, height-15);
    
    self.moneyL.frame = CGRectMake(0, 100, SCREEN_W, 50);
    self.cashBtn.frame = CGRectMake(SCREEN_W/2-50, self.moneyL.bottom+10, 100, 25);
    self.horiLineView.frame = CGRectMake(0, self.cashBtn.bottom+40, SCREEN_W, 2);
    self.verLinrView.frame = CGRectMake(SCREEN_W/2-1, self.horiLineView.bottom, 2, height-self.horiLineView.bottom-15);
    self.getBtn.frame = CGRectMake(0, self.horiLineView.bottom, SCREEN_W/2-1, height-self.horiLineView.bottom-15);
    self.giveBtn.frame = CGRectMake(SCREEN_W/2+1, self.horiLineView.bottom, SCREEN_W/2-1, height-self.horiLineView.bottom-15);
    self.bottomView.frame = CGRectMake(0, self.giveBtn.bottom-BottomFuBiaoHeight, SCREEN_W/2-1, BottomFuBiaoHeight);
}

-(void)setModel:(WalletModel *)model
{
    _model = model;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",model.money.floatValue]];
    
    NSInteger length = string.length;
    UIFont *font = [UIFont systemFontOfSize:30];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(length-2, 2)];
    
    self.moneyL.attributedText = string;
}
/*
- (IBAction)inComeBtn:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(0, self.giveBtn.bottom-BottomFuBiaoHeight, SCREEN_W/2-1, BottomFuBiaoHeight);
    }];
    if ([self.delegate respondsToSelector:@selector(clickIncomeBtn)]) {
        [self.delegate clickIncomeBtn];
    }
    
}

- (IBAction)payBtn:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(SCREEN_W/2+1, self.giveBtn.bottom-BottomFuBiaoHeight, SCREEN_W/2-1, BottomFuBiaoHeight);
    }];
    if ([self.delegate respondsToSelector:@selector(clickPayBtn)]) {
        [self.delegate clickPayBtn];
    }
}
- (IBAction)getCashBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickCashBtn)]) {
        [self.delegate clickCashBtn];
    }
    
}

*/


@end
