//
//  MyWalletHeadView.m
//  JianGuo
//
//  Created by apple on 16/11/25.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MyWalletHeadView.h"

@implementation MyWalletHeadView

-(void)setMoney:(NSString *)money
{
    _money = money;
    self.moneyL.text = [NSString stringWithFormat:@"%@",money];
}

+(instancetype)aWalletHeadView
{
    
    MyWalletHeadView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    return headerView;
}

-(void)awakeFromNib
{
    CGFloat height = 145;
//    if (SCREEN_W == 320) {
//        height = 145*(SCREEN_W/375)+35;
//    }else if (SCREEN_W == 375){
//        height = 145*(SCREEN_W/375);
//    }else if (SCREEN_W == 414){
//        height = 145*(SCREEN_W/375)-20;
//    }
    self.frame = CGRectMake(0, 0, SCREEN_W, height);
}
- (IBAction)clickGetCash:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickCashBtn)]) {
        [self.delegate clickCashBtn];
    }
    
}

@end
